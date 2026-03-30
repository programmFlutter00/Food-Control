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
    final doc = await service.getAccount(uidName);
    return !doc.exists;
  }

  /// 🔵 LOGIN uchun tekshiruv
  ///  nom mavjud bo'lsa → true
  ///  mavjud bo'lmasa → false
  @override
  Future<bool> checkNameForLogin(String uidName) async {
    final doc = await service.getAccount(uidName);
    return doc.exists;
  }

  /// LOGIN
  @override
  Future<AuthEntity> login({
    required String uidName,
    required String pin,
  }) async {
    final doc = await service.getAccount(uidName);

    if (!doc.exists) {
      throw Exception("Account topilmadi");
    }

    final data = doc.data() as Map<String, dynamic>;

    if (data['pinHash'] != hashPin(pin)) {
      throw Exception("PIN noto‘g‘ri");
    }

    if (data['ownerUid'] == null) {
      throw Exception("Xatolik");
    }

    return AuthEntity(
      uidName: data['uidName'],
      role: data['role'],
    );
  }

  /// REGISTER
  @override
  Future<AuthEntity> register({
    required String uidName,
    required String pin,
    required String ownerUid
  }) async {
    final doc = await service.getAccount(uidName);

    if (doc.exists) {
      throw Exception("Account mavjud");
    }

    await service.createAdminStructure(uidName: uidName, pin: pin);

    return AuthEntity(uidName: uidName, role: "admin");
  }

  /// UPDATE
  @override
  Future<void> updateAccount({
    required String uidName,
    Map<String, dynamic>? data,
  }) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await service.getAccount(uidName);

    if (!snapshot.exists) {
      throw Exception("Account topilmadi");
    }

    final accountData = snapshot.data() as Map<String, dynamic>;

    if (accountData['ownerUid'] != currentUid) {
      throw Exception("Ruxsat yo‘q");
    }

    await service.updateAccount(uidName: uidName, data: data ?? {});
  }
}
