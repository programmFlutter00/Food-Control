import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:food_control/layers/domain/entity/auth_entity.dart';
import 'package:food_control/layers/domain/usecase/auth/check_login_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/check_register_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/login_usecase.dart';
import 'package:food_control/layers/domain/usecase/auth/register_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_control/layers/presentation/helpers/pin_hash_helper.dart';

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

  /// 🔹 REGISTER NAME CHECK → PIN sahifaga tayyor
  Future<void> checkRegisterAndGoPin(String uidName) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final available = await checkRegisterNameUseCase(uidName);
      if (available) {
        emit(
          state.copyWith(
            isReadyForPin: true,
            status: AuthStatus.initial,
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
    } catch (e) {
      debugPrint("Register check error: $e");
      emit(
        state.copyWith(
          status: AuthStatus.error,
          isReadyForPin: false,
          errorMessage: "Register tekshiruvida xatolik yuz berdi",
        ),
      );
    }
  }

  /// 🔹 LOGIN NAME CHECK → PIN sahifaga tayyor
  Future<void> checkLoginAndGoPin(String uidName) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
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
      } else {
        emit(
          state.copyWith(
            isReadyForPinLogin: false,
            status: AuthStatus.error,
            errorMessage: "Hisob topilmadi",
          ),
        );
      }
    } catch (e) {
      debugPrint("Login check error: $e");
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: "Login tekshiruvida xatolik yuz berdi",
          isReadyForPinLogin: false,
        ),
      );
    }
  }

  /// 🔹 REGISTER → admin bitta + 3 subaccounts
 Future<void> register({
  required String name,
  required String pin,
}) async {

  emit(state.copyWith(status: AuthStatus.loading));

  try {

    final account = await registerUseCase(
      uidName: name,
      pin: pin,
    );

    await saveUidName(name);

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        account: account,
      ),
    );

  } catch (e) {

    emit(
      state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Hisob yaratilmadi",
      ),
    );

  }

}
  /// 🔹 LOGIN → PIN bilan
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
      debugPrint("Login error: $e");
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: "PIN noto‘g‘ri",
        ),
      );
    }
  }

  /// 🔹 UID saqlash
  Future<void> saveUidName(String uidName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uidName', uidName);
  }

  Future<String?> getSavedUidName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uidName');
  }

  /// 🔹 LOGOUT
  // Future<void> logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('uidName');
  //   emit(const AuthState());
  // }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uidName');

    emit(const AuthState());
  }

  /// 🔹 FULL ACCOUNT DELETE (admin yoki user)
  Future<void> deleteAccount(String uidName) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
      final batch = FirebaseFirestore.instance.batch();
      final accountsCollection = FirebaseFirestore.instance.collection(
        'accounts',
      );
      final snapshot = await accountsCollection
          .where('uidName', isEqualTo: uidName)
          .get();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uidName');

      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: "Accountni o'chirishda xatolik: $e",
        ),
      );
    }
  }
}
