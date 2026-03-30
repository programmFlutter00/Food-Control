import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/helpers/app_notification.dart';
import 'package:food_control/layers/presentation/splash/splash_logo_page.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:pinput/pinput.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/widgets/standart_padding.dart';
import 'package:gap/gap.dart';

class PinLoginPage extends StatefulWidget {
  final String name;
  const PinLoginPage({super.key, required this.name});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  late final TextEditingController _pinController;
  Color _borderColor = Colors.grey;

  int _attemptsLeft = 3; // 🔹 3 urinish
  bool _isBlocked = false;
  DateTime? _blockedUntil;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  void _onPinChanged() async {
    if (_isBlocked) {
      final remaining = _blockedUntil!.difference(DateTime.now());
      if (remaining.inSeconds > 0) {
        InAppNotification.showError(
            context,
            "Siz bloklandingiz! ${remaining.inSeconds} soniyadan keyin qayta urinib ko'ring."
        );
        return;
      } else {
        _isBlocked = false;
        _attemptsLeft = 3;
      }
    }

    final pin = _pinController.text.trim();
    if (pin.length != 5) {
      InAppNotification.showError(context, "Iltimos 5 xonali PIN kiriting!");
      return;
    }

    final authCubit = context.read<AuthCubit>();
    final result = await authCubit.tryLogin(widget.name, pin); // yangi funksiya

    if (result) {
      // ✅ PIN to'g'ri
      setState(() => _borderColor = Colors.green);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SplashLogoPage()),
        (route) => false,
      );
    } else {
      // ❌ PIN noto'g'ri
      setState(() => _borderColor = Colors.red);
      _pinController.clear();
      _attemptsLeft--;

      if (_attemptsLeft <= 0) {
        _isBlocked = true;
        _blockedUntil = DateTime.now().add(const Duration(seconds: 30)); // 30 soniyaga blok
        InAppNotification.showError(
            context, "Siz 3 marta xato kiritdingiz! 30 soniyaga bloklandingiz."
        );
      } else {
        InAppNotification.showError(
            context, "PIN xato, ${_attemptsLeft} urinish qoldi!"
        );
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() => _borderColor = Colors.grey);
      });
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
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onPinChanged,
        icon: const Icon(Icons.login),
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
                "Hisobingizdagi PIN kodni kiriting",
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
  }
}