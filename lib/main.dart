import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/application/network_status/network_status.dart';
import 'package:food_control/di/di.dart';
import 'package:food_control/firebase_options.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/splash/splash_logo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupAppDI();
  // NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<NetworkCubit>(create: (_) => sl<NetworkCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashLogoPage(),
      ),
    );
  }
}
