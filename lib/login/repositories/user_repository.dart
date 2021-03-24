import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final firebaseAuth = FirebaseAuth.instance;

  void firebaseSignOut() {
    this.firebaseAuth.signOut();
  }

  Future<UserCredential> signUp(
      {@required String email, @required String pass}) async {
    return await this
        .firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<UserCredential> signIn(
      {@required String email, @required String pass}) async {
    return await this
        .firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass);
  }

  Future resetPassword({@required String email}) async {
    return await this.firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> refreshToken() async {
    final user = getUser();

    if (user == null) {
      return null;
    }

    return await user.getIdToken(true);
  }

  Future<void> logOut() async {
    await this.firebaseAuth.signOut();
  }

  User getUser() {
    return this.firebaseAuth.currentUser;
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  Future<void> sendUserData({
    @required String name,
    @required String email,
    @required String uid,
    String access,
    String medicId,
  }) async {
    final userData = {
      "name": name,
      "email": email,
      "access": access,
      "medicId": medicId,
    };

    await FirebaseFirestore.instance.collection("users").doc(uid).set(userData);
  }

  Future<void> setupFcmNotification(User user) async {
    var fcm = FirebaseMessaging.instance;
    var fcmToken = await fcm.getToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({"notificationToken": fcmToken}, SetOptions(merge: true));
  }

  /* Future<UserModel> getUserModel() async {
    final user = this.getUser();
    if (user == null) {
      return null;
    }
    final userData = await this.getUserData(user.uid);
    return UserModel(
      email: userData.data()["email"],
      name: userData.data()["name"],
      access: userData.data()["access"],
      uid: user.uid,
    );
  } */
}
