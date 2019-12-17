import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  Map<String, dynamic> userData = Map();
  FirebaseAuth userAuth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isLoading = false;


  Future<void> signUp({
    @required Map<String, dynamic> userDados, 
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    await userAuth.createUserWithEmailAndPassword(
      email: userDados["email"],
      password: pass
    )
    .then((resp) async{
      await saveUserData(userDados);
      this.user = resp.user;
      onSuccess();
      isLoading = false;
      notifyListeners();

    })
    .catchError((error){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email, 
  @required String pass,
  @required VoidCallback onSuccess,
  @required VoidCallback onFail}) async{
    isLoading = true;
    notifyListeners();
    await userAuth.signInWithEmailAndPassword(
      email: email,
      password: pass
    )
    .then((resp) async {
      await loadUser();
      loadUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    })
    .catchError((error){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void logOut() async{
    await this.userAuth.signOut();
    this.userData = Map();
    this.user = null;
  }

  Future<void> loadUser() async{
    if(this.user == null){
      this.user = await this.userAuth.currentUser();
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    await Firestore.instance.collection("users").document().setData(userData);
  }

  bool isLoggedIn(){
    return this.user != null;
  }
}