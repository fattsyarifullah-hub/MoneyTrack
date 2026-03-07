import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../notifier/notenotifier.dart';

class noteLogic {
  static const String keyNotes = "notes";

  // function untuk mengambil semua note yang ada
  static Future<void> loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(keyNotes);

    // jika jsondata kosong maka kembalikan list kosong
    if (jsonData == null) {
      Notenotifier.noteNotifier.value = [];
      return;
    }

    // ubah ke format json
    final List decoded = jsonDecode(jsonData);

    // await prefs.remove(keyNotes);

    // mengirim dalam format map
    Notenotifier.noteNotifier.value = decoded
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // function untuk menambah data
  static Future<void> addnote(Map<String, dynamic> note) async {
    final prefs = await SharedPreferences.getInstance();

    // ambil data note, tambah data, dan simpan ke sharedpreferences
    final currentNotes = [...Notenotifier.noteNotifier.value];
    currentNotes.add(note);
    
    // simpan data ke sharedpreferences dan update noteNotifier
    await prefs.setString(keyNotes, jsonEncode(currentNotes));

    // update noteNotifier dengan data terbaru
    Notenotifier.noteNotifier.value = currentNotes;
  }
}
