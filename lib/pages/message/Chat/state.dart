import 'package:chat/common/entities/entities.dart';
import 'package:get/get.dart';

class ChatState {
  RxList<Msgcontent> Msgcontentlist = <Msgcontent>[].obs;
  RxString to_uid = "".obs;
  RxString to_name = "".obs;
  RxString to_avatar = "".obs;
}
// import 'package:chat/common/entities/entities.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/get_rx.dart';

// class ChatState {
//   RxList<Msgcontent> Msgcontentlist = <Msgcontent>[].obs;
//   RxString to_uid = "".obs;
//   var to_name = "".obs;
//   var to_avatar = "".obs;
//   var to_location = "unknown".obs;
// }
