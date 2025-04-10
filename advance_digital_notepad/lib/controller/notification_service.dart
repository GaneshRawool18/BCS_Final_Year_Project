import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the local notification plugin.
  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@mipmap/todo");

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// Displays an immediate notification.
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for task events',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }

  /// Schedules a one-time notification at the given [scheduledTime].
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Notifications',
          channelDescription: 'Notifications for task events',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedules hourly notifications from [startTime] until [endTime].
  Future<void> scheduleHourlyRepeatingNotifications({
    required int startId,
    required String title,
    required String body,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final int totalHours = endTime.difference(startTime).inHours;
    for (int i = 0; i <= totalHours; i++) {
      DateTime scheduledTime = startTime.add(Duration(hours: i));
      if (scheduledTime.isAfter(endTime)) break;
      await scheduleNotification(
        id: startId + i,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
      );
    }
  }

  /// Cancels a notification by its [id].
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancels multiple notifications by a list of [ids].
  Future<void> cancelNotifications(List<int> ids) async {
    for (int id in ids) {
      await cancelNotification(id);
    }
  }
}
