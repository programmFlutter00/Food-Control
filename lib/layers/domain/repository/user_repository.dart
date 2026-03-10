import 'package:food_control/layers/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String uidName);
  Future<void> updateUser(String uidName, Map<String, dynamic> data);
  Future<void> deleteUser(String uidName);
}