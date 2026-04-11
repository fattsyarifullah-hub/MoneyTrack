import 'package:flutter/material.dart';
import 'screens/notescreen.dart';
import 'screens/tablescreen.dart';
import 'screens/targetscreen.dart';
import 'widgets/bottomnav.dart';
import 'notifier/targetnotifier.dart';
import 'logic/noteLogic.dart';

void main() async {
  // persiapan hardware untuk akses data sharedpreferences
  WidgetsFlutterBinding.ensureInitialized();
  // Memuat data target dari SharedPreferences
  await noteLogic.loadNote();
  await Targetnotifier.loadTarget();
  runApp(
    // gunakan device preview untuk testing di berbagai device
    const TrackMoney()
  );
}

class TrackMoney extends StatelessWidget {
  const TrackMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyTrack',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF100F1F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF100F1F),
          primary: Color(0xFF100F1F),
          secondary: Color(0xFFD9D9D9),
          tertiary: Color(0xFFFF514F),
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: "Dangrek",
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9D9D9),
          ),
          titleMedium: TextStyle(
            fontFamily: "Denk One",
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          labelMedium: TextStyle(fontFamily: "Dangrek", fontSize: 15.0),
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontFamily: "Denk One",
            color: Color(0xFF100F1F),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF100F1F), width: 5.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF514F), width: 3.0),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD9D9D9),
          foregroundColor: Color(0xFF100F1F),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFD9D9D9),
          selectedIconTheme: IconThemeData(color: Colors.black, size: 24.0),
          unselectedIconTheme: IconThemeData(
            color: Color(0xFF100F1F),
            size: 30.0,
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // index default
  int _currentIndex = 0;

  // urutan index
  final List<Widget> _pages = [NotePage(), TablePage(), TargetPage()];

  // function tap
  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MoneyTrack',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
