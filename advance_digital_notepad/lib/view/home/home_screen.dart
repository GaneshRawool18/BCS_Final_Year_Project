import 'dart:io';
import 'package:advance_digital_notepad/controller/todo_controller.dart';
import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/controller/calendar_controller.dart';
import 'package:advance_digital_notepad/view/expense/categorie_page.dart';
import 'package:advance_digital_notepad/view/expense/graph_page.dart';
import 'package:advance_digital_notepad/view/home/NotificationPage.dart';
import 'package:advance_digital_notepad/view/home/expense_manager.dart';
import 'package:advance_digital_notepad/view/home/tasks_for_date_page.dart';
import 'package:advance_digital_notepad/view/profile/about_us.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final UserController userController = Get.find<UserController>();
  final ToDoController toDoController = Get.put(ToDoController());
  final CalendarController calendarController = Get.put(CalendarController());

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Define a constant date format used across the app.
  final DateFormat dateFormat = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    // Whenever the taskList updates, reload the calendar events.
    ever(toDoController.taskList, (_) {
      calendarController.loadEvents(toDoController.taskList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          // Container(
          //   margin: EdgeInsets.only(
          //       right: MediaQuery.of(context).size.width * 0.03),
          //   padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Color.fromARGB(255, 220, 222, 222),
          //   ),
          //   child: IconButton(
          //     icon: const Icon(Icons.notifications, size: 22),
          //     onPressed: () {
          //       Get.to(() => const NotificationPage());
          //     },
          //   ),
          // ),
          // // Calendar button toggles calendar view.
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 28),
            onPressed: () {
              calendarController.toggleCalendar();
            },
          ),
          
        ],
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.width * 0.005,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
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
                // Profile Image from UserController (static display)
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Obx(() {
                    String imgPath = userController.profileImagePath.value;
                    if (imgPath.isNotEmpty && !imgPath.startsWith("assets/")) {
                      File imageFile = File(imgPath);
                      if (imageFile.existsSync()) {
                        return Image.file(imageFile, fit: BoxFit.cover);
                      } else {
                        return Image.asset("assets/images/profile_pic.png",
                            fit: BoxFit.cover);
                      }
                    } else {
                      return Image.asset("assets/images/profile_pic.png",
                          fit: BoxFit.cover);
                    }
                  }),
                ),
                const SizedBox(width: 15),
                // Welcome and Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          "Welcome,\n${userController.userName.value}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    Obx(() => Text(
                          userController.email.value,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          // Quick Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.attach_money, "Transactions",
                  () => Get.to(() => const ExpenseManager())),
              _buildActionButton(Icons.pie_chart, "Graphs",
                  () => Get.to(() => const GraphPage())),
              _buildActionButton(Icons.category, "Category",
                  () => Get.to(() => const CategoriePage())),
              _buildActionButton(
                  Icons.info, "About Us", () => Get.to(() => const AboutUs())),
            ],
          ),
          // Calendar Widget (visible when toggled)
          Obx(() {
            if (calendarController.showCalendar.value) {
              return Container(
                margin: const EdgeInsets.all(2.0),
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  eventLoader: (day) {
                    final normalizedDay =
                        DateTime(day.year, day.month, day.day);
                    return calendarController.getEventsForDay(normalizedDay);
                  },
                  calendarBuilders: CalendarBuilders(
                    // Update markerBuilder to show a custom icon
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: 1,
                          child: Icon(
                            Icons.event_available, // custom marker icon
                            color: Colors.redAccent,
                            size: 16,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    // Navigate to the TasksForDatePage with the selected day
                    Get.to(() => TasksForDatePage(date: selectedDay));
                  },
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
          // Task Categories Section
          Expanded(
            child: Obx(() {
              // Use the common date format "MM/dd/yyyy"
              String today = dateFormat.format(DateTime.now());
              String tomorrow = dateFormat
                  .format(DateTime.now().add(const Duration(days: 1)));
              var todayTasks = toDoController.taskList
                  .where((task) => task.date == today)
                  .toList();
              var tomorrowTasks = toDoController.taskList
                  .where((task) => task.date == tomorrow)
                  .toList();
              var futureTasks = toDoController.taskList.where((task) {
                try {
                  return dateFormat
                      .parse(task.date)
                      .isAfter(DateTime.now().add(const Duration(days: 1)));
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

  // Widget for a task section
  Widget _buildTaskSection(String title, List tasks) {
    return tasks.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: const Icon(Icons.task, color: Colors.blue),
                      title: Text(task.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text("Due: ${task.date}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirm Deletion"),
                                content: const Text(
                                    "Are you sure you want to delete this task?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirm == true) {
                            toDoController.removeTask(index);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : const SizedBox();
  }

  // Widget for quick action buttons.
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[200],
            child: Icon(icon, size: 28, color: Colors.green[900]),
          ),
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
