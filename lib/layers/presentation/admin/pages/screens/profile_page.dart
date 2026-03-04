import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/splash/splash_logo_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedRole;
  final TextEditingController _staffNameController = TextEditingController();
  final TextEditingController _staffPinController = TextEditingController();

  @override
  void dispose() {
    _staffNameController.dispose();
    _staffPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final account = authCubit.state.account;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, size: 25, color: Colors.white),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          /// 🔵 Background gradient
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF7043), Color(0xffFF5722)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),

          /// ⚪ Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildAdminInfoCard(account),
                    const SizedBox(height: 20),
                    _buildAddStaffSection(authCubit, account),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminInfoCard(account) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Ma'lumotlari",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              account?.uidName ?? "Noma'lum",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Role: ${account?.role ?? "Noma'lum"}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddStaffSection(AuthCubit authCubit, account) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Staff Qo'shish",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: const Text("Role tanlang"),
              items: const [
                DropdownMenuItem(value: 'cheff', child: Text("Cheff")),
                DropdownMenuItem(value: 'waiter', child: Text("Waiter")),
                DropdownMenuItem(value: 'user', child: Text("User")),
              ],
              onChanged: (value) => setState(() => _selectedRole = value),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _staffNameController,
              decoration: const InputDecoration(
                labelText: "Staff nomi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _staffPinController,
              decoration: const InputDecoration(
                labelText: "Staff PIN",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Qo'shish"),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _addStaff(AuthCubit authCubit, account) async {
  //   if (_selectedRole == null || _staffNameController.text.isEmpty || _staffPinController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Iltimos barcha maydonlarni to'ldiring")),
  //     );
  //     return;
  //   }

  //   try {
  //     final exists = await authCubit.repository.checkSubAccountExists(
  //       ownerUid: FirebaseAuth.instance.currentUser!.uid,
  //       role: _selectedRole!,
  //     );

  //     if (exists) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Siz faqat bitta $_selectedRole qo'sha olasiz")),
  //       );
  //       return;
  //     }

  //     await authCubit.repository.createStaff(
  //       uidName: _staffNameController.text.trim(),
  //       role: _selectedRole!,
  //       pin: _staffPinController.text.trim(),
  //     );

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("$_selectedRole muvaffaqiyatli qo'shildi")),
  //     );

  //     _staffNameController.clear();
  //     _staffPinController.clear();
  //     setState(() => _selectedRole = null);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Xatolik yuz berdi: $e")),
  //     );
  //   }
  // }

  
   Future<bool> _logout() async {
    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

          backgroundColor: Colors.white,
          title: Text(
            'Ishonchingiz komilmi?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          content: Text(
            'Rostdanham tizimdan chiqishni xohlaysizmi?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Bekor qilish',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Bloc ichidagi state orqali uidName ni olish
                // final uidName = context
                //     .read<AuthCubit>()
                //     .state
                //     .account
                //     ?.uidName;

                context.read<AuthCubit>().logout();

                // if (uidName != null) {
                // await context.read<AuthCubit>().deleteAccount(uidName);

                // Delete tugagach sahifani Login/Register ga yo'naltirish
                if (!mounted) return;
                Navigator.of(dialogContext).pop(true);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SplashLogoPage()),
                  (route) => false,
                );
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                'O\'chirish',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

}