import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:my_soccer_academia/models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  UserModel? _userFromFirebase(auth.User? user) {
    if(user == null) {
      return null;
    }
    return UserModel(user.uid, user.email);
  }

  Stream<UserModel?>? get user{
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel?> signWithEmailAndPassword(String email, String password)
  async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  Future<UserModel?> createUserWithEmailAndPassword(String email, String password)
  async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}