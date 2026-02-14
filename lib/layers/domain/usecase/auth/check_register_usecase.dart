import 'package:food_control/layers/domain/repository/auth_repository.dart';

class CheckRegisterNameUseCase {
  final AuthRepository repo;

  CheckRegisterNameUseCase(this.repo);

  Future<bool> call(String uidName) {
    return repo.checkNameForRegister(uidName);
  }
}
