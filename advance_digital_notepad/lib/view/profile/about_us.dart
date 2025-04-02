import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:advance_digital_notepad/controller/theme_controller.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final ThemeController themeController = Get.find<ThemeController>();

  // Social media links
  final Uri instagramUrl = Uri.parse("https://www.instagram.com/");
  final Uri twitterUrl = Uri.parse("https://x.com/ganeshrawool07");
  final Uri facebookUrl = Uri.parse("https://www.facebook.com/");

  // Function to launch URLs
  void _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    offset: const Offset(0, 2),
                    blurRadius: screenWidth * 0.02,
                  )
                ],
                color: isDarkMode ? Colors.grey[900] : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Us Content
                  Text(
                    "📌 About Us – Stay Organized, Stay Inspired",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Welcome to XpenScribe – your all-in-one, smart note-taking app designed to help you capture ideas, organize thoughts, and boost productivity effortlessly.",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "🌟 Our Mission",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "At XpenScribe, we believe that every idea matters. Our mission is to create a seamless, distraction-free space...",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "🚀 Why Choose XpenScribe?",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "✔️ Fast & Minimalist Interface – Focus on your notes without distractions.\n"
                    "✔️ Sync Across Devices – Access notes anywhere with secure cloud storage.\n"
                    "✔️ Dark Mode & Custom Themes – Personalize your note-taking experience.",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "📲 Join the XpenScribe Community!",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "Stay inspired and productive with XpenScribe. Download the app today!",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Social Media Section with PNG Icons
                  Center(
                    child: Text(
                      "Follow Us on Social Media",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/images/insta_icon.png",
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                        ),
                        onPressed: () => _launchURL(instagramUrl),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      IconButton(
                        icon: Image.asset(
                          "assets/images/twiter_icon.png",
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                        ),
                        onPressed: () => _launchURL(twitterUrl),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      IconButton(
                        icon: Image.asset(
                          "assets/images/faceBook_icon.png",
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                        ),
                        onPressed: () => _launchURL(facebookUrl),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
