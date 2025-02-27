import 'package:advance_digital_notepad/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDhn-xgiBB5HQ2_dfejFAHVKtassWRjUmw",
          appId: "1:76751527402:android:a36c6711d7067b04ade693",
          messagingSenderId: "76751527402",
          projectId: "advancedigitalnotepad"));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
