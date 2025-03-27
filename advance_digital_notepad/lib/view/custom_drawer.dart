import 'dart:io';

import 'package:advance_digital_notepad/controller/image_picker_helper.dart';
import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/view/Expense/about_us.dart';
import 'package:advance_digital_notepad/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:advance_digital_notepad/view/categorie_page.dart';
import 'package:advance_digital_notepad/view/graph_page.dart';
import 'package:advance_digital_notepad/view/expense_manager.dart';
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

  File? _selectedImage;
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  Future<void> _pickImage() async {
    File? imageFile =
        await _imagePickerHelper.pickImageFromGallery(); // Pick from gallery
    if (imageFile != null) {
      setState(() {
        _selectedImage = imageFile; // Update UI with the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          children: [
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
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Obx(() {
                        return _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                width:
                                    100, // Ensure it fits within the CircleAvatar
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : userController.profileImage.value.isNotEmpty
                                ? Image.network(
                                    userController.profileImage.value,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/images/profile_pic.png",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ); // Fallback image
                                    },
                                  )
                                : Image.asset(
                                    "assets/images/profile_pic.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ); // Default image
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Profile Name
                  Obx(
                    () => Text(
                      "${userController.userName}",
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
                      "${userController.email}",
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(context, "Transaction",
                      Icons.attach_money_outlined, 0, const ExpenseManager()),
                  buildDrawerItem(context, "Graphs", Icons.pie_chart_outline, 1,
                      const GraphPage()),
                  buildDrawerItem(context, "Category", Icons.category_outlined,
                      2, const CategoriePage()),
                  buildDrawerItem(context, "About Us", Icons.info_outline, 3,
                      const AboutUsPage()),
                ],
              ),
            ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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

  Widget buildDrawerItem(BuildContext context, String title, IconData icon,
      int index, Widget? page) {
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
          leading: Icon(icon,
              color: isSelected ? Colors.green[700] : Colors.grey[700]),
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
