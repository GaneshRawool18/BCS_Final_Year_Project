import 'dart:io';

import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/view/home/home_page.dart';
import 'package:advance_digital_notepad/view/profile/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final UserController userController = Get.find<UserController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _profileImageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = userController.userName.value;
    _emailController.text = userController.email.value;
    _phoneController.text = userController.phoneNumber.value;

    userController.loadLocalProfileImage().then((file) {
      if (file != null) {
        setState(() {
          _profileImageFile = file;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedImage != null) {
      setState(() {
        _profileImageFile = File(pickedImage.path);
      });
      await userController.updateProfileImage(File(pickedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",
            style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        elevation: 2,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: screenSize.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage, // Calls the image picker when tapped.
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImageFile != null
                            ? FileImage(_profileImageFile!)
                            : const AssetImage("assets/images/profile_pic.png")
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 2,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInputField(
                            "Full Name", _nameController, Icons.person, theme),
                        _buildInputField(
                            "Email", _emailController, Icons.email, theme,
                            readOnly: true),
                        _buildInputField("Phone Number", _phoneController,
                            Icons.phone, theme),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final phone = _phoneController.text.trim();

                    if (name.isEmpty || phone.isEmpty) {
                      Get.snackbar("Error", "Name and Phone cannot be empty");
                      return;
                    }

                    Get.dialog(const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false);

                    await userController.updateUserProfile(name, phone);

                    Get.back(); // close loader
                    Get.snackbar("Success", "Profile Updated Successfully");
                    Get.to(() => const HomePage()); // go back
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotPasswordPage());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Change to your desired background color
                    foregroundColor: Colors.white, // This sets the text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      IconData icon, ThemeData theme,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
          filled: true,
          fillColor: theme.cardColor,
          prefixIcon: Icon(icon, color: Colors.green),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }
}
