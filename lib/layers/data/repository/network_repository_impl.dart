import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:food_control/layers/domain/entity/network_status_entity.dart';
import 'package:food_control/layers/domain/repository/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final Connectivity _connectivity;

  NetworkRepositoryImpl(this._connectivity);

  @override
  Stream<NetworkStatus> get networkStatus async* {
    yield await _checkConnection();

    yield* _connectivity.onConnectivityChanged.map((result) {
      return result == ConnectivityResult.none
          ? NetworkStatus.offline
          : NetworkStatus.online;
    });
  }

  Future<NetworkStatus> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.none
        ? NetworkStatus.offline
        : NetworkStatus.online;
  }
}