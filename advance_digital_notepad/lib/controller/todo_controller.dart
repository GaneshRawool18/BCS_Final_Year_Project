import 'dart:developer';
import 'package:advance_digital_notepad/controller/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../model/note_model_class.dart';


class ToDoController extends GetxController {
  var taskList = <ShowModelClass>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Database? _database;

  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
  }

  /// **🛠 Initialize Local Database**
  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id TEXT PRIMARY KEY, userId TEXT, title TEXT, description TEXT, date TEXT)",
        );
      },
      version: 1,
    );

    fetchTasks();
  }

  /// **🔹 Get Current Logged-in User ID**
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// **🛠 Fetch Tasks for the Logged-in User**
  Future<void> fetchTasks() async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    taskList.clear();

    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .orderBy("date", descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        await loadTasksFromLocal(userId); // Load from local if no tasks in Firestore
      } else {
        taskList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          return ShowModelClass(
            id: doc.id,
            title: data["title"] ?? "",
            description: data["description"] ?? "",
            date: data["date"] ?? "",
          );
        }).toList();
        await saveTasksToLocal(userId);
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      await loadTasksFromLocal(userId);
    }
  }

  /// **📤 Add a New Task**
  Future<void> addTask(ShowModelClass task) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    try {
      var docRef = await _firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .add({
        "title": task.title,
        "description": task.description,
        "date": task.date,
      });

      taskList.add(task.copyWith(id: docRef.id));
      await saveTasksToLocal(userId);

      // Schedule notifications immediately after task creation.
      // Immediate notification:
      await NotificationService().showImmediateNotification(
        id: 1000, // Unique ID
        title: 'Task Created',
        body: 'Your task has been created successfully.',
      );

      // Parse task date, assuming format "yyyy-MM-dd HH:mm"
      DateTime taskDate = DateFormat('yyyy-MM-dd HH:mm').parse(task.date);
      DateTime before24Hour = taskDate.subtract(const Duration(hours: 24));

      if (before24Hour.isAfter(DateTime.now())) {
        // Schedule 24-hour reminder:
        await NotificationService().scheduleNotification(
          id: 2000,
          title: 'Upcoming Task Reminder',
          body: 'Your task "${task.title}" is due in 24 hours!',
          scheduledTime: before24Hour,
        );

        // Schedule hourly reminders from 24 hours before until task time.
        await NotificationService().scheduleHourlyRepeatingNotifications(
          startId: 3000,
          title: 'Hourly Task Reminder',
          body: 'Reminder: Your task "${task.title}" is approaching its due time.',
          startTime: before24Hour,
          endTime: taskDate,
        );
      }
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  /// **🗑 Remove a Task**
  Future<void> removeTask(int index) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    String taskId = taskList[index].id;

    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .doc(taskId)
          .delete();
      taskList.removeAt(index);
      await saveTasksToLocal(userId);
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  /// **💾 Save Tasks to Local Storage (SQFlite)**
  Future<void> saveTasksToLocal(String userId) async {
    if (_database == null) return;
    try {
      await _database!.delete('tasks', where: "userId = ?", whereArgs: [userId]);
      for (var task in taskList) {
        await _database!.insert(
          'tasks',
          {
            "id": task.id,
            "userId": userId,
            "title": task.title,
            "description": task.description,
            "date": task.date,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print("Error saving tasks locally: $e");
    }
  }

  /// **🔄 Load User's Tasks from Local Database**
  Future<void> loadTasksFromLocal(String userId) async {
    if (_database == null) return;
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'tasks',
        where: "userId = ?",
        whereArgs: [userId],
      );
      taskList.value = List.generate(maps.length, (i) {
        return ShowModelClass(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          date: maps[i]['date'],
        );
      });
    } catch (e) {
      print("Error loading tasks from local database: $e");
    }
  }

  /// **✏ Edit Task**  
  /// Updates title, description, and optionally the date. If a new date is provided,
  /// cancel the current notifications and schedule new ones without affecting existing logic.
  Future<void> editTask(String taskId, String newTitle, String newDesc, {String? newDate}) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    try {
      Map<String, dynamic> updatedFields = {
        'title': newTitle,
        'description': newDesc,
      };

      if (newDate != null) {
        updatedFields['date'] = newDate;
      }

      await _firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .doc(taskId)
          .update(updatedFields);

      // Update the local in-memory list.
      int index = taskList.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        taskList[index] = taskList[index].copyWith(
          title: newTitle,
          description: newDesc,
          date: newDate ?? taskList[index].date,
        );
        await saveTasksToLocal(userId);
      }

      // Cancel previously scheduled notifications.
      await NotificationService().cancelNotification(2000);
      List<int> hourlyIds = List.generate(100, (index) => 3000 + index);
      await NotificationService().cancelNotifications(hourlyIds);

      // If a new date was provided, schedule updated notifications.
      if (newDate != null) {
        DateTime taskDate = DateFormat('yyyy-MM-dd HH:mm').parse(newDate);
        DateTime before24Hour = taskDate.subtract(const Duration(hours: 24));

        if (before24Hour.isAfter(DateTime.now())) {
          await NotificationService().scheduleNotification(
            id: 2000,
            title: 'Upcoming Task Reminder',
            body: 'Your task "$newTitle" is due in 24 hours!',
            scheduledTime: before24Hour,
          );

          await NotificationService().scheduleHourlyRepeatingNotifications(
            startId: 3000,
            title: 'Hourly Task Reminder',
            body: 'Reminder: Your task "$newTitle" is approaching its due time.',
            startTime: before24Hour,
            endTime: taskDate,
          );
        }
      }

      log("Task updated successfully: $taskId");
    } catch (e) {
      log("Error updating task: $e");
    }
  }

  /// **🔴 Logout User and Clear Tasks**
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      taskList.clear();
      await clearLocalStorage();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  /// **🗑 Clear Local Storage on Logout**
  Future<void> clearLocalStorage() async {
    if (_database == null) return;
    try {
      await _database!.delete('tasks');
    } catch (e) {
      print("Error clearing local storage: $e");
    }
  }
}
