  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/assignment_screen/assignment_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/home_screen/home_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/message_screen/message_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'bottom_nav_screen_controller.dart';


class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          HomeScreen(),
          RequirementsListScreen(),
          AssignmentsScreen(),
          MessagesScreen(),
          ProfileScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => _buildBottomNavBar()),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: controller.navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = controller.currentIndex.value == index;

              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.appColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color:
                        isActive ? AppColors.appColor : Colors.grey[600],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                          color:
                          isActive ? AppColors.appColor : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}