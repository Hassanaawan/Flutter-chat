import 'dart:async';
import 'dart:convert'; // ✅ Added for JSON decoding
import 'dart:io';
import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/store/store.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'state.dart';

class ChatController extends GetxController {
  ChatController();
  ChatState state = ChatState();

  var isUserScrollingUp = false.obs;

  var doc_id = "";
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot> listener;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  /// 📌 Pick image from gallery
  Future<void> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      await uploadFile(_photo!);
    }
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  /// 📌 Pick image from camera
  Future<void> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      await uploadFile(_photo!);
    }
  }

  /// 📌 Upload file to Cloudinary
  Future<void> uploadFile(File imageFile) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/dqympsubl/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] =
          "chat_images" // ✅ Make sure this matches your Cloudinary preset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        String imgUrl = jsonResponse['secure_url'];
        print("✅ Image uploaded successfully: $imgUrl");
        await sendImageMessage(imgUrl);
      } else {
        print("❌ Upload failed: ${jsonResponse['error']['message']}");
      }
    } catch (e) {
      print("❌ Error uploading file: $e");
    }
  }

  /// 📌 Send image message to Firestore
  Future<void> sendImageMessage(String imageUrl) async {
    final content = Msgcontent(
      uid: user_id,
      content: imageUrl,
      type: 'image',
      addtime: Timestamp.now(),
    );

    await db
        .collection("chats")
        .doc(doc_id)
        .collection("msgList")
        .add(content.toFirestore())
        .then((doc) {
      print("✅ Image message sent with ID: ${doc.id}");
      textController.clear();
      Get.focusScope?.unfocus();
      scrollToBottom();
    });

    await db.collection("message").doc(doc_id).update({
      "last_msg": "[image]",
      "lastTime": Timestamp.now(),
    });
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data["doc_id"] ?? "";
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";

    listenToMessages();
  }

  /// 📌 Listen to messages in Firestore
  void listenToMessages() {
    var messages = db
        .collection("chats")
        .doc(doc_id)
        .collection("msgList")
        .orderBy("addtime", descending: true)
        .withConverter<Msgcontent>(
          fromFirestore: (snapshot, options) =>
              Msgcontent.fromFirestore(snapshot, options),
          toFirestore: (Msgcontent msgContent, options) =>
              msgContent.toFirestore(),
        );

    state.Msgcontentlist.clear();

    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final msg = change.doc.data();
          if (msg != null) {
            state.Msgcontentlist.insert(0, msg);
          }
        }
      }
      state.Msgcontentlist.refresh();
      scrollToBottom();
    }, onError: (error) {
      print("❌ Firestore listen failed: $error");
    });
  }

  /// 📌 Send text message
  Future<void> sendMessage() async {
    if (textController.text.isEmpty) return;

    String sendContent = textController.text;
    final content = Msgcontent(
      uid: user_id,
      content: sendContent,
      type: 'text',
      addtime: Timestamp.now(),
    );

    await db
        .collection("chats")
        .doc(doc_id)
        .collection("msgList")
        .add(content.toFirestore())
        .then((doc) {
      print("✅ Message sent with ID: ${doc.id}");
      textController.clear();
      Get.focusScope?.unfocus();

      /// ✅ Ensure scrolling happens **after UI updates**
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (msgScrolling.hasClients) {
          msgScrolling.animateTo(
            msgScrolling.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    await db.collection("message").doc(doc_id).update({
      "last_msg": sendContent,
      "lastTime": Timestamp.now(),
    });
  }

  /// 📌 Scroll to bottom of chat
  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (msgScrolling.hasClients) {
        msgScrolling.animateTo(
          msgScrolling.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}


// import 'package:chat/common/entities/entities.dart';
// import 'package:chat/common/store/store.dart';
// import 'package:chat/pages/message/Chat/index.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChatController extends GetxController {
//   ChatController();
//   ChatState state = ChatState();
//   var doc_id = null;
//   final textController = TextEditingController();
//   ScrollController msgScrolling = ScrollController();
//   FocusNode contentNode = FocusNode();
//   final user_id = UserStore.to.token;
//   final db = FirebaseFirestore.instance;
//   var listener;
//   @override
//   void onInit() {
//     super.onInit();
//     var data = Get.parameters;
//     doc_id = data["doc_id"];
//     state.to_uid.value = data['to_uid'] ?? "";
//     state.to_name.value = data['to_name'] ?? "";
//     state.to_avatar.value = data['to_avatar'] ?? "";
//   }

//   // send messages
//   sendMessage() async {
//     String sendContent = textController.text;
//     final content = Msgcontent(
//         uid: user_id,
//         content: sendContent,
//         type: 'text',
//         addtime: Timestamp.now());
//     await db
//         .collection("chats")
//         .doc(doc_id)
//         .collection("msgList")
//         .withConverter(
//           fromFirestore: Msgcontent.fromFirestore,
//           toFirestore: (Msgcontent msgContent, options) =>
//               msgContent.toFirestore(),
//         )
//         .add(content)
//         .then(
//       (DocumentReference doc) {
//         print("Document Snapshot added with id,${doc.id}");
//         textController.clear();
//         Get.focusScope?.unfocus();
//       },
//     );
//     await db
//         .collection("message")
//         .doc(doc_id)
//         .update({"last_msg": sendContent, "lastTime": Timestamp.now()});
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     var messages = db
//         .collection("message")
//         .doc(doc_id)
//         .collection("msglist")
//         .withConverter(
//             fromFirestore: Msgcontent.fromFirestore,
//             toFirestore: (Msgcontent msgContent, options) =>
//                 msgContent.toFirestore())
//         .orderBy("addtime", descending: true);
//     state.Msgcontentlist.clear();
//     listener = messages.snapshots().listen(
//       (event) {
//         for (var change in event.docChanges) {
//           switch (change.type) {
//             case DocumentChangeType.added:
//               if (change.doc.data() != null) {
//                 state.Msgcontentlist.insert(0, change.doc.data()!);
//               }
//               break;
//             case DocumentChangeType.modified:
//               break;
//             case DocumentChangeType.removed:
//               break;
//           }
//           state.Msgcontentlist.refresh();
//         }
//       },
//       onError: (error) => print("Listen failed with $error"),
//     );
//   }

//   @override
//   void dispose() {
//     msgScrolling.dispose();
//     listener.cancel();
//     super.dispose();
//   }
// }
