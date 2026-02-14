import 'package:food_control/di/di.dart';
import 'package:food_control/layers/data/repository/auth_repository_impl.dart';
import 'package:food_control/layers/data/services/auth_service.dart';
import 'package:food_control/layers/domain/repository/auth_repository.dart';
import 'package:food_control/layers/domain/usecase/auth/check_login_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/check_register_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/login_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/register_usecase.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';


void setupAuthDI() async {

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<FirebaseAuthService>()),
  );

  // UseCases
  sl.registerLazySingleton(() => CheckLoginNameUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckRegisterNameUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));

  // Cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        checkLoginNameUseCase: sl<CheckLoginNameUseCase>(),
        checkRegisterNameUseCase: sl<CheckRegisterNameUseCase>(),
      ));
}
