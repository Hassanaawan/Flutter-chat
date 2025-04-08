import 'package:chat/common/utils/Colors.dart';
import 'package:chat/pages/Application/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late final List<String> tabTiles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handlePageChanged(int index) {
    state.page = index;
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();

    tabTiles = ["Chat", "Contact", "Profile"];

    // ✅ Initialize once
    pageController = PageController(initialPage: state.page);

    bottomTabs = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.chat, color: Colors.blueGrey),
        label: "Chat",
        activeIcon: const Icon(Icons.message, color: AppColors.primaryColor),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.contact_page, color: Colors.blueGrey),
        label: "Contact",
        activeIcon:
            const Icon(Icons.contact_page, color: AppColors.primaryColor),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person, color: Colors.blueGrey),
        label: "Profile",
        activeIcon: const Icon(Icons.person, color: AppColors.primaryColor),
      ),
    ];
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
