import 'package:chat/common/utils/Colors.dart';

import 'package:chat/pages/Contact/view.dart';
import 'package:chat/pages/Profile/view.dart';
import 'package:chat/pages/message/messages/view.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildPageView() {
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handlePageChanged,
        children: [
          MessagePage(),
          ContactPage(),
          ProfilePage(),
        ],
      );
    }

    Widget _buildBottomNavigationBar() {
      return Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.state.page,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.blueGrey,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          onTap: controller.handlePageChanged,
          items: controller.bottomTabs,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
