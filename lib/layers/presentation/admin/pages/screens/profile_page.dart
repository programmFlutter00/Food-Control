import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/admin/widgets/show_dialog/delete_show_dialog.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/helpers/pin_hash_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final account = authCubit.state.account;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: (){
              customDeleteShowDialog(context);
            },
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // _buildAdminInfoCard(account),
                    // const SizedBox(height: 20),
                    const Text(
                      "Barcha hisoblar",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSubAccountsList(account),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSubAccountsList(account) {
  final accountsCollection = FirebaseFirestore.instance.collection('accounts');
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    // Foydalanuvchi tizimga kirmagan
    return const Center(
      child: Text("Iltimos, tizimga kiring"),
    );
  }

  final ownerUid = currentUser.uid;

  return StreamBuilder<QuerySnapshot>(
    stream: accountsCollection.where('ownerUid', isEqualTo: ownerUid).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final docs = snapshot.data!.docs;

      if (docs.isEmpty) {
        return const Text("Sub-accountlar mavjud emas");
      }

      return Column(
        children: docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final role = data['role'] ?? '';
          final uidName = data['uidName'] ?? '';
          final displayName = data['displayName'] ?? uidName;

          final nameController = TextEditingController(text: displayName);
          final pinController = TextEditingController();

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Role: $role",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Display Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pinController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "PIN",
                      border: OutlineInputBorder(),
                      
                    ),
                    
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final newDisplayName = nameController.text.trim();
                      final newPin = pinController.text.trim();

                      final updateData = <String, dynamic>{};
                      if (newDisplayName.isNotEmpty) updateData['displayName'] = newDisplayName;
                      if (newPin.isNotEmpty) updateData['pinHash'] = hashPin(newPin);

                      await accountsCollection.doc(uidName).update(updateData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sub-account yangilandi")),
                      );
                    },
                    child: const Text("Update"),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

//   Widget _buildSubAccountsList(account) {
//   final accountsCollection = FirebaseFirestore.instance.collection('accounts');
//   final ownerUid = FirebaseAuth.instance.currentUser!.uid; // shu yerda

//   return StreamBuilder<QuerySnapshot>(
//     stream: accountsCollection.where('ownerUid', isEqualTo: ownerUid).snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final docs = snapshot.data!.docs;

//       if (docs.isEmpty) {
//         return const Text("Sub-accountlar mavjud emas");
//       }

//       return Column(
//         children: docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           final role = data['role'] ?? '';
//           final uidName = data['uidName'] ?? '';
//           final displayName = data['displayName'] ?? uidName;

//           final nameController = TextEditingController(text: displayName);
//           final pinController = TextEditingController();

//           return Card(
//             elevation: 1,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Role: $role",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       labelText: "Display Name",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: pinController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: "PIN",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final newDisplayName = nameController.text.trim();
//                       final newPin = pinController.text.trim();

//                       final updateData = <String, dynamic>{};
//                       if (newDisplayName.isNotEmpty) updateData['displayName'] = newDisplayName;
//                       if (newPin.isNotEmpty) updateData['pinHash'] = hashPin(newPin);

//                       await accountsCollection.doc(uidName).update(updateData);

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Sub-account yangilandi")),
//                       );
//                     },
//                     child: const Text("Update"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       );
//     },
//   );
// }
  
  
  // Future<bool> _logout() async {
  //   if (!mounted) return false;

  //   final result = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //         backgroundColor: Colors.white,
  //         title: const Text(
  //           'Ishonchingiz komilmi?',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
  //         ),
  //         content: const Text(
  //           'Rostdanham tizimdan chiqishni xohlaysizmi?',
  //           style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black54),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(dialogContext).pop(false),
  //             child: Text(
  //               'Bekor qilish',
  //               style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               context.read<AuthCubit>().logout();
  //               if (!mounted) return;
  //               Navigator.of(dialogContext).pop(true);
  //               Navigator.of(context).pushAndRemoveUntil(
  //                 MaterialPageRoute(builder: (_) => const SplashLogoPage()),
  //                 (route) => false,
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red,
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //             ),
  //             child: const Text(
  //               'O\'chirish',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   return result ?? false;
  // }


}