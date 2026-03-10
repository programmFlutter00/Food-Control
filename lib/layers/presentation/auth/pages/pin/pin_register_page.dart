import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/helpers/app_notification.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:pinput/pinput.dart';
import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/widgets/standart_padding.dart';
import 'package:gap/gap.dart';

class PinRegisterPage extends StatefulWidget {
  final String name;
  const PinRegisterPage({super.key, required this.name});

  @override
  State<PinRegisterPage> createState() => _PinRegisterPageState();
}
class _PinRegisterPageState extends State<PinRegisterPage> {
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  /// Random 5 raqamli PIN generatsiya qiluvchi helper
  String _generateRandomPin() {
    final random = DateTime.now().millisecondsSinceEpoch.remainder(90000) + 10000;
    return random.toString().substring(0, 5);
  }

  void _onPinChanged() {
    final pin = _pinController.text.trim();

    if (pin.isEmpty || pin.length > 5) {
      InAppNotification.showError(context, "Iltimos pin kodni to'liq kiriting!");
      return;
    }

    if (pin.length == 5) {
      // Admin PIN to'liq kiritildi, multi-account yaratish
      final authCubit = context.read<AuthCubit>();
      final adminName = widget.name;

      // Har bir sub-account uchun random pin yaratish
      final chefPin = _generateRandomPin();
      final waiterPin = _generateRandomPin();
      final userPin = _generateRandomPin();

      authCubit.register(
        name: adminName,
        pin: pin,
        
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 24, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainNavigationPage()),
            (route) => false,
          );
        } else if (state.status == AuthStatus.error && state.errorMessage != null) {
          InAppNotification.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          floatingActionButton: CustomFloatingActionButton(
            onPressed: _onPinChanged,
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
          ),
          body: StandartPadding(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(15),
                  const Text(
                    "PIN kod",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Gap(6),
                  const Text(
                    "Hisob uchun PIN kod yarating",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(12),
                  Pinput(
                    length: 5,
                    controller: _pinController,
                    obscureText: true,
                    obscuringCharacter: '●',
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.standart, width: 2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}