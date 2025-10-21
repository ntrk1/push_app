
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:push_notifications/config/router/app_router.dart';
import 'package:push_notifications/config/theme/app_theme.dart';
import 'package:push_notifications/presentation/blocs/notifications/notifications_bloc.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFirebaseNotifications();


  runApp(
    MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => NotificationsBloc(),
      )
    ], 
    child: const MainApp()
    ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) => HandlerNotificationInteraction(child: child!,),
    );
  }
}


class HandlerNotificationInteraction extends StatefulWidget {
  final Widget child;
  const HandlerNotificationInteraction({super.key, required this.child});

  @override
  State<HandlerNotificationInteraction> createState() => _HandlerNotificationInteractionState();
}

class _HandlerNotificationInteractionState extends State<HandlerNotificationInteraction> {


  void _handlerMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handlerRemoteMessage(message);
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');
    appRouter.push('/push-details/$messageId');
  }


  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handlerMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlerMessage);
  }


@override
  void initState() {
    super.initState();

    setupInteractedMessage();
  }



  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}