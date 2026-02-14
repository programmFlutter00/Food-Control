import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String> anonymousLogin() async {
    final user = await _auth.signInAnonymously();
    return user.user!.uid;
  }

  CollectionReference get accounts =>
      _firestore.collection('accounts');
}
