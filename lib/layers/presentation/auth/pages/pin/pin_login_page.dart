import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/helpers/app_notification.dart';
import 'package:food_control/layers/presentation/splash/splash_logo_page.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:pinput/pinput.dart';
import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';
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

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    // _pinController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    final pin = _pinController.text.trim();
    if (pin.isEmpty || pin.length < 5) {
      InAppNotification.showError(context, "Iltimos pin kodni to'liq kiriting!");
      // showErrorDialog(context, "Iltimos pin kodni to'liq kiriting!");
    }
    if (pin.length == 5) {
      context.read<AuthCubit>().login(widget.name, pin);
    }
  }

  @override
  void dispose() {
    _pinController.removeListener(_onPinChanged);
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

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && state.account != null) {
          setState(() => _borderColor = Colors.green); // PIN to'g'ri
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SplashLogoPage()),
            (route) => false,
          );
        } else if (state.status == AuthStatus.unauthenticated &&
            state.errorMessage != null) {
          // PIN xato bo'lsa
          setState(() => _borderColor = Colors.red);
          _pinController.clear();
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() => _borderColor = Colors.grey);
          });
          
          // showMessage(context: context, message: "Pin xato, qaytadan urining");
        } else {
          setState(() => _borderColor = Colors.grey);
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
                  // if (state.status == AuthStatus.loading)
                  //   const Padding(
                  //     padding: EdgeInsets.only(top: 16.0),
                  //     child: CircularProgressIndicator(),
                  //   ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
