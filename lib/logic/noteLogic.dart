import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class noteLogic {
  static const String keyNotes = "notes";

  // function untuk mengambil semua note yang ada
  static Future<List<Map<String, dynamic>>> loadNote() async {
    final prefs = await SharedPreferences.getInstance();

    // ambil nilai dari prefs
    String? jsonData = prefs.getString(keyNotes);

    if (jsonData == null) return [];

    // ubah ke format json
    List decoded = jsonDecode(jsonData);

    // await prefs.remove(keyNotes);

    // mengirim dalam format map
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // function untuk menambah data
  static Future<void> addnote(Map<String, dynamic> note) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> newNotes = await loadNote();

    // tambah data baru ke loadnote
    newNotes.add(note);

    // ubah json ke dalam format map
    String jsonData = jsonEncode(newNotes);

    // set untuk keynotes dan jsondata
    await prefs.setString(keyNotes, jsonData);
  }
}
