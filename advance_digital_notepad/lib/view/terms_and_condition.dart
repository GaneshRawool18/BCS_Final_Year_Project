import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    // Dynamic screen sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Check current theme mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
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
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
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
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "📜 Welcome to XpenScribe!\n\n",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextSpan(
                  text:
                      "By using our app, you agree to the following terms and conditions:\n\n",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.038,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                _buildHeading("1. Acceptance of Terms", isDarkMode),
                _buildBody(
                    "By downloading and using XpenScribe, you agree to comply with these Terms & Conditions. If you do not agree, please refrain from using the app.\n",
                    isDarkMode),
                _buildHeading("2. User Responsibilities", isDarkMode),
                _buildBulletPoint(
                    "You are responsible for maintaining the confidentiality of your account and password.",
                    isDarkMode),
                _buildBulletPoint(
                    "You agree not to misuse the app for any illegal activities.",
                    isDarkMode),
                _buildBulletPoint(
                    "You are responsible for ensuring that your content complies with all applicable laws.\n",
                    isDarkMode),
                _buildHeading("3. Data & Privacy", isDarkMode),
                _buildBulletPoint(
                    "Your notes and personal data are securely stored and will not be shared without your consent.",
                    isDarkMode),
                _buildBulletPoint(
                    "We may collect analytics data to improve the app's performance and features.\n",
                    isDarkMode),
                _buildHeading("4. Prohibited Activities", isDarkMode),
                _buildBulletPoint(
                    "Hacking, reverse-engineering, or modifying the app is strictly prohibited.",
                    isDarkMode),
                _buildBulletPoint(
                    "Using the app for spam, harassment, or illegal activities is not allowed.\n",
                    isDarkMode),
                _buildHeading("5. Limitation of Liability", isDarkMode),
                _buildBulletPoint(
                    "We do not guarantee that the app will always be error-free or uninterrupted.",
                    isDarkMode),
                _buildBulletPoint(
                    "We are not liable for any data loss, security breaches, or unauthorized access to your notes.\n",
                    isDarkMode),
                _buildHeading("6. Modifications to Terms", isDarkMode),
                _buildBulletPoint(
                    "We reserve the right to update these terms at any time. Continued use of the app means you accept any changes.\n",
                    isDarkMode),
                TextSpan(
                  text: "📌 For any legal concerns, contact us at: ",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () =>
                        launchUrl(Uri.parse("mailto:support@xpenscribe.com")),
                    child: Text(
                      "support@xpenscribe.com",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
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

  // Helper function for bold headings
  TextSpan _buildHeading(String text, bool isDarkMode) {
    return TextSpan(
      text: "\n$text\n",
      style: GoogleFonts.poppins(
        fontSize: MediaQuery.of(context).size.width * 0.042,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  // Helper function for normal body text
  TextSpan _buildBody(String text, bool isDarkMode) {
    return TextSpan(
      text: "$text\n",
      style: GoogleFonts.poppins(
        fontSize: MediaQuery.of(context).size.width * 0.038,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
    );
  }

  // Helper function for bullet points
  TextSpan _buildBulletPoint(String text, bool isDarkMode) {
    return TextSpan(
      text: "• $text\n",
      style: GoogleFonts.poppins(
        fontSize: MediaQuery.of(context).size.width * 0.038,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
    );
  }
}
