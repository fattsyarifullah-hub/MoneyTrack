import 'package:flutter/material.dart';
import 'package:moneytrack/notifier/notenotifier.dart';
import '/logic/noteLogic.dart';
import 'package:intl/intl.dart';

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
      firstDate: DateTime(2026),
      lastDate: DateTime.now(),
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

    // ubah format string jadi int
    final int? cost = int.tryParse(costController.text);
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
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "cost",
                labelStyle: TextStyle(
                  fontFamily: "Denk One",
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            TextField(
              controller: detailController,
              decoration: InputDecoration(
                labelText: "detail",
                labelStyle: TextStyle(
                  fontFamily: "Denk One",
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RadioMenuButton<String>(
                    value: "income",
                    groupValue: selectedTypeNote,
                    onChanged: (selectedValue) {
                      setState(() {
                        selectedTypeNote = selectedValue!;
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Color(0xFFD9D9D9)),
                      backgroundColor: WidgetStateProperty.all(Color(0xFF100F1F)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(25.0)
                        )
                      )
                      ),
                    child: Container(child: Text("income")),
                  ),
                  RadioMenuButton<String>(
                    value: "spending",
                    groupValue: selectedTypeNote,
                    onChanged: (selectedValue) {
                      setState(() {
                        selectedTypeNote = selectedValue!;
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Color(0xFFD9D9D9)),
                      backgroundColor: WidgetStateProperty.all(Color(0xFFFF514F)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(25.0)
                        )
                      )
                    ),
                    child: Container(child: Text("spending")),
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
            child: Text("cancel"),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),

          // button untuk simpan note
          ElevatedButton(
            onPressed: () async {
              await addMoreNote();
              Navigator.pop(context);
            },
            child: Text("Add"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
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
        builder: (context, allNotes, _) {
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
                      children: <Widget>[
                        Text(
                          "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}",
                          style: TextStyle(color: getColorTextNote(type)),
                        ),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(displayNote['cost']),
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
