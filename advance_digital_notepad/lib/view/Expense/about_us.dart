import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final Uri instagramUrl = Uri.parse("https://www.instagram.com/");
  final Uri twitterUrl = Uri.parse("https://x.com/ganeshrawool07");
  final Uri facebookUrl = Uri.parse("https://www.facebook.com/");

  void _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Detect Dark Mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
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
                  Text(
                    "📌 About Us",
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Welcome to Expense Tracker, your smart solution for managing daily expenses with ease. "
                    "Our app helps you categorize your spending, visualize financial insights with interactive graphs, "
                    "and keep track of transactions effortlessly.\n",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Text(
                    "With features like customizable categories, detailed spending analysis, and a user-friendly interface, "
                    "Expense Tracker ensures you stay in control of your finances. Whether you're budgeting for food, fuel, "
                    "shopping, or entertainment, our app makes financial management simple and efficient.\n",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Text(
                    "Start tracking today and take charge of your expenses!",
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // **Social Media Section**
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "Follow Us on Social Media",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
