import 'dart:convert';

// model untuk target
class TargetModel {
  final DateTime startDate;
  final DateTime finalDate;
  final int targetCost;
  final String targetText;

  TargetModel({
    required this.startDate,
    required this.finalDate,
    required this.targetCost,
    required this.targetText,
  });

  // Convert ke dalam bentuk teks
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'finalDate': finalDate.toIso8601String(),
      'targetCost': targetCost,
      'targetText': targetText,
    };
  }

  // === MODEL UNTUK CONVERT DARI JSON KE TARGETMODEL ===
  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      startDate: DateTime.parse(json['startDate']),
      finalDate: DateTime.parse(json['finalDate']),
      targetCost: json['targetCost'],
      targetText: json['targetText']
    );
  }

  // JSON encode memasukkan data asli ke dalam bentuk JSON yang rapi
  String toJsonString() => jsonEncode(toJson());

  // === MODEL UNTUK CONVERT DARI JSON STRING KE TARGETMODEL ===
  factory TargetModel.fromJsonString(String jsonString) {
    return TargetModel.fromJson(jsonDecode(jsonString));
  }
}
