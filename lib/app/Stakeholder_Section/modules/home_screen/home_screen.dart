import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/bottom_nav_screen/bottom_nav_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_textstyle.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Dashboard",isBackButton: false,actions: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
            icon: const Icon(
              Iconsax.notification,
              size: 18,
              color: AppColors.white,
            ),
            splashRadius: 22,
          ),
        ),
SizedBox(width: 10,),
      ],),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Header
            // _buildHeader(context),

            const SizedBox(height: 20),

            // Stats Cards
            _buildStatsCards(),

            const SizedBox(height: 24),

            // Post New Requirement Button
            AppButton(title: "Post New Requirement",icon: Iconsax.add,onPressed: (){
              controller.navigateToPostRequirement();
            },),

            const SizedBox(height: 24),

            // Recent Requirements
            _buildRecentRequirements(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(
            title: 'Active Projects',
            value: controller.activeProjects.value.toString(),
            icon: Icons.rocket_launch,
            color: Colors.green,
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(
            title: 'Completed',
            value: controller.completedProjects.value.toString(),
            icon: Icons.check_circle,
            color: Colors.blue,
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(
            title: 'In Review',
            value: controller.inReviewProjects.value.toString(),
            icon: Icons.reviews,
            color: Colors.orange,
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostRequirementButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.navigateToPostRequirement,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          shadowColor: AppColors.appColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 22),
            const SizedBox(width: 10),
            Text(
              'Post New Requirement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRequirements() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Requirements',
                style: AppTextStyles.title.copyWith(fontSize: 16.sp),
                // style: TextStyle(
                //   fontSize: 18,
                //   fontWeight: FontWeight.bold,
                //   color: Colors.black,
                // ),
              ),
              TextButton(
                onPressed: () => Get.find<BottomNavController>().changeTab(1),
                child: Text(
                  'View All',
                  style: AppTextStyles.body.copyWith(color: AppColors.appColor,fontSize: 12.sp),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
            children: controller.recentRequirements
                .take(3)
                .map((requirement) => _buildRequirementCard(requirement))
                .toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildRequirementCard(RequirementModel requirement) {
    return GestureDetector(
      onTap: (){
        // Get.toNamed(AppRoutes.requirementDetails);
        Get.toNamed('/requirementDetails/${requirement.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE + STATUS
            Row(
              children: [
                Expanded(
                  child: Text(
                    requirement.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: requirement.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: requirement.statusColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    requirement.statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: requirement.statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 DESCRIPTION
            Text(
              requirement.description ?? "",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            /// 🔹 FOOTER INFO (NO OVERFLOW)
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_money,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      requirement.budget,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      '${requirement.proposalsCount} proposals',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () =>
                      controller.viewRequirementDetail(requirement.id),
                  style: TextButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.appColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}