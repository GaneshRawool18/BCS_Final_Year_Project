import 'dart:io';

import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/view/Expense/about_us.dart';
import 'package:advance_digital_notepad/view/expense/categorie_page.dart';
import 'package:advance_digital_notepad/view/expense/graph_page.dart';
import 'package:advance_digital_notepad/view/home/expense_manager.dart';
import 'package:advance_digital_notepad/view/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final UserController userController = Get.find<UserController>();
  int selectedIndex = 0;
  Color containerColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          children: [
            // Drawer header with profile image, name, and email
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E9F7D), Color(0xFF14A17D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture: just showing image (no tap to pick)
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                    child: Obx(() {
                      String imagePath = userController.profileImagePath.value;
                      // If the image path doesn't start with "assets/", then assume it's a local file
                      if (imagePath.isNotEmpty && !imagePath.startsWith("assets/")) {
                        File imageFile = File(imagePath);
                        if (imageFile.existsSync()) {
                          return ClipOval(
                            child: Image.file(
                              imageFile,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          // If file doesn't exist, show the default asset image
                          return ClipOval(
                            child: Image.asset(
                              "assets/images/profile_pic.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      } else {
                        // Default asset image
                        return ClipOval(
                          child: Image.asset(
                            "assets/images/profile_pic.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 10),
                  // Profile Name
                  Obx(
                    () => Text(
                      userController.userName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Profile Email
                  Obx(
                    () => Text(
                      userController.email.value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Drawer items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(context, "Transaction",
                      Icons.attach_money_outlined, 0, const ExpenseManager()),
                  buildDrawerItem(context, "Graphs", Icons.pie_chart_outline, 1, const GraphPage()),
                  buildDrawerItem(context, "Category", Icons.category_outlined, 2, const CategoriePage()),
                  buildDrawerItem(context, "About Us", Icons.info_outline, 3, const AboutUsPage()),
                ],
              ),
            ),
            // Back button
            GestureDetector(
              onTap: () {
                setState(() {
                  containerColor = Colors.red;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.020,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, IconData icon, int index, Widget? page) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        if (page != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: isSelected ? Colors.green[700] : Colors.grey[700]),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.green[800] : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
