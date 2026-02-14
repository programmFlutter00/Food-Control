import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';
import 'package:food_control/layers/presentation/auth/pages/login_page.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/style/icons.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashLogoPage extends StatefulWidget {
  const SplashLogoPage({super.key});

  @override
  State<SplashLogoPage> createState() => _SplashLogoPageState();
}

class _SplashLogoPageState extends State<SplashLogoPage> {
@override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final uidName = prefs.getString('uidName');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            (uidName != null && uidName.isNotEmpty)
                ? const MainNavigationPage()
                : const LoginPage(),
      ),
      (route) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standart,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppIcons.spashLogo2, width: 100, height: 100),
              Gap(10),
              Text(
                "Food Control",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';
// import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
// import 'package:food_control/layers/presentation/auth/pages/login_page.dart';
// import 'package:food_control/layers/presentation/style/app_colors.dart';
// import 'package:food_control/layers/presentation/style/icons.dart';
// import 'package:gap/gap.dart';

// class SplashLogoPage extends StatefulWidget {
//   const SplashLogoPage({super.key});

//   @override
//   State<SplashLogoPage> createState() => _SplashLogoPageState();
// }

// class _SplashLogoPageState extends State<SplashLogoPage> {
//   @override
//   void initState() {
//     super.initState();

//     // Cubit status tekshirish uchun kichik delay bilan
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _checkAuthStatus();
//     });
//   }

//   void _checkAuthStatus() {
//     final authCubit = context.read<AuthCubit>();
//     final state = authCubit.state;

//     if (state.status == AuthStatus.authenticated && state.account != null) {
//       // Agar allaqachon login bo'lgan bo'lsa → Home
//       Future.delayed(const Duration(seconds: 2), () {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const MainNavigationPage()),
//           (route) => false,
//         );
//       });
//     } else {
//       // Login qilinmagan yoki xatolik → LoginPage
//       Future.delayed(const Duration(seconds: 2), () {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginPage()),
//           (route) => false,
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.standart,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(AppIcons.spashLogo2, width: 100, height: 100),
//               const Gap(10),
//               const Text(
//                 "Food Control",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
