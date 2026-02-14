import 'package:flutter/material.dart';

class StandartPadding extends StatelessWidget {
  final Widget child;
  const StandartPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: child);
  }
}
