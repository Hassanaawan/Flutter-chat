import 'package:chat/common/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///  AppBar
AppBar transparentAppBar({
  Widget? title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFFF66666),
          Color(0xFFD20A0A), // Primary Color
          Color(0xFF720404),
          Color(0xFF520303), // Darkest shade
        ], transform: GradientRotation(90)),
      ),
    ),
    title: title != null ? Center(child: title) : null,
    leading: leading,
    actions: actions,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// 10像素 Divider
Widget divider10Px({Color bgColor = AppColors.primaryColor}) {
  return Container(
    height: 10.w,
    decoration: BoxDecoration(
      color: bgColor,
    ),
  );
}
