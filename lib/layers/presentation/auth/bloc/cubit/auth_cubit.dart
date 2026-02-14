import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:food_control/layers/domain/entity/auth_entity.dart';
import 'package:food_control/layers/domain/usecase/auth/check_login_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/check_register_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/login_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/register_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckLoginNameUseCase checkLoginNameUseCase;
  final CheckRegisterNameUseCase checkRegisterNameUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkLoginNameUseCase,
    required this.checkRegisterNameUseCase,
  }) : super(const AuthState());

  Future<void> checkRegisterAndGoPin(String uidName) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final available = await checkRegisterNameUseCase(uidName);
    // debugPrint("UIDName: '$uidName', checkRegisterName: $available");

    if (available) {
      emit(
        state.copyWith(
          isReadyForPin: true,
          status: AuthStatus.initial, // hali authenticated emas
          errorMessage: null,
        ),
      );

      Future.delayed(const Duration(milliseconds: 100), () {
      emit(state.copyWith(isReadyForPin: false));
    });
    } else {
      emit(
        state.copyWith(
          isReadyForPin: false,
          status: AuthStatus.error,
          errorMessage: "Bu hisob allaqachon mavjud",
        ),
      );
    }

  }

  // LOGIN NAME CHECK → PIN sahifasiga tayyor
  Future<void> checkLoginAndGoPin(String uidName) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // try {
    final exists = await checkLoginNameUseCase(uidName);

    if (exists) {
      emit(
        state.copyWith(
          isReadyForPinLogin: true,
          status: AuthStatus.initial,
          errorMessage: null,
        ),
      );
    
     Future.delayed(const Duration(milliseconds: 100), () {
      emit(state.copyWith(isReadyForPinLogin: false));
    });
  }
    else {
      emit(
        state.copyWith(
          isReadyForPinLogin: false,
          status: AuthStatus.error,
          errorMessage: "Hisob topilmadi",
        ),
      );
    }
    // } catch (e) {
    //   debugPrint('Login error: $e');
    //   emit(
    //       state.copyWith(
    //         status: AuthStatus.error,
    //         errorMessage: "Hisob topilmadi",
    //         isReadyForPinLogin: false,
    //       ),
    //     );
    // }
  }

  // REGISTER → faqat PIN sahifasidan keyin authenticated
  Future<void> register(String uidName, String pin) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final account = await registerUseCase(uidName: uidName, pin: pin);

      await saveUidName(uidName);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          account: account,
          isReadyForPin: false,
        ),
      );
    } catch (e) {
      debugPrint('Login error: $e');
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: "Account yaratilmadi",
        ),
      );
    }
  }

  // LOGIN → faqat PIN sahifasidan keyin authenticated
  Future<void> login(String uidName, String pin) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final account = await loginUseCase(uidName: uidName, pin: pin);

      await saveUidName(uidName);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          account: account,
          isReadyForPinLogin: false,
        ),
      );
    } catch (e) {
      debugPrint('Login error: $e');
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: "PIN noto‘g‘ri",
        ),
      );
    }
  }

  // UID saqlash
  Future<void> saveUidName(String uidName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uidName', uidName);
  }

  Future<String?> getSavedUidName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uidName');
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uidName');

    emit(const AuthState());
  }
}
