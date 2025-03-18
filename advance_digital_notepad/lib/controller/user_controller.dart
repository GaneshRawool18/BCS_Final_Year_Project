import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  var userName = "".obs;
  var email = "".obs;
  var phoneNumber = "".obs;
  var profileImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        userName.value = data["name"] ?? "";
        email.value = data["email"] ?? "";
        phoneNumber.value = data["mobile"] ?? "";
        profileImage.value = data["profileImage"] ?? "assets/images/profile_pic.png";
      }
    }
  }

  // Clear user data after logout
  void clearUserData() {
    userName.value = "";
    email.value = "";
    phoneNumber.value = "";
    profileImage.value = "assets/images/profile_pic.png";
  }

  // Update user profile
  Future<void> updateUserProfile(String name, String phone) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "name": name,
        "mobile": phone,
      });

      userName.value = name;
      phoneNumber.value = phone;
    }
  }
}
