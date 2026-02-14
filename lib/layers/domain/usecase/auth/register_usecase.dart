import 'package:food_control/layers/domain/entity/auth_entity.dart';
import 'package:food_control/layers/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repo;

  RegisterUseCase(this.repo);

  Future<AuthEntity> call({
    required String uidName,
    required String pin,
  }) {
    return repo.register(uidName: uidName, pin: pin);
  }
}
