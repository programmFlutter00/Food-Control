import 'package:food_control/layers/domain/repository/auth_repository.dart';

class CheckLoginNameUseCase {
  final AuthRepository repo;

  CheckLoginNameUseCase(this.repo);

  Future<bool> call(String uidName) {
    return repo.checkNameForLogin(uidName);
  }
}
