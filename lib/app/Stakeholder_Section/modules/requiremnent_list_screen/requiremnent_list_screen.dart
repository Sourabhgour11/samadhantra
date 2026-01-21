import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class RequirementsListScreen extends StatelessWidget {
  RequirementsListScreen({super.key});

  final RequirementsController controller = Get.put(RequirementsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
      onPressed: () => Get.toNamed(AppRoutes.postRequirementScreen),
      backgroundColor: AppColors.appColor,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Iconsax.add,
        color: Colors.white,
        size: 26,
      ),
    ),
      appBar: CustomAppBar(title: "Requirements",isBackButton: false,),

      body: Column(
        children: [
          // Filter Chips
          // _buildFilterChips(),
SizedBox(height: 10,),
          // Requirements List
          Expanded(
            child: _buildRequirementsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() => Row(
          children: controller.filters
              .map((filter) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              checkmarkColor: AppColors.white,
              label: Text(filter),
              selected: controller.selectedFilter.value == filter,
              onSelected: (_) => controller.selectedFilter.value = filter,
              backgroundColor: Colors.grey[200],
              selectedColor: AppColors.appColor,
              labelStyle: TextStyle(
                color: controller.selectedFilter.value == filter
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ))
              .toList(),
        )),
      ),
    );
  }

  Widget _buildRequirementsList() {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredRequirements.length,
      itemBuilder: (context, index) {
        final requirement = controller.filteredRequirements[index];
        return _buildRequirementItem(requirement);
      },
    ));
  }

  Widget _buildRequirementItem(RequirementModel requirement) {
    return GestureDetector(onTap: (){
      controller.viewRequirementDetail(requirement.id);
    },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: requirement.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.assignment,
              color: requirement.statusColor,
            ),
          ),
          title: Text(
            requirement.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                requirement.category,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: requirement.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: requirement.statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      requirement.statusText,
                      style: TextStyle(
                        fontSize: 10,
                        color: requirement.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.group, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${requirement.proposalsCount} proposals',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () => controller.viewRequirementDetail(requirement.id),
          ),
        ),
      ),
    );
  }
}