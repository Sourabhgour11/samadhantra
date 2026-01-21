import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<BottomNavItem> navItems = [
    BottomNavItem(
      label: 'Home',
      icon: Iconsax.home,
      activeIcon: Iconsax.home,
    ),
    BottomNavItem(
      label: 'Requirements',
      icon: Iconsax.document_text,
      activeIcon: Iconsax.document_text,
    ),
    BottomNavItem(
      label: 'Assignments',
      icon: Iconsax.book,
      activeIcon: Iconsax.book_1,
    ),
    BottomNavItem(
      label: 'Messages',
      icon: Iconsax.message,
      activeIcon: Iconsax.message,
    ),
    BottomNavItem(
      label: 'Profile',
      icon: Iconsax.user,
      activeIcon: Iconsax.user,
    ),

  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}


class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
