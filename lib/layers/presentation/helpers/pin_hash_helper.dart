import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:math';

String hashPin(String pin) {
  return sha256.convert(utf8.encode(pin)).toString();
}

String generateRandomPin() {
  final random = Random();
  return (10000 + random.nextInt(90000)).toString();
}