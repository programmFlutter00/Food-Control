import 'package:food_control/layers/domain/entity/network_status_entity.dart';

abstract class NetworkRepository {
  Stream<NetworkStatus> get networkStatus;
}