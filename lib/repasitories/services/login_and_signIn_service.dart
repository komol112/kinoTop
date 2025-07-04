import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'createdAt': Timestamp.now(),
    });
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // add
}
