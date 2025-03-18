import 'package:advance_digital_notepad/controller/todo_controller.dart';
import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/view/NotificationPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final ToDoController toDoController = Get.put(ToDoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 220, 222, 222),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications, size: 28),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const NotificationPage();
                }));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // **Profile Section**
          Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02, vertical: MediaQuery.of(context).size.width * 0.02),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  blurStyle: BlurStyle.outer,
                  color: Color.fromARGB(255, 133, 132, 132),
                )
              ],
              gradient: LinearGradient(
                colors: [Color(0xFF0E9F7D), Color(0xFF14A17D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          "Welcome, ${userController.userName.value}",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    Obx(() => Text(
                          userController.email.value,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        )),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // **Quick Action Buttons**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.attach_money, "Transactions"),
              _buildActionButton(Icons.pie_chart, "Graphs"),
              _buildActionButton(Icons.category, "Category"),
              _buildActionButton(Icons.info, "About Us"),
            ],
          ),

          const SizedBox(height: 20),

          // **Task Categories**
          Expanded(
  child: Obx(() {
    var today = DateFormat.yMMMd().format(DateTime.now());
    var tomorrow = DateFormat.yMMMd().format(DateTime.now().add(Duration(days: 1)));

    var todayTasks = toDoController.taskList.where((task) => task.date == today).toList();
    var tomorrowTasks = toDoController.taskList.where((task) => task.date == tomorrow).toList();

    var futureTasks = toDoController.taskList.where((task) {
      try {
        return DateFormat.yMMMd().parse(task.date).isAfter(DateTime.now().add(Duration(days: 1)));
      } catch (e) {
        print("Date format error: ${task.date} - $e");
        return false;
      }
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        _buildTaskSection("Today's Tasks", todayTasks),
        _buildTaskSection("Tomorrow's Tasks", tomorrowTasks),
        _buildTaskSection("Upcoming Tasks", futureTasks),
      ],
    );
  }),
),

        ],
      ),
    );
  }

  // **Task Section Widget**
  Widget _buildTaskSection(String title, List tasks) {
    return tasks.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: const Icon(Icons.task, color: Colors.blue),
                      title: Text(tasks[index].title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text("Due: ${tasks[index].date}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => toDoController.removeTask(index),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : const SizedBox();
  }

  // **Quick Action Buttons**
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[200],
          child: Icon(icon, size: 28, color: Colors.green[900]),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
