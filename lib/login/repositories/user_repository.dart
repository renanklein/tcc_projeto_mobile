import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  Future<AuthResult> signUp({
    @required String email,
    @required String pass,
  }) async {
    return await this._firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
  }

  Future<AuthResult> signIn({
    @required String email,
    @required String pass,
  }) async {
    return await this._firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
  }

  void firebaseSignOut() {
    this._firebaseAuth.signOut();
  }

  Future<void> logOut() async {
    await this._firebaseAuth.signOut();
  }

  Future resetPassword({
    @required String email,
  }) async {
    return await this._firebaseAuth.sendPasswordResetEmail(
          email: email,
        );
  }

  Future<IdTokenResult> getToken() async {
    final user = await getUser();

    if (user == null) {
      return null;
    }

    return await user.getIdToken();
  }

  Future<FirebaseUser> getUser() async {
    return await this._firebaseAuth.currentUser();
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await Firestore.instance.collection("users").document(uid).get();
  }

  Future<void> sendUserData({
    @required String name,
    @required String email,
    @required String uid,
  }) async {
    final userData = {"name": name, "email": email};

    await Firestore.instance
        .collection("users")
        .document(uid)
        .setData(userData);
  }

  Future<UserModel> getUserModel() async {
    final user = await this.getUser();
    if (user == null) {
      return null;
    }
    final userData = await this.getUserData(user.uid);
    return UserModel(
      email: userData.data["email"],
      name: userData.data["name"],
      uid: user.uid,
    );
  }
}
