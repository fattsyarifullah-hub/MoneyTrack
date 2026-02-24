import 'package:flutter/material.dart';
import 'package:moneytrack/notifier/notenotifier.dart';
import '/logic/noteLogic.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // untuk controller input
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  final TextEditingController costController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  String selectedTypeNote = "";

  @override
  void initState() {
    super.initState();
    noteLogic.loadNote();
  }

  // function untuk menampilkan datepicker
  Future<void> datePick(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;
      dateController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year.toString().padLeft(4, '0')}";
    }
  }

  // function untuk menambah suatu data
  Future<void> addMoreNote() async {
    if (selectedDate == null ||
        costController.text.isEmpty ||
        detailController.text.isEmpty ||
        selectedTypeNote.isEmpty)
      return;

    // ubah format string jadi double
    final double? cost = double.tryParse(costController.text);
    if (cost == null) return;

    // bentuk note dalam map
    Map<String, dynamic> note = {
      "date": selectedDate!.toIso8601String(),
      "cost": cost,
      "detail": detailController.text,
      "opsi": selectedTypeNote,
    };

    // tambah note ke sharedpreferences dan update noteNotifier
    await noteLogic.addnote(note);

    setState(() {
      selectedTypeNote = "";
    });

    dateController.clear();
    costController.clear();
    detailController.clear();
  }

  // function warna container berdasarkan tipe input
  getColorContainer(String? type) {
    if (type == "income") {
      return Colors.green;
    } else if (type == "spending") {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  // function warna text berdasarkan tipe input
  getColorTextNote(String? type) {
    if (type == "income") {
      return Colors.white;
    } else if (type == "spending") {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  // function untuk menampilkan popup FAB
  void showPopupNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () => datePick(context),
              decoration: InputDecoration(
                labelText: "date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "cost"),
            ),
            TextField(
              controller: detailController,
              decoration: InputDecoration(labelText: "detail"),
            ),
            Container(
              child: Row(
                children: [
                  RadioMenuButton(
                    value: "income",
                    groupValue: selectedTypeNote,
                    onChanged: (selectedValue) {
                      setState(() {
                        selectedTypeNote = selectedValue!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Text("income"),
                    ),
                  ),
                  RadioMenuButton(
                    value: "spending",
                    groupValue: selectedTypeNote,
                    onChanged: (selectedValue) {
                      setState(() {
                        selectedTypeNote = selectedValue!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text("spending"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [

          // button batal menambah note
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),

          // button untuk simpan note
          ElevatedButton(
            onPressed: () async {
              await addMoreNote();
              Navigator.pop(context);
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    costController.dispose();
    detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(

        // mendengarkan perubahan data note yang disimpan di notenotifier
        valueListenable: Notenotifier.noteNotifier,

        // membangun tampilan berdasarkan data note yang ada
        builder:
            (
              context,
              allNotes,
              _,
            ) {
              if (allNotes.isEmpty) {
                return Center(child: Text("Belum ada notes"));
              }

              // widget yang muncul ketika ada note
              return ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  final displayNote = allNotes[index];
                  final String? type = displayNote['opsi'];
                  final DateTime date = DateTime.parse(displayNote['date']);
                  return Column(
                    children: [
                      Container(
                        width: 350,
                        height: 125,
                        padding: EdgeInsetsGeometry.only(top: 25.0),
                        decoration: BoxDecoration(
                          color: getColorContainer(type),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}",
                              style: TextStyle(color: getColorTextNote(type)),
                            ),
                            Text(
                              displayNote['cost'].toString(),
                              style: TextStyle(color: getColorTextNote(type)),
                            ),
                            Text(
                              displayNote['detail'],
                              style: TextStyle(color: getColorTextNote(type)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                  ],
                );
              },
            );
          },
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: showPopupNote,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
