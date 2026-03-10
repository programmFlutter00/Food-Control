import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_control/layers/data/services/auth_service.dart';
import 'package:food_control/layers/domain/entity/auth_entity.dart';
import 'package:food_control/layers/domain/repository/auth_repository.dart';
import 'package:food_control/layers/presentation/helpers/pin_hash_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService service;

  AuthRepositoryImpl(this.service);

  /// 🟢 REGISTER uchun tekshiruv
  /// nom mavjud bo'lsa → false
  /// mavjud bo'lmasa → true
  @override
  Future<bool> checkNameForRegister(String uidName) async {
    final doc = await service.accounts.doc(uidName).get();
    return !doc.exists;
  }

  /// 🔵 LOGIN uchun tekshiruv
  /// nom mavjud bo'lsa → true
  /// mavjud bo'lmasa → false
  @override
  Future<bool> checkNameForLogin(String uidName) async {
    final doc = await service.accounts.doc(uidName).get();
    return doc.exists;
  }

  /// 🔵 LOGIN
  @override
  Future<AuthEntity> login({
    required String uidName,
    required String pin,
  }) async {
    // final currentUid = await service.anonymousLogin();

    final doc = await service.accounts.doc(uidName).get();

    if (!doc.exists) {
      throw Exception("Account topilmadi");
    }

    final data = doc.data() as Map<String, dynamic>;

    /// 🔥 PIN tekshiruv
    if (data['pinHash'] != hashPin(pin)) {
      throw Exception("PIN noto‘g‘ri");
    }

    /// 🔥 MUHIM:
    /// Bu account kimning ekanini tekshiramiz
    /// Agar boshqa adminnikiga kirishga urinsa blok bo‘ladi

    if (data['ownerUid'] == null) {
      throw Exception("Xatolik");
    }

    return AuthEntity(
      uidName: data['uidName'],
      role: data['role'],
      displayName: data['displayName'],
    );
  }

  /// 🟢 REGISTER → ADMIN
  @override
  Future<AuthEntity> register({
    required String uidName,
    required String pin,
  }) async {
    final adminUid = await service.anonymousLogin();

    final adminDoc = service.accounts.doc(uidName);

    if ((await adminDoc.get()).exists) {
      throw Exception("Account mavjud");
    }

    final batch = FirebaseFirestore.instance.batch();

    String generateRandomPin() {
      final random = Random();
      return (10000 + random.nextInt(90000)).toString();
    }

    final chefPin = generateRandomPin();
    final waiterPin = generateRandomPin();
    final userPin = generateRandomPin();

    /// ADMIN
    batch.set(adminDoc, {
      "uidName": uidName,
      "role": "admin",
      "ownerUid": adminUid,
      "pinHash": hashPin(pin),
      "displayName": null,
    });

    /// CHEF
    batch.set(service.accounts.doc("$uidName-chef"), {
      "uidName": "$uidName-chef",
      "role": "chef",
      "ownerUid": adminUid,
      "pinHash": hashPin(chefPin),
    });

    /// WAITER
    batch.set(service.accounts.doc("$uidName-waiter"), {
      "uidName": "$uidName-waiter",
      "role": "waiter",
      "ownerUid": adminUid,
      "pinHash": hashPin(waiterPin),
    });

    /// USER
    batch.set(service.accounts.doc("$uidName-user"), {
      "uidName": "$uidName-user",
      "role": "user",
      "ownerUid": adminUid,
      "pinHash": hashPin(userPin),
    });

    await batch.commit();

    return AuthEntity(uidName: uidName, role: "admin");
  }

  
  

  // update
  @override
  Future<void> updateAccount({
    required String uidName,
    Map<String, dynamic>? data,
  }) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    final docRef = service.accounts.doc(uidName);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception("Account topilmadi");
    }

    final accountData = snapshot.data() as Map<String, dynamic>;

    /// 🔥 MUHIM TEKSHIRUV
    /// Bu account shu adminnikimi?
    if (accountData['ownerUid'] != currentUid) {
      throw Exception("Ruxsat yo‘q");
    }

    await docRef.update(data ?? {});
  }

 }
