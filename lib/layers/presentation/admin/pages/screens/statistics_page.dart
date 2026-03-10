import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/widgets/show_dialog/delete_show_dialog.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final List<Map<String, dynamic>> _orders = [
    {"image": ''}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.standart,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 3), // 👈 faqat pastga
              ),
            ],
          ),
          child: AppBar(
        backgroundColor: AppColors.standart,
        title: Text("Statistika", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [  IconButton(
                onPressed: () {
                  customDeleteShowDialog(context);
                },
                icon: Icon(Icons.logout, size: 25, color: Colors.white),
              ),],
      ),)),
    );
  }
}