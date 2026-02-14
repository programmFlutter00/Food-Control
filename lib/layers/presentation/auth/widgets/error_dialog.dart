
import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:gap/gap.dart';

class ErrorDialog extends StatefulWidget {
  final String label;

  const ErrorDialog({
    super.key,
    required this.label,
  });

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // tashqariga bosilganda yopiladi
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // dialog ichida bosishni bloklash
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(
                  left: 16, right: 16, top: 14, bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(color: AppColors.standart, fontWeight: FontWeight.w700, fontSize: 19),
                  ),
                  Gap(20),
                  Align(
                    alignment:
                        Alignment.centerRight, // 🔹 o‘ng tomonga yopishtiradi
                    child: TextButton(
                      onPressed: () async {
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                       'TUSHUNDIM',
                        style: TextStyle(
                            fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showErrorDialog(
  BuildContext context,
  String label,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ErrorDialog(
      label: label,
    ),
  );
}
