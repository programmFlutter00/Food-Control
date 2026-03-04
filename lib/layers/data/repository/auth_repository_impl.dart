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
    await service.anonymousLogin();

    final doc = await service.accounts.doc(uidName).get();

    if (!doc.exists) {
      throw Exception("Account topilmadi");
    }

    final data = doc.data() as Map<String, dynamic>;

    final storedPinHash = data['pinHash'] as String?;

    if (storedPinHash == null || storedPinHash != hashPin(pin)) {
      throw Exception("PIN noto‘g‘ri");
    }

    return AuthEntity(uidName: data['uidName'], role: data['role']);
  }

  /// 🟢 REGISTER → ADMIN
  @override
  Future<AuthEntity> register({
    required String uidName,
    required String pin,
  }) async {
    final uid = await service.anonymousLogin();
    final doc = service.accounts.doc(uidName);

    if ((await doc.get()).exists) {
      throw Exception("Account mavjud");
    }

    await doc.set({
      "uidName": uidName,
      "role": "admin",
      "ownerUid": uid,
      "pinHash": hashPin(pin),
    });

    return AuthEntity(uidName: uidName, role: "admin");
  }

  /// 👥 STAFF CREATE
  @override
  Future<void> createStaff({
    required String uidName,
    required String role,
    required String pin,
  }) async {
    final adminUid = FirebaseAuth.instance.currentUser!.uid;
    final doc = service.accounts.doc(uidName);

    if ((await doc.get()).exists) {
      throw Exception("Hisob mavjud");
    }

    await doc.set({
      "uidName": uidName,
      "role": role,
      "ownerUid": adminUid,
      "pinHash": hashPin(pin),
    });
  }

  Future<bool> checkSubAccountExists({
    required String ownerUid,
    required String role,
  }) async {
    final snapshot = await service.accounts
        .where('ownerUid', isEqualTo: ownerUid)
        .where('role', isEqualTo: role)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> createSubAccount({
    required String ownerUid,
    required String role,
  }) async {
    await service.accounts.add({
      "uidName": "$role-${DateTime.now().millisecondsSinceEpoch}",
      "role": role,
      "ownerUid": ownerUid,
    });
  }
}
