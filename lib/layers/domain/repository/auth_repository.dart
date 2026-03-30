import 'package:food_control/layers/domain/entity/auth_entity.dart';

abstract class AuthRepository {
  /// LOGIN (PIN bilan)
  Future<AuthEntity> login({required String uidName, required String pin});

  /// REGISTER (PIN bilan)
  Future<AuthEntity> register({required String uidName, required String pin , required String ownerUid});

  /// 🔥 YANGI FUNKSIYALAR
  Future<bool> checkNameForRegister(String uidName);
  Future<bool> checkNameForLogin(String uidName);

  Future<void> updateAccount({
    required String uidName,
    Map<String, dynamic>? data,
  });
}
