import 'package:advance_digital_notepad/view/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBoxPage extends StatefulWidget {
  const ChatBoxPage({super.key});

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  List<Map<String, dynamic>> users = [
    {
      "name": "Ganesh Rawool",
      "message": "Hi, How are you doing?",
      "time": "09:46",
      "status": Icons.check,
    },
    {
      "name": "Bipin Rawool",
      "message": "Typing...",
      "time": "08:42",
      "status": Icons.done_all,
    },
    {
      "name": "Virat Kohli",
      "message": "You: Cool! ☺️ Let’s meet at 18:00!",
      "time": "Yesterday",
      "status": Icons.done_all,
    },
    {
      "name": "Abhishek Bhosale",
      "message": "You: Hey, coming to the party?",
      "time": "07:56",
      "status": Icons.check,
    },
    {
      "name": "Harshal",
      "message": "Thank you for coming!",
      "time": "05:52",
      "status": Icons.done_all,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Text(
                  "Messages",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(27, 40, 30, 1),
                  ),
                ),
                const Spacer(),
                Container(
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.more_vert),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              width: screenWidth * 0.9,
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      color: Color.fromRGBO(125, 132, 141, 1)),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Search for chats & messages",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(125, 132, 141, 1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const MessagesPage();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.06,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.person,
                                size: screenWidth * 0.08,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        users[index]["name"],
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                              27, 40, 30, 1),
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        users[index]["status"],
                                        color: Colors.green,
                                        size: screenWidth * 0.05,
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        users[index]["time"],
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(
                                              125, 132, 141, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.008),
                                  Text(
                                    users[index]["message"],
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                          125, 132, 141, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
