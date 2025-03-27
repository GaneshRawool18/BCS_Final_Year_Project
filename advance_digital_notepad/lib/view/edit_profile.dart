import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController.text = userController.userName.value;
    _emailController.text = userController.email.value;
    _phoneController.text = userController.phoneNumber.value;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color inputBgColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final Color cardColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",
            style: TextStyle(color: textColor, fontSize: 20)),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 20),

            // User Information Card
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField("Full Name", _nameController, Icons.person,
                        inputBgColor, textColor),
                    _buildInputField("Email", _emailController, Icons.email,
                        inputBgColor, textColor,
                        readOnly: true),
                    _buildInputField("Phone Number", _phoneController,
                        Icons.phone, inputBgColor, textColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  userController.updateUserProfile(
                    _nameController.text.trim(),
                    _phoneController.text.trim(),
                  );
                  Get.snackbar("Success", "Profile Updated Successfully");
                  Get.back();
                },
                icon: Icon(Icons.save),
                label: Text("Save Changes", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.green[700] : Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Text Field Widget
  Widget _buildInputField(String label, TextEditingController controller,
      IconData icon, Color bgColor, Color textColor,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor), // ✅ Ensures text is visible
          filled: true,
          fillColor: bgColor,
          prefixIcon: Icon(icon, color: Colors.green),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.grey), // ✅ Ensures visible border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.green, width: 2), // ✅ Highlight on focus
          ),
        ),
        style: TextStyle(color: textColor),
      ),
    );
  }
}
