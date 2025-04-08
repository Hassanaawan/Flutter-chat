import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/utils/Colors.dart';

import 'package:chat/pages/Contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.contactList.isEmpty) {
        return Center(child: Text("No contacts available"));
      }
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = controller.state.contactList[index];
                  return BuildListItem(item);
                },
                childCount: controller.state.contactList.length,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget BuildListItem(UserData item) {
    return Container(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          if (item.id != null) {
            controller.goChat(item);
          }
        },
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 15.w),
              child: SizedBox(
                width: 54.w,
                height: 54.w,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    "${item.photourl}",
                  ),
                ),
              ),
            ),
            Container(
              width: 250.w,
              padding: EdgeInsets.only(top: 15.w, left: 0.w, right: 0.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 42.w,
                    child: Text(
                      item.name ?? "",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
