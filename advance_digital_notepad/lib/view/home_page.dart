import 'package:advance_digital_notepad/view/chat_box.dart';
import 'package:advance_digital_notepad/view/expense_manager.dart';
import 'package:advance_digital_notepad/view/home_screen.dart';
import 'package:advance_digital_notepad/view/messages_page.dart';
import 'package:advance_digital_notepad/view/profile_page.dart';
import 'package:advance_digital_notepad/view/to_do_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const ToDoList(),
    const ExpenseManager(),
    const ChatBoxPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 254),
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(232, 244, 247, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: buildNavBarComponent(
                  "Home", Icons.home_outlined, selectedIndex == 0),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: buildNavBarComponent(
                  "Note", Icons.note_outlined, selectedIndex == 1),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              child: buildNavBarComponent(
                  "Expense", Icons.attach_money_outlined, selectedIndex == 2),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 3;
                });
              },
              child: buildNavBarComponent(
                  "Messages", Icons.message_outlined, selectedIndex == 3),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 4;
                });
              },
              child: buildNavBarComponent(
                  "Profile", Icons.person_2_outlined, selectedIndex == 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarComponent(String title, IconData icon, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          icon,
          color: isSelected
              ? const Color.fromRGBO(13, 110, 253, 1)
              : const Color.fromRGBO(
                  125, 132, 141, 1), // Change icon color if selected
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            color: isSelected
                ? const Color.fromRGBO(13, 110, 253, 1)
                : const Color.fromRGBO(
                    125, 132, 141, 1), // Change text color if selected
          ),
        ),
      ],
    );
  }
}
