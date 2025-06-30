

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

  static Stream<QuerySnapshot> getProducts() {
    return _firestore.collection('products').snapshots();
  }

  static Future<DocumentSnapshot> getProductById(String id) {
    return _firestore.collection('products').doc(id).get();
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> addToCart(String userId, String productId) {
    return _firestore
        .collection('carts')
        .doc(userId)
        .collection('cartItems')
        .doc(productId)
        .set({'quantity': 1});
  }

  // add
  static Future<void> addProduct({
    required String name,
    required double price,
    required List<String> images,
    required String description,
    required List<String> colors,
    required String category,
    double? originalPrice,
    double? discountPercent,
    double? rating,
    int? reviews,
  }) async {
    await _firestore.collection('products').add({
      'name': name,
      'price': price,
      'images': images,
      'description': description,
      'colors': colors,
      'category': category,
      'originalPrice': originalPrice ?? price,
      'discountPercent': discountPercent ?? 0,
      'rating': rating ?? 0,
      'reviews': reviews ?? 0,
      'createdAt': Timestamp.now(),
    });
  }
}
