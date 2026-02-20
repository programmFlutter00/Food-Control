import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:food_control/layers/domain/entity/network_status_entity.dart';
import 'package:food_control/layers/domain/repository/network_repository.dart';

class NetworkState {
  final NetworkStatus status;
  const NetworkState(this.status);
}

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkRepository repository;
  late final StreamSubscription<NetworkStatus> _subscription;

  NetworkCubit(this.repository)
      : super(const NetworkState(NetworkStatus.online)) {
    _subscription = repository.networkStatus.listen((status) {
      emit(NetworkState(status));
    });
  }

  // 🔹 Retry yoki tashqaridan chaqirish uchun
  Future<void> checkStatus() async {
    final status = await repository.networkStatus.first;
    emit(NetworkState(status));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}