import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:food_control/application/network_status/network_status.dart';
import 'package:food_control/di/di.dart';
import 'package:food_control/layers/data/repository/network_repository_impl.dart';
import 'package:food_control/layers/domain/repository/network_repository.dart';

Future<void> setUpNetworkStatusDi() async{
  sl.registerLazySingleton(() => Connectivity());

  // 🔹 Repository
  sl.registerLazySingleton<NetworkRepository>(
      () => NetworkRepositoryImpl(sl()));

  // 🔹 Cubit
  sl.registerFactory(() => NetworkCubit(sl()));
}