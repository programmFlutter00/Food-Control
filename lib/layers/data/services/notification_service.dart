// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();
//   factory NotificationService() {
//     return _notificationService;
//   }
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   NotificationService._internal();

//   Future<void> initNotification() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("ic_launcher");
//     const IOSInitializationSettings iosInitializationSettingsIos =
//         IOSInitializationSettings(
//           requestAlertPermission: false,
//           requestBadgePermission: false,
//           requestSoundPermission: false,
//         );
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: iosInitializationSettingsIos,
//         );
//     await flutterLocalNotificationsPlugin.initialize(
//       settings: initializationSettings,
//     );
//   }

//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     // required DateTime scheduledDate,
//   }) async {
//     flutterLocalNotificationsPlugin.zonedSchedule(
//       id: id,
//       title: title,
//       body: body,
//       scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
//       notificationDetails: const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'mian_channel',
//           "Main_channel",
//           importance: Importance.max,
//           priority: Priority.max,
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'default_wav',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   Future<void> cancelNotification() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
