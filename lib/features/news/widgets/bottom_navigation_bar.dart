import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: navBarColor,
        border: Border(top: BorderSide(color: hintTextColor.withOpacity(0.1), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: redAccent,
        unselectedItemColor: hintTextColor,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 10, color: redAccent),
        unselectedLabelStyle: TextStyle(fontSize: 10, color: hintTextColor),

        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(LucideIcons.newspaper, size: 24), label: 'Anasayfa'),
          const BottomNavigationBarItem(icon: Icon(LucideIcons.compass, size: 24), label: 'e-gündem'),
          BottomNavigationBarItem(
            label: '',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: redAccent),
              child: const Icon(Icons.alarm, color: Colors.white, size: 28),
            ),
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.bookmark_border, size: 24), label: 'Kaydedilenler'),
          const BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined, size: 24), label: 'Yerel'),
        ],
      ),
    );
  }
}
