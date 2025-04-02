import 'package:advance_digital_notepad/view/home/expense_manager.dart';
import 'package:advance_digital_notepad/view/home/home_screen.dart';
import 'package:advance_digital_notepad/view/home/to_do_list.dart';
import 'package:advance_digital_notepad/view/profile/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:advance_digital_notepad/view/chat/chat_box.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    ToDoList(),
    const ExpenseManager(),
    const ChatBoxPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 254),
      body: pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color:const Color.fromARGB(255, 54, 161, 188),
        buttonBackgroundColor: const Color.fromRGBO(13, 110, 253, 1),
        height: 60,
        index: selectedIndex,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.note_outlined, size: 30, color: Colors.white),
          Icon(Icons.attach_money_outlined, size: 30, color: Colors.white),
          Icon(Icons.message_outlined, size: 30, color: Colors.white),
          Icon(Icons.person_2_outlined, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
