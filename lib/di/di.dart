import 'package:food_control/di/auth_di.dart';
import 'package:food_control/layers/data/services/auth_service.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> setupAppDI() async{
   sl.registerLazySingleton(() => FirebaseAuthService());
   setupAuthDI();
}
