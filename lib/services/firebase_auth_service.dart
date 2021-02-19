import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    User user;
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print(googleAuth.accessToken);
      print(googleAuth.idToken);

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      user = userCredential.user;
    } catch (e) {
      print(e);
    }
    return user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  User _userFromFirebase(User user) {
    return user == null ? null : user;
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }
}
