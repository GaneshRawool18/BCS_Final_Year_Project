import 'package:advance_digital_notepad/controller/todo_controller.dart';
import 'package:advance_digital_notepad/model/note_model_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

String updatedDate = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

class ToDoList extends StatelessWidget {
  final ToDoController toDoController = Get.put(ToDoController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          "To-Do List",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode
            ? Colors.grey[900]
            : const Color.fromRGBO(2, 167, 177, 1),
      ),
      body: Obx(() => ListView.builder(
            itemCount: toDoController.taskList.length,
            itemBuilder: (context, index) {
              var task = toDoController.taskList[index];

              // Parse due date
              DateTime? dueDate;
              try {
                dueDate = DateFormat('MM/dd/yyyy').parse(task.date);
              } catch (e) {
                dueDate = null;
              }
              bool isOverdue =
                  dueDate != null && dueDate.isBefore(DateTime.now());

              // Card color
              Color? cardColor;
              if (isOverdue) {
                cardColor = (isDarkMode ? Colors.grey[850] : Colors.blue[100])
                    ?.withOpacity(0.4);
              } else {
                cardColor = isDarkMode ? Colors.grey[850] : Colors.blue[100];
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: cardColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 7, top: 10),
                            width: 77,
                            height: 77,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                "assets/images/todo.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Due: ${task.date}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 246, 25, 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () => _showBottomSheet(
                                context, task, index,
                                isEdit: true),
                            icon: SvgPicture.asset(
                              "assets/svg/edit.svg",
                              color: isDarkMode ? Colors.white : null,
                            ),
                          ),
                          IconButton(
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
                            icon: SvgPicture.asset(
                              "assets/svg/delete.svg",
                              color: isDarkMode ? Colors.white : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context, null, null, isEdit: false),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, ShowModelClass? task, int? index,
      {required bool isEdit}) {
    TextEditingController titleController =
        TextEditingController(text: isEdit ? task!.title : '');
    TextEditingController descriptionController =
        TextEditingController(text: isEdit ? task!.description : '');
    TextEditingController dateController =
        TextEditingController(text: isEdit ? task!.date : '');

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  isEdit ? "Edit To-Do" : "Create To-Do",
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              _buildTextField(titleController, "Enter Title", isDarkMode),
              _buildTextField(
                  descriptionController, "Enter Description", isDarkMode),
              _buildDateField(context, dateController, isDarkMode),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          dateController.text.isNotEmpty) {
                        if (isEdit && index != null) {
                          final task = toDoController.taskList[index];
                          toDoController.editTask(
                            task.id,
                            titleController.text,
                            descriptionController.text,
                            newDate: dateController.text != task.date
                                ? dateController.text
                                : null,
                          );
                        } else {
                          toDoController.addTask(ShowModelClass(
                            id: "",
                            title: titleController.text,
                            description: descriptionController.text,
                            date: dateController.text,
                          ));
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, bool isDarkMode) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
        filled: true,
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildDateField(
      BuildContext context, TextEditingController controller, bool isDarkMode) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: isDarkMode
                    ? ColorScheme.dark(
                        primary: Colors.tealAccent,
                        onPrimary: Colors.black,
                        surface: Colors.grey[900]!,
                        onSurface: Colors.white,
                      )
                    : ColorScheme.light(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                dialogBackgroundColor:
                    isDarkMode ? Colors.grey[900] : Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "MM/DD/YYYY",
            hintStyle:
                TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: Icon(Icons.calendar_today,
                color: isDarkMode ? Colors.white70 : Colors.black54),
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

//main