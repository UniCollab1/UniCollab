import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final User user = userCredential.user;

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
