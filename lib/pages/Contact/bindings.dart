import 'package:get/get.dart';

import 'controller.dart';

class ContactBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
