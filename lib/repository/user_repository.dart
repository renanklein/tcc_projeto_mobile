import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signUp({
    @required String email,
    @required String pass})
     async {
    return await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: pass);
  }

  Future<AuthResult> signIn({
     @required String email, 
     @required String pass}) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: pass);
  }

  Future<String> getToken({@required FirebaseUser user}) async {
     final idToken = await user.getIdToken();
     return idToken.token;
  }

  void logOut() async {
    await this.firebaseAuth.signOut();
  }

  Future<FirebaseUser> getUser() async {
    return await this.firebaseAuth.currentUser();
  }

  Future<void> sendUserData({
    @required String name,
    @required String email,
    @required String uid
  }) async {
    final userData = {
      "name" : name,
      "email" : email
    };

    await Firestore.instance
        .collection("users")
        .document(uid)
        .setData(userData);
  }
}
