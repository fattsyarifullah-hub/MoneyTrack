import 'package:flutter/material.dart';
import '/logic/noteLogic.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // untuk controller input
  late TextEditingController dateController;
  late TextEditingController costController;
  late TextEditingController detailController;

  // list allNotes yang sudah diinput
  List<Map<String, dynamic>> allNotes = [];

  String selectedTypeNote = "";

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    costController = TextEditingController();
    detailController = TextEditingController();
    loadAllNote();
  }

  // function untuk menampilkan data yang ada
  Future<void> loadAllNote() async {
    allNotes = await noteLogic.loadNote();
    setState(() {});
  }

  // function untuk menambah suatu data
  Future<void> addMoreNote() async {
    if (dateController.text.isEmpty ||
        costController.text.isEmpty ||
        detailController.text.isEmpty)
      return;

    // ubah format string jadi double
    double cost = double.parse(costController.text);

    // bentuk note dalam map
    Map<String, dynamic> note = {
      "date": dateController.text,
      "cost": cost,
      "detail": detailController.text,
      "opsi": selectedTypeNote,
    };

    await noteLogic.addnote(note);

    selectedTypeNote = "";

    dateController.clear();
    costController.clear();
    detailController.clear();
  }

  // function warna container berdasarkan tipe input
  getColorContainer(String? type) {
    if (type == "income") {
      return Colors.white;
    } else if (type == "spending") {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  getColorTextNote(String? type) {
    if (type == "income") {
      return Colors.red;
    } else if (type == "spending") {
      return Colors.white;
    } else {
      return Colors.green;
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
              decoration: InputDecoration(labelText: "date", suffixIcon: Icon(Icons.calendar_today)),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await addMoreNote();
              Navigator.pop(context);
              await loadAllNote();
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
      body: ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (context, index) {
          final displayNote = allNotes[index];
          final String? type = displayNote['opsi'];
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
                      displayNote['date'],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPopupNote,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
