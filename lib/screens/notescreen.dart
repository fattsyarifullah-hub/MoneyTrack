import 'package:flutter/material.dart';
import 'package:moneytrack/notifier/notenotifier.dart';
import '/logic/noteLogic.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // untuk menyimpan data tipe input yang dipilih user
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
      return showDialog(
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
      return Colors.green;
    } else if (type == "spending") {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  // function untuk icon sesuai tipe input
  getIconNote(String? type) {
    if (type == "income") {
      return Icon(Icons.add, color: Colors.green);
    } else if (type == "spending") {
      return Icon(Icons.remove, color: Colors.red);
    } else {
      return Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  // function untuk menampilkan popup FAB
  void showPopupNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add Note",
          style: GoogleFonts.bebasNeue(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 4.0,
          ),
          textAlign: TextAlign.center,
        ),
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
                labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  letterSpacing: 2.5,
                ),
              ),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cost",
                labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  letterSpacing: 2.5,
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
                labelText: "Detail",
                labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  letterSpacing: 2.5,
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
            SizedBox(height: 10.0),
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
                      foregroundColor: WidgetStateProperty.all(
                        Color(0xFFD9D9D9),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        Color(0xFF100F1F),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(25.0),
                        ),
                      ),
                    ),
                    child: Container(child: Text("Income")),
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
                      foregroundColor: WidgetStateProperty.all(
                        Color(0xFFD9D9D9),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        Color(0xFFFF514F),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(25.0),
                        ),
                      ),
                    ),
                    child: Container(child: Text("Spending")),
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
            return Center(
              child: Text(
                "Belum ada notes",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // widget yang muncul ketika ada note
          return ListView.builder(
            // menampilkan data sesuai dengan banyaknya note yang ada di notenotifier
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              // mengambil data note untuk ditampilkan berdasarkan index dalam array
              final displayNote = allNotes[index];
              // mengambil tipe input untuk menentukan warna dan icon
              final String? type = displayNote['opsi'];
              // mengubah format string ke dalam bentuk data asli untuk ditampilkan
              final DateTime date = DateTime.parse(displayNote['date']);
              return Column(
                children: [
                  Container(
                    width: 300,
                    height: 115,
                    padding: EdgeInsetsGeometry.only(top: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border(
                        left: BorderSide(
                          color: getColorContainer(type),
                          width: 17.0,
                        ),
                      ),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 30.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}",
                                  style: GoogleFonts.montserrat(
                                    color: const Color.fromARGB(
                                      255,
                                      78,
                                      76,
                                      76,
                                    ),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  displayNote['detail'],
                                  style: GoogleFonts.bebasNeue(
                                    color: getColorTextNote(type),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Container(
                              child: Row(
                                children: [
                                  getIconNote(type),
                                  Text(
                                    NumberFormat.simpleCurrency(
                                      locale: 'id',
                                      decimalDigits: 0,
                                    ).format(displayNote['cost']),
                                    style: GoogleFonts.notoSansGeorgian(
                                      color: getColorTextNote(type),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
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
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
