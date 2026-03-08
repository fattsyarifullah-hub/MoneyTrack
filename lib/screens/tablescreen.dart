import 'package:flutter/material.dart';
import '../notifier/notenotifier.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final cost = Notenotifier.noteNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        // mendengarkan perubahan data note yang disimpan di notenotifier
        valueListenable: Notenotifier.noteNotifier,

        // membangun tampilan berdasarkan data note yang ada
        builder: (BuildContext context, noteNotifier, Widget? child) {
          int saldo = 0;

          for (var note in noteNotifier) {
            int cost = note["cost"] as int;
            String type = note["opsi"];

            if (type == "income") {
              saldo += cost;
            } else if (type == "spending") {
              saldo -= cost;
            }
          }
          
          if (noteNotifier.isEmpty) {
            return Center(child: Text("Belum ada notes"));
          }

          // widget yang muncul ketika ada note
          return Column(
            children: [
              Text("Saldo: $saldo", style: TextStyle(color: Colors.white)),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          "date",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "cost",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "detail",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "type",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: noteNotifier.map((note) {
                      final date = DateTime.parse(note["date"]);
                      int cost = note["cost"] as int;
                      String detail = note["detail"];
                      String type = note['opsi'];
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(
                              cost.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            Text(detail, style: TextStyle(color: Colors.white)),
                          ),
                          DataCell(
                            Text(type, style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
