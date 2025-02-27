import "package:advance_digital_notepad/model/note_model_class.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:intl/intl.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<StatefulWidget> {
  bool isModeOn = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<ShowModelClass> taskList = [
    // ShowModelClass(title: "Ganesh", description: "Java , flutter" ,  date: "oct 22 24"),
  ];

  List<Color> myColors = [
    const Color.fromARGB(255, 203, 221, 236),
    const Color.fromARGB(255, 235, 244, 170),
    const Color.fromARGB(255, 236, 200, 245),
    const Color.fromRGBO(250, 232, 250, 1),
  ];

  // List<Image> allImages = [
  //   Image.asset("assets/image/python.png"),
  //   Image.asset("assets/image/flutter.jpeg"),
  //   Image.asset("assets/image/java.jpeg"),
  //   Image.asset("assets/image/c++.jpeg"),
  // ];
  void submitData(bool isEdit, [ShowModelClass? obj]) {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty) {
      if (isEdit) {
        obj!.title = titleController.text;
        obj.description = descriptionController.text;
        obj.date = dateController.text;
      } else {
        taskList.add(ShowModelClass(
            title: titleController.text,
            description: descriptionController.text,
            date: dateController.text));
      }
    }
    Navigator.of(context).pop();
    clearBottomSheet();
    setState(() {});
  }

  void clearBottomSheet() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  void to_Do_BottomSheet(bool isEdit, [ShowModelClass? obj]) {
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
                        "Create To-Do",
                        style: GoogleFonts.quicksand(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Title",
                    style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(0, 139, 148, 1)),
                  ),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter title",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 330,
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Description",
                    style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(0, 139, 148, 1)),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 330,
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Date",
                    style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(0, 139, 148, 1)),
                  ),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: "MM/DD/YYYY",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 330,
                      ),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          DateTime? pickDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2027));
                          String dateFormat =
                              DateFormat.yMMMd().format(pickDate!);
                          setState(() {
                            dateController.text = dateFormat;
                          });
                        },
                        icon: const Icon(Icons.calendar_today_outlined)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(0, 139, 148, 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 130, top: 15),
                          child: GestureDetector(
                            onTap: () {
                              if (isEdit == true) {
                                submitData(true, obj);
                              } else {
                                submitData(false);
                              }
                              setState(() {
                                clearBottomSheet();
                              });
                              
                            },
                            child: Text(
                              "Submit",
                              style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      const Color.fromARGB(255, 239, 240, 240)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (isModeOn) ? Colors.white : Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "to-do-list",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Container(
                  width: 120,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 201, 198, 198),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        child: GestureDetector(
                            onTap: () {
                              isModeOn = true;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.light_mode,
                              color: Color.fromARGB(255, 19, 122, 169),
                            )),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        child: GestureDetector(
                          onTap: () {
                            isModeOn = false;
                            setState(() {});
                          },
                          child: Icon(Icons.dark_mode),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: myColors[index % myColors.length],
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
                            width: 52,
                            height: 52,
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
                                taskList[index].title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              Text(
                                taskList[index].description,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(84, 84, 84, 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      Text(
                        taskList[index].date,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(132, 132, 132, 1),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            titleController.text = taskList[index].title;
                            descriptionController.text =
                                taskList[index].description;
                            dateController.text = taskList[index].date;

                            to_Do_BottomSheet(true, taskList[index]);
                            setState(() {});
                          },
                          icon: SvgPicture.asset("assets/svg/edit.svg")),
                      IconButton(
                          onPressed: () {
                            taskList.remove(taskList[index]);
                            setState(() {});
                          },
                          icon: SvgPicture.asset("assets/svg/delete.svg")),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          to_Do_BottomSheet(false);
        },
        backgroundColor: const Color.fromARGB(255, 14, 93, 251),
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 249, 250, 251),
        ),
      ),
    );
  }
}
