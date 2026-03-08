import 'package:flutter/material.dart';
import '../model/targetModel.dart';

class Targetnotifier {
  // notifier untuk menyimpan data saldo yang bisa digunakan di berbagai screen
  static ValueNotifier<TargetModel?> targetNotifier = ValueNotifier(null);
}
