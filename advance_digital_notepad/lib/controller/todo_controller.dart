import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/note_model_class.dart';

class ToDoController extends GetxController {
  var taskList = <ShowModelClass>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  /// **🔹 Get Current Logged-in User ID**
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// **🛠 Fetch Tasks for the Logged-in User**
  Future<void> fetchTasks() async {
    String? userId = getCurrentUserId();
    if (userId == null) {
      taskList.clear();
      return;
    }

    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .orderBy("date", descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        print("No tasks found in Firebase. Loading from local storage...");
        loadTasksFromLocal(
            userId); // ✅ Load previous session tasks only for this user
      } else {
        taskList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          return ShowModelClass(
            id: doc.id,
            title: data["title"],
            description: data["description"],
            date: data["date"],
          );
        }).toList();

        saveTasksToLocal(userId); // ✅ Sync local storage with Firebase
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      loadTasksFromLocal(userId); // ✅ Load previous session tasks on error
    }
  }

  /// **📤 Add a New Task for Logged-in User**
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

      taskList.add(task.copyWith(id: docRef.id)); // Add task locally
      saveTasksToLocal(userId);
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  /// **✏ Edit an Existing Task**
  Future<void> editTask(int index, ShowModelClass updatedTask) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    String taskId = taskList[index].id; // Get task ID

    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("tasks")
          .doc(taskId)
          .update({
        "title": updatedTask.title,
        "description": updatedTask.description,
        "date": updatedTask.date,
      });

      taskList[index] = updatedTask.copyWith(id: taskId);
      update();
      saveTasksToLocal(userId);
    } catch (e) {
      print("Error editing task: $e");
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
      saveTasksToLocal(userId);
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  /// **💾 Save Tasks Locally (Per User)**
  Future<void> saveTasksToLocal(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = taskList
        .map((task) =>
            "${task.id}|${task.title}|${task.description}|${task.date}")
        .toList();
    await prefs.setStringList('tasks_$userId', tasks);
  }

  /// **🔄 Load Tasks from Local Storage (Per User)**
  Future<void> loadTasksFromLocal(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('tasks_$userId');
    if (tasks != null) {
      taskList.value = tasks.map((task) {
        var data = task.split("|");
        return ShowModelClass(
          id: data[0],
          title: data[1],
          description: data[2],
          date: data[3],
        );
      }).toList();
    }
  }
}
