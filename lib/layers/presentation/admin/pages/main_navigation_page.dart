import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/pages/screens/orders_list_page.dart';
import 'package:food_control/layers/presentation/admin/pages/screens/products_list_page.dart';
import 'package:food_control/layers/presentation/admin/pages/screens/statistics_page.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// List of pages for bottom navigation
  final List<Widget> _pages = [
    const ProductsListPage(),
    const OrdersListPage(),
    const StatisticsPage(),
  ];

  /// Bottom navigation bar items
  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: 'Mahsulotlar',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long),
      label: 'Buyurtmalar',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.stacked_bar_chart_sharp),
      label: 'Statistika',
    ),
  ];

  /// Handles bottom navigation bar tap
  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Handles page view change
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration( boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, -3), // 🔥 shadow faqat top tomonda
            ),
          ],),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onBottomNavTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.standart,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            iconSize: 30,
            selectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            items: _bottomNavItems,
          ),
        ),
      ),
    );
  }
}
