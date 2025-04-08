import 'package:chat/pages/Contact/controller.dart';
import 'package:chat/pages/Profile/controller.dart';
import 'package:chat/pages/message/messages/controller.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessagesController>(() => MessagesController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
