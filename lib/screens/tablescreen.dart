import 'package:flutter/material.dart';
import '../notifier/notenotifier.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: Notenotifier.noteNotifier,
        builder: (BuildContext context, noteNotifier, Widget? child) {
          if (noteNotifier.isEmpty) {
            return Center(child: Text("Belum ada notes"));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("date", style: TextStyle(color: Colors.white),),),
                  DataColumn(label: Text("cost", style: TextStyle(color: Colors.white),),),
                  DataColumn(label: Text("detail", style: TextStyle(color: Colors.white),),),
                  DataColumn(label: Text("tipe", style: TextStyle(color: Colors.white),),),
                ], 
                rows: noteNotifier.map((note) {
                  final date = DateTime.parse(note["date"]);
                  return DataRow(cells: [
                    DataCell(Text("${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}", style: TextStyle(color: Colors.white),)),
                    DataCell(Text(note["cost"].toString(), style: TextStyle(color: Colors.white),)),
                    DataCell(Text(note["detail"], style: TextStyle(color: Colors.white),)),
                    DataCell(Text(note["opsi"], style: TextStyle(color: Colors.white),)),
                  ]);
                }
                ).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
