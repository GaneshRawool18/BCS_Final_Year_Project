import 'dart:developer';
import 'dart:io';
import 'package:advance_digital_notepad/controller/todo_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';

class FirebaseServices {
  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<User?> createUserAccount(
      String name, String email, String phone, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email": email,
          "mobile": phone,
          "profileImage": "assets/images/profile_pic.png",
          "timestamp": FieldValue.serverTimestamp(),
        });

        await _setUserSession(true, email);
        log("User registered: $email");
        return user;
      }
      return null;
    } catch (e) {
      log("Error during sign-up: $e");
      return null;
    }
  }

  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _setUserSession(true, user.email!);
        Get.find<UserController>().fetchUserData();
        Get.find<ToDoController>().fetchTasks();
        log("User signed in: ${user.email}");
        return user;
      }
      return null;
    } catch (e) {
      log("Firebase Auth Error: ${e.toString()}");
      return null;
    }
  }

  static Future<User?> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        log("Google Sign-In cancelled by user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserDataToFirestore(user);
        await _setUserSession(true, user.email!);
        Get.find<UserController>().fetchUserData();
        Get.find<ToDoController>().fetchTasks();
        log("Google Sign-In Successful: ${user.email}");
      }
      return user;
    } catch (e) {
      log("Error during Google sign-in: $e");
      return null;
    }
  }

  static Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await _setUserSession(false, "");
      Get.find<UserController>().clearUserData();
      Get.find<ToDoController>().logoutUser();
      log("User signed out.");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  static Future<String?> uploadProfileImage(
      String userId, File imageFile) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child("profile_images/$userId");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "profileImage": downloadUrl,
      });
      log("Profile image uploaded: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      log("Error uploading image: $e");
      return null;
    }
  }

  static Future<void> _saveUserDataToFirestore(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "name": user.displayName ?? "No Name",
        "email": user.email,
        "profileImage": user.photoURL ?? "assets/images/default_profile.png",
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> _setUserSession(bool isLoggedIn, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    await prefs.setString('user_email', email);
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}
