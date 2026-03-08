import 'package:flutter/material.dart';
import '../notifier/targetnotifier.dart';
import '../model/targetModel.dart';
import '../notifier/saldonotifier.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  final TextEditingController costTargetController = TextEditingController();
  DateTime? startDate;
  DateTime? finalDate;

  void showPopupTarget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Target Tabungan"),
        content: Column(
          children: [
            TextField(
              controller: costTargetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "target uang"
              ),
            ),
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
          ElevatedButton(
            onPressed: () {
              int targetCost = int.parse(costTargetController.text);

              Targetnotifier.targetNotifier.value = TargetModel(
                startDate: startDate!,
                finalDate: finalDate!,
                targetCost: targetCost,
              );

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
    return Scaffold(
      body: ValueListenableBuilder<TargetModel?>(
        valueListenable: Targetnotifier.targetNotifier,
        builder: (BuildContext context, target, child) {
          if (target == null) {
            return Text("Belum ada Target");
          }

          return ValueListenableBuilder(
            valueListenable: Saldonotifier.saldoNotifier,
            builder: (BuildContext context, saldo, child) {
              double progress = saldo / target.targetCost;

              if (progress > 1) {
                progress = 1;
              }

              return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: Colors.red),

                child: Column(
                  children: [
                    Text("Target: ${target.targetCost}"),
                    SizedBox(height: 10.0),
                    Text("Uang yang sudah terkumpul: $saldo"),
                    SizedBox(height: 25.0),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation(Colors.green),
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
