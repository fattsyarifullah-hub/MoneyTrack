import 'package:flutter/material.dart';
import '/logic/baseNotifier.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: baseNotifier,
        builder:
            (BuildContext context, List<Map<String, dynamic>> allNotifier, _) {
              if (allNotifier.isEmpty) {
                return Center(child: Text("Belum ada data"));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Type")),
                      DataColumn(label: Text("Inflow")),
                      DataColumn(label: Text("Outflow")),
                    ],
                    rows: allNotifier.map((listTable) {
                      return DataRow(
                        cells: [
                          DataCell(Text(listTable['date'])),
                          DataCell(Text(listTable['cost'])),
                          DataCell(Text(listTable['detail'])),
                          DataCell(Text(listTable['type']))
                        ] 
                      );
                    }).toList(),
                  ),
                ),
              );
            },
      ),
    );
  }
}
