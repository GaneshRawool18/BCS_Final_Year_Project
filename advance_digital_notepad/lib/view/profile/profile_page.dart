import 'dart:io';

import 'package:advance_digital_notepad/controller/firebase_services.dart';
import 'package:advance_digital_notepad/controller/image_picker_helper.dart';
import 'package:advance_digital_notepad/controller/theme_controller.dart';
import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/view/home/sign_in.dart';
import 'package:advance_digital_notepad/view/home/terms_and_condition.dart';
import 'package:advance_digital_notepad/view/profile/about_us.dart';
import 'package:advance_digital_notepad/view/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ThemeController themeController = Get.find<ThemeController>();
  final UserController userController = Get.find<UserController>();

  // Options list
  List<Map<String, dynamic>> options = [
    {
      "title": "Edit Profile",
      "icon": Icons.person_outlined,
      "route": const EditProfile()
    },
    {"title": "About Us", "icon": Icons.info_outline, "route": const AboutUs()},
    {
      "title": "Terms and Conditions",
      "icon": Icons.description_outlined,
      "route": const TermsAndConditionPage()
    },
    {
      "title": "Theme",
      "icon": Icons.brightness_6_outlined,
      "route": null
    }, // Theme Option
    {
      "title": "Logout",
      "icon": Icons.exit_to_app,
      "route": const SignInPage()
    },
  ];

  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  // Removed _selectedImage and image picking logic since no image editing is allowed here

  void _onOptionTap(int index) {
    if (options[index]["title"] == "Theme") {
      _showThemeDialog();
    } else if (options[index]["title"] == "Logout") {
      _showLogoutDialog();
    } else if (options[index]["route"] != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => options[index]["route"]));
    }
  }

  /// **Improved Dark & Light Theme Selection Dialog**
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Select Theme",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black,
          ),
        ),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text("Light Mode"),
                  value: false,
                  groupValue: themeController.isDarkMode.value,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    themeController.toggleTheme(false);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: const Text("Dark Mode"),
                  value: true,
                  groupValue: themeController.isDarkMode.value,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    themeController.toggleTheme(true);
                    Navigator.pop(context);
                  },
                ),
              ],
            )),
      ),
    );
  }

  /// **Logout Alert Box**
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            color: themeController.isDarkMode.value ? Colors.white70 : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyle(
                  color: themeController.isDarkMode.value ? Colors.grey : Colors.blue,
                )),
          ),
          TextButton(
            onPressed: () {
              FirebaseServices.signOutUser();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SignInPage()));
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          themeController.isDarkMode.value ? Colors.black : Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          // Profile Image
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: Obx(() {
                // Using profileImagePath which may be a URL or an asset (default)
                String imgPath = userController.profileImagePath.value;
                // If the image path is not empty and it does not start with "assets/"
                if (imgPath.isNotEmpty && !imgPath.startsWith("assets/")) {
                  File imageFile = File(imgPath);
                  if (imageFile.existsSync()) {
                    return Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    );
                  } else {
                    // If file doesn't exist, fall back to the default asset image
                    return Image.asset("assets/images/profile_pic.png", fit: BoxFit.cover);
                  }
                } else {
                  // Default asset image
                  return Image.asset("assets/images/profile_pic.png", fit: BoxFit.cover);
                }
              }),
            ),
          ),
          const SizedBox(height: 10),
          // Profile Name and Email
          Column(
            children: [
              Obx(() => Text(
                    userController.userName.value,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : const Color.fromARGB(255, 23, 23, 23),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Obx(() => Text(
                    userController.email.value,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white70 : const Color.fromARGB(179, 5, 5, 5),
                      fontSize: 14,
                    ),
                  )),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          // Options List
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _onOptionTap(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeController.isDarkMode.value ? Colors.grey[850] : Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: themeController.isDarkMode.value ? Colors.black26 : Colors.black12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              options[index]["icon"],
                              size: 30,
                              color: themeController.isDarkMode.value ? Colors.white70 : Colors.black87,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              options[index]["title"],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: themeController.isDarkMode.value ? Colors.white70 : Colors.black87,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
