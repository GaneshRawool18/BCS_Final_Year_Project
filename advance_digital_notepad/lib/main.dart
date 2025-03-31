import 'package:advance_digital_notepad/view/splash_screen.dart';
import 'package:advance_digital_notepad/view/home_page.dart';
import 'package:advance_digital_notepad/controller/user_controller.dart';
import 'package:advance_digital_notepad/controller/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        
          apiKey: "AIzaSyDhn-xgiBB5HQ2_dfejFAHVKtassWRjUmw",
          appId: "1:76751527402:android:a36c6711d7067b04ade693",
          messagingSenderId: "76751527402",
          projectId: "advancedigitalnotepad"));

  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  // ✅ Ensure controllers are initialized before running the app
  Get.put(UserController());
  Get.put(ThemeController()); // ✅ Initialize ThemeController here

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>(); // ✅ Now ThemeController is available

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          theme: ThemeData.light(), // Light Theme
          darkTheme: ThemeData.dark(), // Dark Theme
          home: isLoggedIn ? const HomePage() : const SplashScreen(),
        ));
  }
}
