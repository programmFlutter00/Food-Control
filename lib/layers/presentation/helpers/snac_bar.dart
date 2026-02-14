import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/style/icons.dart';
import 'package:gap/gap.dart';

OverlayEntry? _overlayEntry;
bool _isShowing = false;

/// xabarlar navbati
final List<String> _queue = [];

/// tashqaridan chaqiriladi
void showMessage({
  required BuildContext context,
  required String message,
}) {
  _queue.add(message);

  if (!_isShowing) {
    _showNext(context);
  }
}

void _showNext(BuildContext context) {
  if (_queue.isEmpty) {
    _isShowing = false;
    return;
  }

  _isShowing = true;
  final message = _queue.removeAt(0);

  _overlayEntry = OverlayEntry(
    builder: (_) => IgnorePointer(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 180,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppIcons.spashLogo2,
                        width: 20,
                        height: 20,
                      ),
                      const Gap(10),
                      Text(
                        message,
                        
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.standart,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);

  /// 🔹 3 soniya ko‘rinadi
  Future.delayed(const Duration(seconds: 3), () {
    _overlayEntry?.remove();
    _overlayEntry = null;

    /// 🔸 MUHIM QISM:
    /// snackbar to‘liq o‘chsin, keyin ozgina pauza bo‘lsin
    Future.delayed(const Duration(milliseconds: 250), () {
      _isShowing = false;
      _showNext(context);
    });
  });
}
