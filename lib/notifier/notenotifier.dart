import 'package:flutter/material.dart';

class Notenotifier {
  // notifier untuk menyimpan data note yang bisa digunakan di berbagai screen
  static ValueNotifier<List<Map<String, dynamic>>> noteNotifier = 
  ValueNotifier<List<Map<String, dynamic>>>([]);
}