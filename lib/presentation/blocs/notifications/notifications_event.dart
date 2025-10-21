part of 'notifications_bloc.dart';

abstract class NotificationsEvent{
  const NotificationsEvent();


}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

//mas de 3 usar como objeto
  NotificationStatusChanged(this.status);

}

class NotificationInScreen extends NotificationsEvent {

    final PushMessage pushMessage;

  NotificationInScreen(this.pushMessage);
  
}