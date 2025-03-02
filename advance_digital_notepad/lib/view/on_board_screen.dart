import 'package:advance_digital_notepad/view/on_board.dart';
import 'package:advance_digital_notepad/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: controller,
            pageSnapping: true,
            scrollBehavior: const ScrollBehavior(),
            children: [
              Onboard(
                image: "assets/images/note.png",
                title: "Your Notepad, Your Way",
                description:
                    "Take notes, stay organized, and boost productivity with ease!",
                button: "Get Started",
                onTap: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
              ),
              Onboard(
                image: "assets/images/launchScreen2.png",
                title: "Stay Organized, Stay Productive",
                description:
                    "Your ideas, your notepad—seamless, smart, and always with you!",
                button: "Next",
                onTap: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
              ),
              Onboard(
                image: "assets/images/launchScreen3.png",
                title: "Smart Notetaking, Simplified",
                description:
                    "Write, sketch, and organize—all in one smart notepad. Elevate your notes!",
                button: "Next",
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return const SignInPage();
                  }));
                },
              )
            ],
          ),
          Positioned(
            bottom: 130,
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: const ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                expansionFactor: 3,
                activeDotColor: Color.fromRGBO(13, 110, 253, 1),
                dotColor: Color.fromRGBO(202, 234, 255, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
