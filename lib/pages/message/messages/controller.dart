import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/store/store.dart';
import 'package:chat/pages/message/messages/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessagesController extends GetxController {
  final MessagesState state = MessagesState();
  MessagesController();

  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  void onRefresh() {
    asyncLoadAllData().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  Future<void> asyncLoadAllData() async {
    try {
      var fromMessages = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .where("from_uid", isEqualTo: token)
          .get();

      var toMessages = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .where("to_uid", isEqualTo: token)
          .get();

      state.msgList.clear();
      state.msgList.addAll(fromMessages.docs);
      state.msgList.addAll(toMessages.docs);
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  // getUserLocation() async {
  //   try {
  //     final location = await Location().getLocation();
  //     String address = "${location.latitude},${location.longitude}";
  //     String url =
  //         "https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c";
  //   } catch (e) {
  //     print("Error loading messages: $e");
  //   }
  // }
}
