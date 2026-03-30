import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/auth/pages/pin/pin_register_page.dart';
import 'package:food_control/layers/presentation/helpers/app_notification.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:food_control/layers/presentation/widgets/standart_padding.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;

  bool _isValidName(String value) {
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    return value.length >= 6 && hasLetter && hasNumber && hasSpecial;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isReadyForPin && state.errorMessage == null && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PinRegisterPage(name: _controller.text.trim()),
              ),
            );
          });
        } else if (state.errorMessage?.isNotEmpty ?? false) {}
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: StandartPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(15),
                const Text(
                  "Ro'yxatdan o'tish",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Gap(6),
                const Text(
                  "Xavfsizlik uchun murakkab hisob kiriting",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(12),
                TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9_!@#$%^&*(),.?":{}|<>\-]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Hisob nomi (masalan: FoodControl_No.1)',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.standart,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          floatingActionButton: CustomFloatingActionButton(
            icon: state.status == AuthStatus.loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.login),
            onPressed: () async {
              final name = _controller.text.trim();

              if (name.isEmpty) {
                InAppNotification.showError(
                  context,
                  "Iltimos hisob nomini kiriting!",
                );
                return;
              }

              if (!_isValidName(name) || name.length < 7) {
                InAppNotification.showError(context, "Bu hisob xavfsiz emas!");
                return;
              }

              try {
                // 🔹 Anonymous login qilamiz
                final user = await FirebaseAuth.instance.signInAnonymously();
                print("Anonymous UID: ${user.user!.uid}");

                // 🔹 Cubit orqali tekshiruv
                await context.read<AuthCubit>().checkRegisterAndGoPin(name);
              } catch (e) {
                InAppNotification.showError(context, "Xatolik yuz berdi: $e");
              }
            },
          ),
        );
      },
    );
  }
}
