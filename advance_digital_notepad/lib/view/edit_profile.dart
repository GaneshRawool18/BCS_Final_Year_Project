import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../controller/user_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final UserController userController = Get.find<UserController>(); 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = userController.userName.value;
    _phoneController.text = userController.phoneNumber.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: "Phone Number")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userController.updateUserProfile(
                  _nameController.text.trim(),
                  _phoneController.text.trim(),
                );
                Get.snackbar("Success", "Profile Updated Successfully");
                Get.back();
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
