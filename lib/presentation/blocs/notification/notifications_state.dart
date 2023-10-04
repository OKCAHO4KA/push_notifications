part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<PushMessage> notification;
  const NotificationsState(
      {this.status = AuthorizationStatus.notDetermined,
      this.notification = const []});

  NotificationsState copiWith(
          {AuthorizationStatus? status, List<PushMessage>? notification}) =>
      NotificationsState(
          status: status ?? this.status,
          notification: notification ?? this.notification);

  @override
  List<Object> get props => [status, notification];
}
