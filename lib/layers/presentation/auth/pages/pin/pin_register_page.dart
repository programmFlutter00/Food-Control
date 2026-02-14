import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/layers/presentation/auth/widgets/error_dialog.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:pinput/pinput.dart';
import 'package:food_control/layers/presentation/admin/pages/main_navigation_page.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/helpers/snac_bar.dart';
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
    // _pinController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    final pin = _pinController.text.trim();
    if (pin.isEmpty || pin.length > 5){
      showErrorDialog(context, "Iltimos pin kodni to'liq kiriting!");
    }
    if (pin.length == 5) {
      // PIN to'liq kiritilgan, avtomatik yuborish
      context.read<AuthCubit>().register(widget.name, pin);
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
        } else if (state.status == AuthStatus.unauthenticated &&
            state.errorMessage != null) {
          showMessage(context: context, message: state.errorMessage!);
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
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(15),
                  const Text(
                    "PIN yarating",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Gap(6),
                  const Text(
                    "5 xonali PIN kiriting",
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