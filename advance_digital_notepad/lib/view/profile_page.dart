import 'package:advance_digital_notepad/controller/firebase_services.dart';
import 'package:advance_digital_notepad/view/about_us.dart';
import 'package:advance_digital_notepad/view/edit_profile.dart';
import 'package:advance_digital_notepad/view/sign_in.dart';
import 'package:advance_digital_notepad/view/terms_and_condition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    {"title": "Logout", "icon": Icons.exit_to_app, "route": null},
  ];

  void _onOptionTap(int index) {
    if (options[index]["title"] == "Logout") {
      _showLogoutDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => options[index]["route"]),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Color cancelColor = Colors.red;
          Color logoutColor = Colors.green;

          return AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    cancelColor = Colors.grey; // Change color on press
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: cancelColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    logoutColor = Colors.grey;
                  });
                  await FirebaseServices.signOutUser();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const SignInPage();
                  }));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: logoutColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              blurStyle: BlurStyle.outer,
              color: Color.fromRGBO(255, 230, 223, 1),
            ),
          ],
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.080),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      "assets/images/profile_pic.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.width * 0.025,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 242, 228),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          color: const Color.fromARGB(255, 4, 4, 4),
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),

// Display User's Name
            Text(
              "Ganesh Rawool", // Replace with dynamic name if needed
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.005),

            // Display User's Email
            Text(
              "Ganesh18@gmail.com",
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.0015),
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _onOptionTap(index),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.042,
                      right: MediaQuery.of(context).size.width * 0.042,
                      top: MediaQuery.of(context).size.width * 0.03,
                      bottom: MediaQuery.of(context).size.width * 0.03,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.width * 0.03,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                      ],
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              options[index]["icon"],
                              size: MediaQuery.of(context).size.width * 0.048,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.042),
                            Text(
                              options[index]["title"],
                              style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.042,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
