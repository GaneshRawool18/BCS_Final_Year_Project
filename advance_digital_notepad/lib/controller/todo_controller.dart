import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/note_model_class.dart';

class ToDoController extends GetxController {
  var taskList = <ShowModelClass>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasksFromLocal();
    fetchTasks();
  }

  /// **🛠 Fetch tasks from Firebase**
  Future<void> fetchTasks() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .get();

    taskList.value = snapshot.docs.map((doc) {
      var data = doc.data();
      return ShowModelClass(
        id: doc.id, // Use Firebase document ID
        title: data["title"],
        description: data["description"],
        date: data["date"],
      );
    }).toList();

    saveTasksToLocal(); // Sync with local storage
  }

  /// **📤 Add a new task to Firebase**
  Future<void> addTask(ShowModelClass task) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var docRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .add({
      "title": task.title,
      "description": task.description,
      "date": task.date,
    });

    taskList.add(task.copyWith(id: docRef.id)); // Update local list
    saveTasksToLocal();
  }

  /// **✏ Edit an existing task**
  Future<void> editTask(int index, ShowModelClass updatedTask) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String taskId = taskList[index].id; // Get task ID

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(taskId)
        .update({
      "title": updatedTask.title,
      "description": updatedTask.description,
      "date": updatedTask.date,
    });

    taskList[index] = updatedTask.copyWith(id: taskId); // Keep ID unchanged
    update();
    saveTasksToLocal();
  }

  /// **🗑 Remove Task**
  Future<void> removeTask(int index) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String taskId = taskList[index].id;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(taskId)
        .delete();

    taskList.removeAt(index);
    saveTasksToLocal();
  }

  /// **💾 Save tasks locally**
  Future<void> saveTasksToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = taskList
        .map((task) => "${task.id}|${task.title}|${task.description}|${task.date}")
        .toList();
    await prefs.setStringList('tasks', tasks);
  }

  /// **🔄 Load tasks from local storage**
  Future<void> loadTasksFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('tasks');
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
