import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static Future<void> requestPermissionLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void showLocalNotification(
      {required int id, String? titulo, String? body, String? data}) {
    const androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high);

    const notificationDetails = NotificationDetails(android: androidDetails);

    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationPlugin.show(id, titulo, body, notificationDetails,
        payload: data);
  }
}
