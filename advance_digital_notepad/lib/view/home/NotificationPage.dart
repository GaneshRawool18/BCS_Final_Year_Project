// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   List<String> notifications = [];
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _listenToTasks();
//   }

//   void _initializeNotifications() async {
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   void _listenToTasks() {
//     FirebaseFirestore.instance
//         .collection('tasks')
//         .snapshots()
//         .listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final String title = data['title'];
//         final Timestamp timestamp = data['timestamp'];

//         _scheduleNotification(title, timestamp.toDate());

//         setState(() {
//           notifications.insert(0, "New Task: $title");
//         });
//       }
//     });
//   }

//   void _scheduleNotification(String title, DateTime dateTime) async {
//     final int id = dateTime.millisecondsSinceEpoch.remainder(100000);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       'Task Reminder',
//       title,
//       tz.TZDateTime.from(dateTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_channel',
//           'Task Notifications',
//           channelDescription: 'Notification for scheduled tasks',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: notifications.isEmpty
//           ? const Center(
//               child: Text(
//                 "No notifications yet.",
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(10),
//               child: ListView.builder(
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).cardColor,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.notifications,
//                             color: Colors.blueAccent),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             notifications[index],
//                             style: TextStyle(
//                               fontSize:
//                                   MediaQuery.of(context).size.width * 0.045,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
