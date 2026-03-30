import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_control/layers/presentation/helpers/pin_hash_helper.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get accounts => _firestore.collection('accounts');

  Future<String> anonymousLogin() async {
    final user = await _auth.signInAnonymously();
    return user.user!.uid;
  }

  Future<DocumentSnapshot> getAccount(String uidName) {
    return accounts.doc(uidName).get();
  }

  Future<void> updateAccount({
    required String uidName,
    required Map<String, dynamic> data,
  }) {
    return accounts.doc(uidName).update(data);
  }

  String generateRandomPin() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString();
  }

  Future<void> createAdminStructure({
    required String uidName,
    required String pin,
  }) async {
    final adminUid = await anonymousLogin();

    final batch = _firestore.batch();

    final chefPin = generateRandomPin();
    final waiterPin = generateRandomPin();
    final userPin = generateRandomPin();

    /// ADMIN
    batch.set(accounts.doc(uidName), {
      "uidName": uidName,
      "user_name": uidName,
      "role": "admin",
      "ownerUid": adminUid,
      "pinHash": hashPin(pin),
    });

    /// CHEF
    batch.set(accounts.doc("$uidName-chef"), {
      "uidName": "$uidName-chef",
      "role": "chef",
      "ownerUid": adminUid,
      "pinHash": hashPin(chefPin),
    });

    /// WAITER
    batch.set(accounts.doc("$uidName-waiter"), {
      "uidName": "$uidName-waiter",
      "role": "waiter",
      "ownerUid": adminUid,
      "pinHash": hashPin(waiterPin),
    });

    /// USER
    batch.set(accounts.doc("$uidName-user"), {
      "uidName": "$uidName-user",
      "role": "user",
      "ownerUid": adminUid,
      "pinHash": hashPin(userPin),
    });

    await batch.commit();
  }
}