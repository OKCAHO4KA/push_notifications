part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationsStatusChanged({required this.status});
}

class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;

  NotificationReceived({required this.pushMessage});
}
