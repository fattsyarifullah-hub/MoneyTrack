import 'package:flutter/material.dart';
import '../notifier/targetnotifier.dart';
import '../model/targetModel.dart';
import '../notifier/saldonotifier.dart';
import 'package:intl/intl.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  // poin poin yang diinput user
  final TextEditingController costTargetController = TextEditingController();
  DateTime? startDate;
  DateTime? finalDate;

  @override
  void initState() {
    super.initState();
    // Memuat data target dari SharedPreferences saat screen dibuka
    Targetnotifier.loadTarget();
  }

  // function untuk menampilkan popup target
  void showPopupTarget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Target Tabungan"),
        content: Column(
          children: [
            // input untuk text target cost
            TextField(
              controller: costTargetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "target uang"),
            ),

            // button untuk setting date awal
            ElevatedButton(
              onPressed: () async {
                startDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2100),
                );
              },
              child: Text("Pilih tanggal Mulai"),
            ),
            SizedBox(height: 10.0),

            // button untuk setting date akhir
            ElevatedButton(
              onPressed: () async {
                finalDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2100),
                );
              },
              child: Text("Pilih tanggal selesai"),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // parsing dari controller text ke bentuk int
              int targetCost = int.parse(costTargetController.text);

              // membuat model target, data target akan masuk dari sini
              TargetModel newTarget = TargetModel(
                startDate: startDate!,
                finalDate: finalDate!,
                targetCost: targetCost,
              );

              // masukin ke notifier kalau valuenya adalah yang sama dengan model target
              Targetnotifier.targetNotifier.value = newTarget;

              // Simpan data target ke SharedPreferences
              Targetnotifier.saveTarget(newTarget);

              Navigator.pop(context);
            },
            child: Text("simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatRupiah = NumberFormat.simpleCurrency(
      locale: 'id',
      decimalDigits: 0,
    );

    return Scaffold(
      body: ValueListenableBuilder<TargetModel?>(
        // value target
        valueListenable: Targetnotifier.targetNotifier,
        builder: (BuildContext context, target, child) {
          if (target == null) {
            return Text("Belum ada Target");
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
                width: 250.0,
                height: 250.0,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: Colors.red),

                child: Column(
                  children: [
                    Text("Target: ${formatRupiah.format(target.targetCost)}"),
                    SizedBox(height: 10.0),
                    Text(
                      "Uang yang sudah terkumpul: ${formatRupiah.format(saldo)}",
                    ),
                    SizedBox(height: 25.0),
                    SizedBox(
                      height: 20.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation(Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPopupTarget,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
