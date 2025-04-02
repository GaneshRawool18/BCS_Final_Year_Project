import 'package:advance_digital_notepad/controller/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  void clearControllerData() {
    nameController.clear();
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    mobileController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 130),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 178, 178, 178),
                  offset: Offset(0, 4),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Sign up",
                  style: GoogleFonts.imprima(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(nameController, "Enter name"),
                const SizedBox(height: 20),
                _buildTextField(userNameController, "Enter user name"),
                const SizedBox(height: 20),
                _buildTextField(emailController, "Enter email"),
                const SizedBox(height: 20),
                _buildTextField(mobileController, "Enter mobile number"),
                const SizedBox(height: 20),
                _buildTextField(passwordController, "Enter password",
                    obscureText: true),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (_validateFields()) {
                      _signUpUser();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("All fields are required"),
                          duration: Duration(seconds: 5),
                          backgroundColor: Color.fromARGB(255, 251, 55, 20),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 201, 201, 201),
                    ),
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.imprima(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 8, 8, 8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    return emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        userNameController.text.trim().isNotEmpty &&
        mobileController.text.trim().isNotEmpty;
  }

  void _signUpUser() {
    try {
      FirebaseServices.createUserAccount(
        nameController.text.trim(),
        emailController.text.trim(),
        mobileController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created Successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.of(context).pop();
      clearControllerData();
    } on FirebaseAuthException catch (obj) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${obj.message}"),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 178, 178, 178),
            offset: Offset(0, 4),
            blurStyle: BlurStyle.outer,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 5),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: hintText.contains("mobile")
              ? TextInputType.phone
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: GoogleFonts.imprima(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 170, 170, 169),
            ),
          ),
        ),
      ),
    );
  }
}
