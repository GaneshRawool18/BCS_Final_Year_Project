import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    // Get screen width and height dynamically
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 11, 11, 11),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.015),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 178, 178, 178),
                    offset: const Offset(0, 0),
                    blurStyle: BlurStyle.outer,
                    blurRadius: screenWidth * 0.02,
                  )
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Us Content
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "📌 About Us – Stay Organized, Stay Inspired\n",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "Welcome to XpenScribe – your all-in-one, smart note-taking app designed to help you capture ideas, organize thoughts, and boost productivity effortlessly.\n\n",
                          style:
                              GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                        ),
                        TextSpan(
                          text: "🌟 Our Mission\n",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "At XpenScribe, we believe that every idea matters. Our mission is to create a seamless, distraction-free space...\n\n",
                          style:
                              GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                        ),
                        TextSpan(
                          text: "🚀 Why Choose XpenScribe?\n",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "✔️ Fast & Minimalist Interface – Focus on your notes without distractions.\n"
                              "✔️ Sync Across Devices – Access notes anywhere with secure cloud storage.\n"
                              "✔️ Dark Mode & Custom Themes – Personalize your note-taking experience.\n\n",
                          style:
                              GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                        ),
                        TextSpan(
                          text: "📲 Join the XpenScribe Community!\n",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "Stay inspired and productive with XpenScribe. Download the app today!\n\n",
                          style:
                              GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.002),

                  // Social Media Section
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "Follow Us on Social Media",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Image.asset("assets/images/insta_icon.png"),
                            iconSize: screenWidth * 0.12,
                            onPressed: () => _launchURL(instagramUrl),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          IconButton(
                            icon: Image.asset("assets/images/twiter_icon.png"),
                            iconSize: screenWidth * 0.12,
                            onPressed: () => _launchURL(twitterUrl),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          IconButton(
                            icon:
                                Image.asset("assets/images/faceBook_icon.png"),
                            iconSize: screenWidth * 0.12,
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
