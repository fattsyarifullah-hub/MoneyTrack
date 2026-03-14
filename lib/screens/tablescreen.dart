import 'package:flutter/material.dart';
import '../notifier/notenotifier.dart';
import '../notifier/saldonotifier.dart';
import 'package:intl/intl.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final cost = Notenotifier.noteNotifier;

  @override
  Widget build(BuildContext context) {
    final formatRupiah = NumberFormat.simpleCurrency(
      locale: 'id',
      decimalDigits: 0,
    );

    return Scaffold(
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        // mendengarkan perubahan data note yang disimpan di notenotifier
        valueListenable: Notenotifier.noteNotifier,

        // membangun tampilan berdasarkan data note yang ada
        builder: (BuildContext context, noteNotifier, Widget? child) {
          int saldo = 0;
          int totalIncome = 0;
          int totalSpending = 0;

          // looping perhitungan saldo apabila sesuai dengan datanya
          for (var note in noteNotifier) {
            int cost = note["cost"] as int;
            String type = note["opsi"];

            // type nya income maka saldo akan bertambah
            if (type == "income") {
              saldo += cost;
              totalIncome += cost;
              // type nya spending maka saldo akan berkurang
            } else if (type == "spending") {
              saldo -= cost;
              totalSpending += cost;
            }
          }

          Saldonotifier.saldoNotifier.value = saldo;

          if (noteNotifier.isEmpty) {
            return Center(child: Text("Belum ada notes"));
          }

          // widget yang muncul ketika ada note
          return Center(
            child: Column(
              children: [
                Container(
                  width: 450.0,
                  height: 180.0,
                  padding: EdgeInsets.fromLTRB(45.0, 25.0, 45.0, 25.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 21, 171, 73),
                        Color.fromARGB(255, 17, 194, 82),
                        Color.fromARGB(255, 54, 171, 95),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              "${formatRupiah.format(saldo)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Income ${formatRupiah.format(totalIncome)}",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Spending ${formatRupiah.format(totalSpending)}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // widget saldo
                SizedBox(height: 10.0),
                // table note
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
                      // row data table
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
                                NumberFormat.simpleCurrency(
                                  locale: 'id',
                                  decimalDigits: 0,
                                ).format(cost),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataCell(
                              Text(
                                detail,
                                style: TextStyle(color: Colors.white),
                              ),
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
            ),
          );
        },
      ),
    );
  }
}
