import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';

class FirebaseServices {
  static String? downLoadUrl;

  /// **🔥 Add Player Data to Firestore**
  static Future<void> firebaseAddData(String name, String jerseyNo, String teamName) async {
    if (downLoadUrl == null) {
      log("Error: Image URL is null. Upload image first.");
      return;
    }

    Map<String, dynamic> data = {
      "playerName": name,
      "jerseyNo": jerseyNo,
      "teamName": teamName,
      "imageUrl": downLoadUrl!,
    };

    log("Adding player to team: $teamName");

    DocumentReference teamRef = FirebaseFirestore.instance.collection("franchises").doc(teamName);
    CollectionReference playersRef = teamRef.collection("players");
    DocumentReference playerDoc = playersRef.doc(name);

    await playerDoc.set(data);
    log("Player added: $data");
  }

  /// **📤 Upload Profile Image to Firebase Storage**
  static Future<void> uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child("profile_images/$userId");
      UploadTask task = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await task;
      downLoadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new image URL
      await FirebaseFirestore.instance.collection("users").doc(userId).update({"profileImage": downLoadUrl});
      
      Get.find<UserController>().fetchUserData(); // Refresh user data
      log("Profile image uploaded: $downLoadUrl");
    } catch (e) {
      log("Error uploading image: $e");
    }
  }

  /// **🆕 Create User Account**
  static Future<void> createUserAccount(
    String name, String email, String phone, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
      "uid": userCredential.user!.uid,
      "name": name,
      "email": email,
      "mobile": phone,
      "profileImage": "assets/images/profile_pic.png", // Default image
    });

    log("User signed up successfully: $email");
  } catch (e) {
    log("Error during sign-up: $e");
  }
}

  /// **🔐 User Login**
  static Future<void> userFirebaseLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await _setUserSession(true, email);
      Get.find<UserController>().fetchUserData(); // Fetch user data after login
      log("User logged in: $email");
    } catch (e) {
      log("Error during login: $e");
    }
  }

  /// **🚪 User Logout (Includes Google Logout)**
  static Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await _setUserSession(false, "");
      Get.find<UserController>().clearUserData();
      log("User signed out successfully");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  /// **🌐 Google Sign-In**
  static Future<User?> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await _setUserSession(true, userCredential.user!.email!);
      Get.find<UserController>().fetchUserData(); // Fetch user data after login
      log("Google Sign-In Successful: ${userCredential.user!.email}");
      return userCredential.user;
    } catch (e) {
      log("Error during Google sign-in: $e");
      return null;
    }
  }

  /// **🔄 Save User Session in SharedPreferences**
  static Future<void> _setUserSession(bool isLoggedIn, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    await prefs.setString('user_email', email);
  }

  /// **🛠 Check if User is Logged In**
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// **📩 Get Logged-In User's Email**
  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}
