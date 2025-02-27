import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> options = [
    {"title": "Edit Profile", "icon": Icons.person_outlined},
    {"title": "About Us", "icon": Icons.info_outline},
    {"title": "Terms and Conditions", "icon": Icons.description_outlined},
    {"title": "Logout", "icon": Icons.exit_to_app},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              blurStyle: BlurStyle.outer,
              color: Color.fromRGBO(255, 230, 223, 1)),
        ],
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.080,
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width *
                      0.5, 
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.020,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.042,
                    right: MediaQuery.of(context).size.width * 0.042,
                    top: MediaQuery.of(context).size.width * 0.03,
                    bottom: MediaQuery.of(context).size.width * 0.03),
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
                          width: MediaQuery.of(context).size.width * 0.042,
                        ),
                        Text(
                          options[index]["title"],
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.042,
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
              );
            },
          )
        ],
      ),
    ));
  }
}
