import 'package:food_control/layers/domain/entity/auth_entity.dart';
import 'package:food_control/layers/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repo;

  LoginUseCase(this.repo);

  Future<AuthEntity> call({
    required String uidName,
    required String pin,
  }) {
    return repo.login(uidName: uidName, pin: pin);
  }
}
