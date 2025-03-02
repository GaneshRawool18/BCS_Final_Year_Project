import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

String? downLoadUrl;

class FirebaseServices {
  static void firebaseAddData(
      String name, String jersyNo, String teamName) async {
    Map<String, dynamic> data = {
      "playerName": name,
      "jersyNo": jersyNo,
      "teamName": teamName,
      "imageUrl": downLoadUrl!,
    };
    log("Team name $teamName");
    DocumentReference refData =
        FirebaseFirestore.instance.collection("franchises").doc(teamName);
    CollectionReference refcall = refData.collection("players");
    DocumentReference docRef = refcall.doc(name);

    await docRef.set(data);

    log("${data}");
  }

  // static void getFirebaseData(String teamName, context) async {
  //   log("hello");
  //   DocumentReference docref =
  //       FirebaseFirestore.instance.collection("franchises").doc(teamName);
  //   DocumentSnapshot docData = await docref.get();

  //   dynamic newData = [];
  //   Map<String, dynamic> data = docData.data() as Map<String, dynamic>;
  //   for (dynamic val in data.entries) {
  //     newData.add({val.key: val.value});
  //     log(newData);
  //   }

  //   // for (dynamic val in docref.docs) {
  //   //   newData.add(val);
  //   //   log("New Data : $newData");
  //   //   log("hello");
  //   // }

  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return IplTeam(
  //       newData: newData,
  //       team: teamName,
  //     );
  //   }));
  // }

  static void putFirebaseStorageData(
    String name,
    File path,
  ) async {
    Reference ref = FirebaseStorage.instance.ref().child("images/$name");
    UploadTask task = ref.putFile(path);
    final snapshot = await task;

    String url = await snapshot.ref.getDownloadURL();
    downLoadUrl = url;
  }

  static void createUserAccount(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    log("sign up successfully");
    log(email);
  }

  static Future<void> userFirebaseLogin(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    log("login up successfully");
    log(email);
  }

  static Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      log("User signed out successfully");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  static Future loginWithGoogle() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      log("Error during Google sign-in: $e");
      return null;
    }
  }
}
