import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthApi{
  static final _googleSignIn = GoogleSignIn(scopes: ['https://mail.google.com']);

  static Future<GoogleSignInAccount> signIn() async{
    if(await _googleSignIn.isSignedIn()){
      return _googleSignIn.currentUser;
    }

    return _googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount> signOut() => _googleSignIn.signOut();
}