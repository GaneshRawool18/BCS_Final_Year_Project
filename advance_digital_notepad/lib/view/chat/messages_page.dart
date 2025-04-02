import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 254),
      body: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.042,
            right: MediaQuery.of(context).size.width * 0.042,
            top: MediaQuery.of(context).size.width * 0.09),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 243, 241, 241),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                    )),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "Ganesh Rawool",
                      style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(27, 40, 30, 1)),
                    ),
                    Text(
                      "Active Now",
                      style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(25, 176, 0, 1)),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 243, 241, 241),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.call_outlined,
                      size: MediaQuery.of(context).size.width * 0.06,
                    )))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.030,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 243, 241, 241),
              ),
              child: Center(
                child: Text(
                  "Today",
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(125, 132, 141, 1)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
