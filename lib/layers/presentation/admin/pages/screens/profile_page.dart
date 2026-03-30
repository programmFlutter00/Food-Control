import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/data/services/user_service.dart';
import 'package:food_control/layers/presentation/admin/widgets/show_dialog/delete_show_dialog.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/helpers/app_notification.dart';
import 'package:food_control/layers/presentation/helpers/pin_hash_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userService = UserService();

  bool _isValidName(String value) {
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    return value.length >= 6 && hasLetter && hasNumber && hasSpecial;
  }

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
            onPressed: () {
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
            child: const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
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
                    const Text(
                      "Barcha hisoblar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("Iltimos, tizimga kiring"));
    }

    final ownerUid = currentUser.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('accounts')
          .where('ownerUid', isEqualTo: ownerUid)
          .snapshots(),
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

            final nameController = TextEditingController(text: uidName);
            final pinController = TextEditingController();

            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9_!@#$%^&*(),.?":{}|<>\-]'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Hisob Nomi",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // faqat raqam
                        LengthLimitingTextInputFormatter(5), // maksimum 5 ta
                      ],
                      decoration: const InputDecoration(
                        labelText: "PIN",
                        // helperText: "5 xonali PIN kiriting",
                        
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final newDisplayName = nameController.text.trim();
                        final newPin = pinController.text.trim();

                        final updateData = <String, dynamic>{};

                        /// 🔴 NAME VALIDATION
                        if (newDisplayName.isNotEmpty) {
                          if (!_isValidName(newDisplayName)) {
                             InAppNotification.showError(context, "Bu hisob xavfsiz emas!");  
                            return;
                          }

                          updateData['displayName'] = newDisplayName;
                        }

                        /// 🔴 NAME VALIDATION
                        if (newPin.isNotEmpty) {
                          if (newPin.length != 5 ||
                              int.tryParse(newPin) == null) {
                                InAppNotification.showError(context, "PIN 5 ta raqam bo‘lishi kerak!");  
                            
                            return;
                          }

                          updateData['pinHash'] = hashPin(newPin);
                        }

                        if (newDisplayName.isNotEmpty) {
                          updateData['displayName'] = newDisplayName;
                        }

                        if (newPin.isNotEmpty) {
                          updateData['pinHash'] = hashPin(newPin);
                        }

                        await userService.updateUser(uidName, updateData);

                       InAppNotification.showSuccess(context, "Hisob yangilandi");
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
}
