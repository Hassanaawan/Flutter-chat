import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/style/color.dart';
import 'package:chat/common/values/colors.dart';
import 'package:chat/common/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget HeadItem(UserLoginResponseEntity item) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
    margin: EdgeInsets.only(bottom: 30.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.w),
      boxShadow: [
        BoxShadow(
          color: AppColor.borderColor.withOpacity(0.2), // Added transparency
          offset: Offset(0, 3),
          blurRadius: 10.0,
          spreadRadius: 1.0,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(27.w), // Circular image
            child: netImageCached(
              item.photoUrl ??
                  "assets/images/default_avatar.png", // Default image
              height: 54.w,
              width: 54.w,
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.displayName ?? "Unknown User",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "ID: ${item.accessToken ?? "N/A"}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
