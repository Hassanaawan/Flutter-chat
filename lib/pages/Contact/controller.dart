import 'dart:convert';

import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/store/user.dart';

import 'package:chat/pages/Contact/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class ContactController extends GetxController {
  ContactController();
  final ContactState state = ContactState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;
  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData to_userData) async {
    var from_messages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_uid", isEqualTo: token)
        .where("to_uid", isEqualTo: to_userData.id)
        .get();
    var to_messages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_uid", isEqualTo: to_userData.id)
        .where("to_uid", isEqualTo: token)
        .get();

    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      String profile = await UserStore.to.getProfile();
      UserLoginResponseEntity userData =
          UserLoginResponseEntity.fromJson(jsonDecode(profile));
      var msgData = Msg(
          from_uid: userData.accessToken,
          to_uid: to_userData.id,
          from_name: userData.displayName,
          to_name: to_userData.name,
          from_avatar: userData.photoUrl,
          to_avatar: to_userData.photourl,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);
      db
          .collection("message")
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore(),
          )
          .add(msgData)
          .then(
        (value) {
          Get.toNamed(
            "/chat",
            parameters: {
              "doc_id": value.id,
              "to_uid": to_userData.id ?? "",
              "to_name": to_userData.name ?? "",
              "to_avatar": to_userData.photourl ?? "",
            },
          );
        },
      );
    } else {
      if (from_messages.docs.isNotEmpty) {
        Get.toNamed(
          "/chat",
          parameters: {
            "doc_id": from_messages.docs.first.id,
            "to_uid": to_userData.id ?? "",
            "to_name": to_userData.name ?? "",
            "to_avatar": to_userData.photourl ?? "",
          },
        );
      }
      if (to_messages.docs.isNotEmpty) {
        Get.toNamed(
          "/chat",
          parameters: {
            "doc_id": to_messages.docs.first.id,
            "to_uid": to_userData.id ?? "",
            "to_name": to_userData.name ?? "",
            "to_avatar": to_userData.photourl ?? "",
          },
        );
      }
    }
  }

  asyncLoadAllData() async {
    var userBase = await db
        .collection("users")
        .where("id", isNotEqualTo: token)
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, options) => userData.toFirestore(),
        )
        .get();
    for (var doc in userBase.docs) {
      state.contactList.add(doc.data());
      print(doc.toString());
    }
  }
}
