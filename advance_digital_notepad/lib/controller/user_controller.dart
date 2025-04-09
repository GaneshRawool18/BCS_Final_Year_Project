// UserController.dart
import 'dart:io';
import 'package:advance_digital_notepad/controller/local_database_helper.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class UserController extends GetxController {
  var userName = "".obs;
  var email = "".obs;
  var phoneNumber = "".obs;
  var profileImagePath = "assets/images/profile_pic.png".obs;

  final LocalDatabaseHelper _dbHelper = LocalDatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        userName.value = data["name"] ?? "";
        email.value = data["email"] ?? "";
        phoneNumber.value = data["mobile"] ?? "";
        profileImagePath.value = data["profileImage"] ?? "assets/images/profile_pic.png";
        await _dbHelper.insertOrUpdateUserProfile(user.uid, userName.value, email.value, phoneNumber.value, profileImagePath.value);
      }
    }
  }

  Future<void> updateUserProfile(String name, String phone) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "name": name,
        "mobile": phone,
      });
      userName.value = name;
      phoneNumber.value = phone;
      await _dbHelper.insertOrUpdateUserProfile(user.uid, name, email.value, phone, profileImagePath.value);
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(imageFile.path);
      final String localPath = p.join(appDir.path, fileName);
      final File localImage = await imageFile.copy(localPath);
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "profileImage": localImage.path,
      });
      profileImagePath.value = localImage.path;
      await _dbHelper.insertOrUpdateUserProfile(user.uid, userName.value, email.value, phoneNumber.value, localImage.path);
    }
  }

  Future<File?> loadLocalProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _dbHelper.getUserProfile(user.uid);
      if (userData != null && userData['imagePath'] != null) {
        String path = userData['imagePath'];
        if (await File(path).exists()) {
          profileImagePath.value = path;
          return File(path);
        }
      }
    }
    return null;
  }

  void clearUserData() {
    userName.value = "";
    email.value = "";
    phoneNumber.value = "";
    profileImagePath.value = "assets/images/profile_pic.png";
  }
}
