part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, error, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? account;
  final String? errorMessage;

  /// PIN sahifasiga tayyorligini bildiradi
  final bool isReadyForPin;
  final bool isReadyForPinLogin;

  const AuthState({
    this.status = AuthStatus.initial,
    this.account,
    this.errorMessage,
    this.isReadyForPin = false,
    this.isReadyForPinLogin = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? account,
    String? errorMessage,
    bool? isReadyForPin,
    bool? isReadyForPinLogin,
  }) {
    return AuthState(
      status: status ?? this.status,
      account: account ?? this.account,
      errorMessage: errorMessage,
      isReadyForPin: isReadyForPin ?? this.isReadyForPin,
      isReadyForPinLogin: isReadyForPinLogin ?? this.isReadyForPinLogin,
    );
  }

  @override
  List<Object?> get props => [status, account, errorMessage, isReadyForPin,isReadyForPinLogin];
}
