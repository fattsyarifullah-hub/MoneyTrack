import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/targetModel.dart';

class Targetnotifier {
  // notifier untuk menyimpan data target yang bisa digunakan di berbagai screen
  static ValueNotifier<TargetModel?> targetNotifier = ValueNotifier(null);

  // Kunci lemari sharedpreferences
  static const String _targetKey = 'target_data';

  // Menyimpan data target ke SharedPreferences
  static Future<void> saveTarget(TargetModel target) async {
    final prefs = await SharedPreferences.getInstance();
    // ambil kunci, lalu masukkan data dari bentuk teks JSON
    await prefs.setString(_targetKey, target.toJsonString());
  }

  // Memuat data target dari SharedPreferences
  static Future<void> loadTarget() async {
    final prefs = await SharedPreferences.getInstance();
    // ambil kunci untuk ngeliat data yang ada
    final targetJson = prefs.getString(_targetKey);
    
    // jika data ada, maka ambil function di model dari JSON ke dalam bentuk data asli untuk ditampilkan
    if (targetJson != null) {
      targetNotifier.value = TargetModel.fromJsonString(targetJson);
    }
  }

  // Menghapus data target dari SharedPreferences
  static Future<void> deleteTarget() async {
    final prefs = await SharedPreferences.getInstance();
    // untuk delete data target
    await prefs.remove(_targetKey);
    // data berubah jadi null
    targetNotifier.value = null;
  }
}
