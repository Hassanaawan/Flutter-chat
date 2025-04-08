import 'package:chat/common/entities/entities.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProfileState {
  var head_detail = Rx<UserLoginResponseEntity?>(null);
  RxList<MeListItem> meListItem = <MeListItem>[].obs;
}
