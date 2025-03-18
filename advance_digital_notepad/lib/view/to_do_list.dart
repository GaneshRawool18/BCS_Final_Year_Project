import 'package:advance_digital_notepad/controller/todo_controller.dart';
import 'package:advance_digital_notepad/model/note_model_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ToDoList extends StatelessWidget {
  final ToDoController toDoController = Get.put(ToDoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "To-Do List",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
      ),
      body: Obx(() => ListView.builder(
            itemCount: toDoController.taskList.length,
            itemBuilder: (context, index) {
              var task = toDoController.taskList[index];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[100],
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    task.description,
                                    style: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Due: ${task.date}",
                                    style: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.redAccent),
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
                            onPressed: () => _showBottomSheet(context, task, index, isEdit: true),
                            icon: SvgPicture.asset("assets/svg/edit.svg"),
                          ),
                          IconButton(
                            onPressed: () => toDoController.removeTask(index),
                            icon: SvgPicture.asset("assets/svg/delete.svg"),
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, ShowModelClass? task, int? index, {required bool isEdit}) {
  TextEditingController titleController = TextEditingController(text: isEdit ? task!.title : '');
  TextEditingController descriptionController = TextEditingController(text: isEdit ? task!.description : '');
  TextEditingController dateController = TextEditingController(text: isEdit ? task!.date : '');

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isEdit ? "Edit To-Do" : "Create To-Do",
                    style: GoogleFonts.quicksand(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            _buildTextField(titleController, "Enter Title"),
            _buildTextField(descriptionController, "Enter Description"),
            _buildDateField(context, dateController),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          dateController.text.isNotEmpty) {
                        if (isEdit) {
                          toDoController.editTask(index!, ShowModelClass(
                            id: task!.id, // Keep existing task ID
                            title: titleController.text,
                            description: descriptionController.text,
                            date: dateController.text,
                          ));
                        } else {
                          toDoController.addTask(ShowModelClass(
                            id: "", // Firebase generates an ID
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
                      style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "MM/DD/YYYY",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));
            if (pickedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            }
          },
        ),
      ),
    );
  }
}
