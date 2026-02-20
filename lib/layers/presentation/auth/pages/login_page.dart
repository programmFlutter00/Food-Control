import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control/application/network_status/network_status.dart';
import 'package:food_control/layers/domain/entity/network_status_entity.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/auth/pages/pin/pin_login_page.dart';
import 'package:food_control/layers/presentation/auth/pages/register_page.dart';
import 'package:food_control/layers/presentation/helpers/app_notification.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:food_control/layers/presentation/widgets/standart_padding.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;

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
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        final NetworkStatus currentStatus = state.status;
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // Navigator chaqiruvini post-frame ichida qilamiz
            if (state.isReadyForPinLogin &&
                state.errorMessage == null &&
                mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PinLoginPage(name: _controller.text.trim()),
                  ),
                );
              });
            } else if (state.errorMessage?.isNotEmpty ?? false) {
              InAppNotification.showError(context, state.errorMessage!);
              // showMessage(context: context, message: state.errorMessage!);
            }
          },

          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: StandartPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(70),
                      const Text(
                        "Tizimga Kirish",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '''Tizimga kirish uchun hisobingizni kiriting!''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(10),
                      TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Hisob nomi',
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
                      Gap(10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Hali hisobingiz yo'qmi?",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.standart,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: CustomFloatingActionButton(
                onPressed: () {
                  final name = _controller.text.trim();
                  if (name.isEmpty) {
                    InAppNotification.showError(
                      context,
                      "Hisob nomi kiritilmadi",
                    );

                    return;
                  }
                  if (currentStatus == NetworkStatus.offline) {
                    if (name.isEmpty) {
                      InAppNotification.showSuccess(context, "Siz oflinesiz");

                      return;
                    }
                  }
                  context.read<AuthCubit>().checkLoginAndGoPin(name);
                },
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
            );
          },
        );
      },
    );
  }
}
