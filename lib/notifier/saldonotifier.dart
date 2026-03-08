import 'package:flutter/material.dart';

class Saldonotifier {
  // notifier untuk menyimpan data saldo yang bisa digunakan di berbagai screen
  static ValueNotifier<int> saldoNotifier = ValueNotifier<int>(0);
}
