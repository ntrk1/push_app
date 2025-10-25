import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/domain/entities/push_message.dart';
import 'package:push_notifications/firebase_options.dart';


part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}



class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNotificationId = 0;

  final Future<void> Function()? requestPermissionLocalNotification;
  final void Function({
     required int id,
     String? title,
     String? body,
     String? data
  })? showLocalNotification;
  

  NotificationsBloc({
    this.showLocalNotification,
    this.requestPermissionLocalNotification
    }) : super(NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationInScreen>(_onNotificationInScreen);
    _initialStatusCheck();
    _onForegroundMessage();
    
  }





   static Future<void> initializeFirebaseNotifications() async {
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform
    );
   }
  //HOME SCREEN
  void requestPermision() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );
    if (requestPermissionLocalNotification != null) {
    await requestPermissionLocalNotification!();
    }
    add(NotificationStatusChanged(settings.authorizationStatus));
    
  }

      void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }



  void handlerRemoteMessage(RemoteMessage message) {
    
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId
      ?.replaceAll(':', '')
      .replaceAll('%', '') ?? '', 
      title: message.notification!.title ?? '', 
      body: message.notification!.body ?? '', 
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid  
      ? message.notification!.android?.imageUrl
      : message.notification!.apple?.imageUrl
      );

      if (showLocalNotification != null) {
      showLocalNotification!(
        id: ++pushNotificationId,
        body: notification.body,
        data: notification.messageId,
        title: notification.title,
      );
      }
      add(NotificationInScreen(notification));
  } 
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handlerRemoteMessage);
  }

  
      void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }


void _onNotificationInScreen(NotificationInScreen event, Emitter<NotificationsState> emit) {
  emit(
    state.copyWith(
      notifications: [event.pushMessage, ... state.notifications]
    )
  );
}




  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit)  {
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any(
      (element) => element.messageId == pushMessageId);

      if (!exist) return null;
      return state.notifications.firstWhere(
        (element) => element.messageId == pushMessageId);
  }






}
