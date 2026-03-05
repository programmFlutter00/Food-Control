import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';

import 'package:food_control/layers/presentation/admin/pages/screens/orders_list_page.dart';
import 'package:food_control/layers/presentation/admin/pages/screens/products_list_page.dart';
import 'package:food_control/layers/presentation/admin/pages/screens/statistics_page.dart';
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

    if (uidName == null || uidName.isEmpty) {
      _goToLogin();
      return;
    }

    // 🔥 Firebase tekshiruv
    final doc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(uidName)
        .get();

    if (!mounted) return;

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final role = data['role'] ?? 'user';

      _goToRolePage(role);
    } else {
      // 🔥 Account o‘chirilgan bo‘lsa local ham tozalanadi
      await prefs.remove('uidName');
      _goToLogin();
    }
  }

  void _goToRolePage(String role) {
    Widget page;

    switch (role) {
      case 'admin':
        page = const MainNavigationPage();
        break;
      case 'chef':
        page = const OrdersListPage();
        break;
      case 'waiter':
        page = const ProductsListPage();
        break;
      case 'user':
      default:
        page = const StatisticsPage();
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
              const Gap(10),
              const Text(
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


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';
// import 'package:food_control/layers/presentation/auth/pages/login_page.dart';
// import 'package:food_control/layers/presentation/style/app_colors.dart';
// import 'package:food_control/layers/presentation/style/icons.dart';
// import 'package:gap/gap.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashLogoPage extends StatefulWidget {
//   const SplashLogoPage({super.key});

//   @override
//   State<SplashLogoPage> createState() => _SplashLogoPageState();
// }

// class _SplashLogoPageState extends State<SplashLogoPage> {
//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     await Future.delayed(const Duration(seconds: 2));

//     final prefs = await SharedPreferences.getInstance();
//     final uidName = prefs.getString('uidName');

//     if (uidName == null || uidName.isEmpty) {
//       _goToLogin();
//       return;
//     }

//     // 🔥 Firebase tekshiruv
//     final doc = await FirebaseFirestore.instance
//         .collection('accounts')
//         .doc(uidName)
//         .get();

//     if (!mounted) return;

//     if (doc.exists) {
//       _goToHome();
//     } else {
//       // 🔥 Account o‘chirilgan bo‘lsa local ham tozalanadi
//       await prefs.remove('uidName');
//       _goToLogin();
//     }
//   }

//   void _goToHome() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const MainNavigationPage()),
//       (route) => false,
//     );
//   }

//   void _goToLogin() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//       (route) => false,
//     );
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
//               Gap(10),
//               Text(
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
