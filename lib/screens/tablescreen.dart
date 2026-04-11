import 'package:flutter/material.dart';
import '../notifier/notenotifier.dart';
import '../notifier/saldonotifier.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
            return Center(
              child: Text(
                "Belum ada notes",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // widget yang muncul ketika ada note
          return Center(
            child: Column(
              children: [
                Container(
                  width: 450.0,
                  height: 180.0,
                  padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        Color.fromARGB(255, 190, 39, 132),
                        Color.fromARGB(255, 219, 41, 104),
                        Color.fromARGB(255, 186, 21, 79),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${formatRupiah.format(saldo)}",
                              style: GoogleFonts.notoSansGeorgian(
                                color: Colors.white,
                                fontSize: 50.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Income",
                                    style: GoogleFonts.notoSansGeorgian(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${formatRupiah.format(totalIncome)}",
                                    style: GoogleFonts.notoSansGeorgian(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Spending",
                                    style: GoogleFonts.notoSansGeorgian(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${formatRupiah.format(totalSpending)}",
                                    style: GoogleFonts.notoSansGeorgian(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // table note
                Expanded(
                  child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            "DATE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "COST",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "DETAIL",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "TYPE",
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                NumberFormat.simpleCurrency(
                                  locale: 'id',
                                  decimalDigits: 0,
                                ).format(cost),
                                style: GoogleFonts.notoSansGeorgian(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                detail,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                type,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),)
              ],
            ),
          );
        },
      ),
    );
  }
}
