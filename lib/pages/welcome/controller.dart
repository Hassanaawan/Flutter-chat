import 'package:chat/common/routes/routes.dart';
import 'package:chat/common/store/config.dart';
import 'package:chat/pages/welcome/state.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final state = WelcomeState();
  WelcomeController();
  //change page index and refreh to state
  changePage(int index) async {
    state.index.value = index;
    update();
  }

  // handle login page change
  handlesSignin() async {
    await ConfigStore.to.saveAlreadyOpen();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
