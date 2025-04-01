import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';

class FirebaseServices {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Current User ID
  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Create User Account
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
          "profileImage":
              "assets/images/profile_pic.png", 
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

  // Sign In with Email & Password
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
        log("User signed in: ${user.email}");
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.message}");
      return null;
    }
  }

  // Google Sign-In
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
        log("Google Sign-In Successful: ${user.email}");
      }
      return user;
    } catch (e) {
      log("Error during Google sign-in: $e");
      return null;
    }
  }

  // User Logout 
  static Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await _setUserSession(false, "");
      Get.find<UserController>().clearUserData();
      log("User signed out.");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  // Upload Profile Image 
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

  // Add Expense for User 
  static Future<void> addExpense(
      String category, DateTime date, String amount, String description) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .add({
      'category': category,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'day': DateFormat('EEEE').format(date),
      'amount': double.tryParse(amount) ?? 0.0,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Update Expense
  static Future<void> updateExpense(String expenseId, String category,
      DateTime date, String amount, String description) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .doc(expenseId)
        .update({
      'category': category,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'day': DateFormat('EEEE').format(date),
      'amount': double.tryParse(amount) ?? 0.0,
      'description': description,
    });
  }

  // Delete Expense
  static Future<void> deleteExpense(String expenseId) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .doc(expenseId)
        .delete();
  }

  // Get Stream for User Expenses
  static Stream<QuerySnapshot> getExpensesStream() {
    String? userId = getCurrentUserId();
    if (userId == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Save User Data on First Google Login
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

  // Save User Session
  static Future<void> _setUserSession(bool isLoggedIn, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    await prefs.setString('user_email', email);
  }

  // Check if User is Logged In
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Get Logged-In User's Email
  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}
