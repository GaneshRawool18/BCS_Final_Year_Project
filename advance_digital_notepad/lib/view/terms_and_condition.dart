import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    // Dynamic sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
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
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
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
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "📜 Welcome to XpenScribe!\n\n",
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "By using our app, you agree to the following terms and conditions:\n\n",
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.038),
                ),
                _buildHeading("1. Acceptance of Terms"),
                _buildBody(
                    "By downloading and using XpenScribe, you agree to comply with these Terms & Conditions. If you do not agree, please refrain from using the app.\n"),
                _buildHeading("2. User Responsibilities"),
                _buildBulletPoint("You are responsible for maintaining the confidentiality of your account and password."),
                _buildBulletPoint("You agree not to misuse the app for any illegal activities."),
                _buildBulletPoint("You are responsible for ensuring that your content complies with all applicable laws.\n"),
                _buildHeading("3. Data & Privacy"),
                _buildBulletPoint("Your notes and personal data are securely stored and will not be shared without your consent."),
                _buildBulletPoint("We may collect analytics data to improve the app's performance and features.\n"),
                _buildHeading("4. Prohibited Activities"),
                _buildBulletPoint("Hacking, reverse-engineering, or modifying the app is strictly prohibited."),
                _buildBulletPoint("Using the app for spam, harassment, or illegal activities is not allowed.\n"),
                _buildHeading("5. Limitation of Liability"),
                _buildBulletPoint("We do not guarantee that the app will always be error-free or uninterrupted."),
                _buildBulletPoint("We are not liable for any data loss, security breaches, or unauthorized access to your notes.\n"),
                _buildHeading("6. Modifications to Terms"),
                _buildBulletPoint("We reserve the right to update these terms at any time. Continued use of the app means you accept any changes.\n"),
                TextSpan(
                  text: "📌 For any legal concerns, contact us at: ",
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "support@xpenscribe.com",
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function for bold headings
  TextSpan _buildHeading(String text) {
    return TextSpan(
      text: "\n$text\n",
      style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.042,
          fontWeight: FontWeight.bold),
    );
  }

  // Helper function for normal body text
  TextSpan _buildBody(String text) {
    return TextSpan(
      text: "$text\n",
      style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.038),
    );
  }

  // Helper function for bullet points
  TextSpan _buildBulletPoint(String text) {
    return TextSpan(
      text: "• $text\n",
      style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.038),
    );
  }
}
