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

  // bool _obscureText = true;

  void clearControllerData() {
    nameController.clear();
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
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
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 178, 178, 178),
                    offset: Offset(0, 4),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 5,
                  )
                ]),
            child: Column(
              children: [
                Text(
                  "Sign up",
                  style: GoogleFonts.imprima(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 178, 178, 178),
                          offset: Offset(0, 4),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 5,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 5),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Enter name",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.imprima(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 170, 170, 169),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 178, 178, 178),
                          offset: Offset(0, 4),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 5,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 5),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: "Enter user name",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.imprima(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 170, 170, 169),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 178, 178, 178),
                          offset: Offset(0, 4),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 5,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 5),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter email",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.imprima(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 170, 170, 169),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 178, 178, 178),
                        offset: Offset(0, 4),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 5, right: 50),
                        child: TextField(
                          controller: passwordController,
                          // obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "Enter password",
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.imprima(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 170, 170, 169),
                            ),
                          ),
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     _obscureText
                      //         ? Icons.visibility_off
                      //         : Icons.visibility,
                      //     color: const Color.fromARGB(255, 170, 170, 169),
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       _obscureText = !_obscureText;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (emailController.text.trim().isNotEmpty &&
                        passwordController.text.trim().isNotEmpty &&
                        nameController.text.trim().isNotEmpty &&
                        userNameController.text.trim().isNotEmpty) {
                      try {
                        FirebaseServices.createUserAccount(
                            emailController.text.trim(),
                            passwordController.text.trim());
                      } on FirebaseAuthException catch (obj) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${obj.message}"),
                          backgroundColor: Colors.amber,
                          duration: const Duration(seconds: 5),
                        ));
                      }
                      Navigator.of(context).pop();
                      clearControllerData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("All fields are required "),
                        duration: Duration(seconds: 5),
                        backgroundColor: Color.fromARGB(255, 251, 55, 20),
                      ));
                    }
                  },
                  child: Container(
                    width: 300,
                    height: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 201, 201, 201)),
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
}
