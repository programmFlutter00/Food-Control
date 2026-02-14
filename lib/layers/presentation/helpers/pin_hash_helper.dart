import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPin(String pin) {
  return sha256.convert(utf8.encode(pin)).toString();
}
