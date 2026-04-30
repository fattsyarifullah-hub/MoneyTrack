import 'package:flutter/material.dart';
import '../notifier/targetnotifier.dart';
import '../model/targetModel.dart';
import '../notifier/saldonotifier.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  // poin poin yang diinput user
  final TextEditingController costTargetController = TextEditingController();
  final TextEditingController textTargetController = TextEditingController();
  DateTime? startDate;
  DateTime? finalDate;
  int selisihTanggal = 0;

  @override
  void initState() {
    super.initState();
    // Memuat data target dari SharedPreferences saat screen dibuka
    Targetnotifier.loadTarget();
  }

  // function untuk hitung jarak antara tanggal mulai dan tanggal selesai itu berapa hari
  void gapTimeFromDate() {
    if (startDate != null && finalDate != null) {
      // menghitung gap antara datetima startdate dan final date
      Duration gap = finalDate!.difference(startDate!);

      // buat state berdasarkan gap di dalam hari
      setState(() {
        selisihTanggal = gap.inDays;
      });
    }
  }

  // function untuk membuat perhitungan selisih tanggal menjadi dinamis
  dinamisGap() {
    // jika selisih tanggal lebih dari 30 maka lakukan ini
    if (selisihTanggal > 30) {
      // jika selisih tanggal lebih dari 365 maka lakukan ini
      if (selisihTanggal > 365) {
        // selisih tanggal dibagi 365 yaitu satu tahun dan dibulatkan ke bawah
        double tahun = (selisihTanggal / 365).floorToDouble();
        return " ${tahun.toInt()} Tahun";
      } else {
        // selisih tanggal dibagi 30 yaitu satu bulan dan dibulatkan ke bawah
        double bulan = (selisihTanggal / 30).floorToDouble();
        return " ${bulan.toInt()} Bulan";
      }
    } else {
      return "$selisihTanggal Hari";
    }
  }

  // function untuk menampilkan popup target
  void showPopupTarget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Target Tabungan",
          style: GoogleFonts.bebasNeue(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        content: Column(
          children: [
            // input untuk text target cost
            TextField(
              controller: costTargetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "target uang"),
            ),

            TextField(
              controller: textTargetController,
              decoration: InputDecoration(labelText: "Target Planning"),
            ),

            // button untuk setting date awal
            ElevatedButton(
              onPressed: () async {
                final pickStartDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2100),
                );

                // jika sudah memilih start date maka hitung gapnya
                if (pickStartDate != null) {
                  startDate = pickStartDate;
                  gapTimeFromDate();
                  dinamisGap();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 5.0,
              ),
              child: Text(
                "Pilih tanggal Mulai",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10.0),

            // button untuk setting date akhir
            ElevatedButton(
              onPressed: () async {
                final pickFinalDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2100),
                );
                if (pickFinalDate != null) {
                  // jika sudah memilih final date maka hitung gapnya
                  finalDate = pickFinalDate;
                  gapTimeFromDate();
                  dinamisGap();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 5.0,
              ),
              child: Text(
                "Pilih tanggal selesai",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        actions: [
          // button untuk cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 5.0,
            ),
            child: Text(
              'cancel',
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // button untuk menyimpan data target, data akan masuk ke model target dan disimpan di notifier target
          ElevatedButton(
            onPressed: () {
              if (costTargetController.text.isEmpty ||
                  textTargetController.text.isEmpty ||
                  startDate == null ||
                  finalDate == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("Please fill all fields"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              }
              // parsing dari controller text ke bentuk int
              int targetCost = int.parse(costTargetController.text);

              String targetText = textTargetController.text;

              // membuat model target, data target akan masuk dari sini
              TargetModel newTarget = TargetModel(
                startDate: startDate!,
                finalDate: finalDate!,
                targetCost: targetCost,
                targetText: targetText,
              );

              // masukin ke notifier kalau valuenya adalah yang sama dengan model target
              Targetnotifier.targetNotifier.value = newTarget;

              // Simpan data target ke SharedPreferences
              Targetnotifier.saveTarget(newTarget);

              Navigator.pop(context);
            },
            child: Text(
              "simpan",
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // format untuk menampilkan data cost yang berantakan menjadi auto rupiah
    final formatRupiah = NumberFormat.simpleCurrency(
      locale: 'id',
      decimalDigits: 0,
    );

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<TargetModel?>(
            // value target
            valueListenable: Targetnotifier.targetNotifier,
            builder: (BuildContext context, target, child) {
              if (target == null) {
                return Center(
                  child: Text(
                    "Belum ada Target",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ValueListenableBuilder(
                // data saldo
                valueListenable: Saldonotifier.saldoNotifier,
                builder: (BuildContext context, saldo, child) {
                  // variabel progress saldo dibagi dengan target cost
                  double progress = saldo / target.targetCost;

                  if (progress > 1) {
                    progress = 1;
                  }

                  return Container(
                    width: 350.0,
                    height: 225.0,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 227, 63, 164),
                          Color.fromARGB(255, 219, 41, 104),
                          Color.fromARGB(255, 165, 14, 67),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      child: Column(
                        children: [
                          // icon untuk menghapus data target
                          IconButton(
                            onPressed: () {
                              // akan memanggil function delete target untuk menghapus data target
                              Targetnotifier.deleteTarget();
                              // untuk pengecekan navigasi setelah data target dihapus, jika masih bisa pop maka akan pop, jika tidak maka tidak akan melakukan apa apa
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.white),
                          ),
                          Text(
                            target.targetText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Target: ${formatRupiah.format(target.targetCost)}",
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Uang yang sudah terkumpul: ${formatRupiah.format(saldo)}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 25.0),
                          SizedBox(
                            height: 20.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Color(0xFF100F1F),
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            // menampilkan gap dengan mode dinamis yaitu berapa tahun/bulan/hari
                            "${dinamisGap()}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showPopupTarget,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
