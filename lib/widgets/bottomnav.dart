import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: "Notes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          label: "Table",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: "Target",
        ),
      ],
    );
  }
}