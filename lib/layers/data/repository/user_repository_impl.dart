import 'package:food_control/layers/data/services/user_service.dart';
import 'package:food_control/layers/domain/entity/user_entity.dart';
import 'package:food_control/layers/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService service;

  UserRepositoryImpl(this.service);

  @override
  Future<UserEntity> getUser(String uidName) => service.getUser(uidName);

  @override
  Future<void> updateUser(String uidName, Map<String, dynamic> data) =>
      service.updateUser(uidName, data);

  @override
  Future<void> deleteUser(String uidName) => service.deleteUser(uidName);
}