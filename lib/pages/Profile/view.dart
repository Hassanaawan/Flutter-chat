import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/widgets/app.dart';
import 'package:chat/pages/Profile/controller.dart';
import 'package:chat/pages/Profile/widgets/headItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text(
        "Profile",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
        ),
      ),
    );
  }

  Widget MeItem(MeListItem item) {
    return Container(
      height: 50.h,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 1.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: InkWell(
        onTap: () {
          if (item.route == "/logout") {
            controller.onLogout();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              item.icon ?? "assets/icons/default_icon.png", // Default icon
              width: 40.w,
              height: 40.w,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.name ?? "Unnamed",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Image.asset(
              "assets/icons/ang.png",
              height: 15.w,
              width: 15.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: controller.state.head_detail.value != null
                  ? HeadItem(controller.state.head_detail.value!)
                  : SizedBox.shrink(), // Hide if null
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = controller.state.meListItem[index];
                  return MeItem(item);
                },
                childCount: controller.state.meListItem.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
