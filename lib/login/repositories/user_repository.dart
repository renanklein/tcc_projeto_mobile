import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class UserRepository {
  final firebaseAuth = FirebaseAuth.instance;

  void firebaseSignOut() {
    this.firebaseAuth.signOut();
  }

  Future<AuthResult> signUp(
      {@required String email, @required String pass}) async {
    return await this
        .firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<AuthResult> signIn(
      {@required String email, @required String pass}) async {
    return await this
        .firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass);
  }

  Future resetPassword({@required String email}) async {
    return await this.firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<IdTokenResult> getToken() async {
    final user = await getUser();

    if (user == null) {
      return null;
    }

    return await user.getIdToken();
  }

  Future<void> logOut() async {
    await this.firebaseAuth.signOut();
  }

  Future<FirebaseUser> getUser() async {
    return await this.firebaseAuth.currentUser();
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await Firestore.instance.collection("users").document(uid).get();
  }

  Future<void> sendUserData(
      {@required String name,
      @required String email,
      @required String uid}) async {
    final userData = {"name": name, "email": email};

    await Firestore.instance
        .collection("users")
        .document(uid)
        .setData(userData);
  }

  Future<void> setupFcmNotification(FirebaseUser user) async {
    var fcm = Injector.appInstance.getDependency<FirebaseMessaging>();
    var fcmToken = await fcm.getToken();
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection("tokens")
        .document(fcmToken)
        .setData({"token": fcmToken});
  }
}
