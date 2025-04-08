import 'package:get/get.dart';
import 'controller.dart';

class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}

// import 'package:get/get.dart';

// import 'controller.dart';

// class ChatBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ChatController>(() => ChatController());
//   }
// }
