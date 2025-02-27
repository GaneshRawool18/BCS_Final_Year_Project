import 'package:advance_digital_notepad/controller/firebase_services.dart';
import 'package:advance_digital_notepad/view/home_page.dart';
import 'package:advance_digital_notepad/view/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void clearControllerData() {
    emailController.clear();
    passwordController.clear();
  }

  bool _obscureText = true;
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
                  "Sign in",
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
                          obscureText: _obscureText,
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
                      IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 170, 170, 169),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    if (emailController.text.trim().isNotEmpty &&
                        passwordController.text.trim().isNotEmpty) {
                      try {
                        await FirebaseServices.userFirebaseLogin(
                            emailController.text, passwordController.text);
                        clearControllerData();
                        await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        }));
                      } on FirebaseAuthException catch (obj) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${obj.message}"),
                          backgroundColor: Colors.amber,
                          duration: const Duration(seconds: 5),
                        ));
                      }
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
                        "Log in",
                        style: GoogleFonts.imprima(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 8, 8, 8),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: Color.fromARGB(255, 201, 201, 201),
                      thickness: 1,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "OR",
                        style: GoogleFonts.imprima(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 8, 8, 8),
                        ),
                      ),
                    ),
                    const Expanded(
                        child: Divider(
                      color: Color.fromARGB(255, 201, 201, 201),
                      thickness: 1,
                    )),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    User? user = await FirebaseServices.loginWithGoogle();

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Google sign-in failed"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Image.asset("assets/images/google_icon.png"),
                        ),
                        const Text("Continue with Google")
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const SignUpPage();
                    }));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 178, 178, 178),
                            offset: Offset(0, 4),
                            blurStyle: BlurStyle.outer,
                            blurRadius: 5,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Don't have an account? Sign up",
                        style: GoogleFonts.imprima(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 170, 170, 169),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
