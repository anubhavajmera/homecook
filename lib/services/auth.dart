import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:homecook/utilities/globals.dart';

final _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthService {
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final firebaseUser = _auth.currentUser;
      assert(user.uid == firebaseUser.uid);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> signOut() async {
    userToken = '';
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
