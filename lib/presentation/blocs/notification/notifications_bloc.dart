import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/domain/entities/push_message.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    // on<NotificationsEvent>((event, emit) {});
    on<NotificationsStatusChanged>(_notificationsStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    //verificar estado de las notifications
    _initialStatusCheck();
//Listener para notificaciones  en foreground
    _onForegroundMessage();
  }
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

// token dZV_GeiJQXC5PSkcOZSSwU:APA91bEzBmOle8k7DjmQPtLJWvzmSDEYmSPNxI75mDBnLtrSiz17tYGwf2dK2-O43SAgDisZggUIliiIHKpLd2GapUkjHB1tHghkddUTpGZtaIgo0C-AowDlMBBJEQRkJh68QmLl47cS
  void _notificationsStatusChanged(
      NotificationsStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copiWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageReceived(
      NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(state
        .copiWith(notification: [event.pushMessage, ...state.notification]));
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    // settings.authorizationStatus;
    add(NotificationsStatusChanged(status: settings.authorizationStatus));
    // _getFCMToken();
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    await messaging.getToken();
    // print(token);
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
        messageId:
            message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        sentDate: message.sentTime ?? DateTime.now(),
        imageUrl: Platform.isAndroid
            ? message.notification!.android?.imageUrl
            : message.notification!.apple?.imageUrl,
        data: message.data);

    // print(notification);
    add(NotificationReceived(pushMessage: notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
    // listener.cancel();// если мы хотим почистить. но мы должны слушать
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationsStatusChanged(status: settings.authorizationStatus));
    settings.authorizationStatus;
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist =
        state.notification.any((element) => element.messageId == pushMessageId);
    if (!exist) return null;
    return state.notification
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
