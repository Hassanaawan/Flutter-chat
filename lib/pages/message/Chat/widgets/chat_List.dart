import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/pages/message/Chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(controller.doc_id)
          .collection("msgList")
          .orderBy("addtime", descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

// ✅ Preserve scroll position
        double? previousScrollOffset;
        if (controller.msgScrolling.hasClients) {
          previousScrollOffset = controller.msgScrolling.position.pixels;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.msgScrolling.hasClients) {
            double maxScroll = controller.msgScrolling.position.maxScrollExtent;
            double currentScroll = controller.msgScrolling.position.pixels;
            double threshold =
                100.0; // ✅ User must be within 100px of the bottom

            if ((maxScroll - currentScroll) < threshold) {
              // ✅ If user is near the bottom, scroll to bottom
              controller.msgScrolling.animateTo(
                maxScroll,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } else if (previousScrollOffset != null) {
              // ✅ Restore previous scroll position
              controller.msgScrolling.jumpTo(previousScrollOffset);
            }
          }
        });

        return ListView.builder(
          controller: controller.msgScrolling,
          itemCount: snapshot.data!.docs.length,
          padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
          itemBuilder: (context, index) {
            final message = snapshot.data!.docs[index];
            bool isMe = message["uid"] == controller.user_id;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                padding: message["type"] == "image"
                    ? EdgeInsets.all(5.w)
                    : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                constraints: BoxConstraints(
                  maxWidth: 0.7.sw,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue[200] : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                    bottomLeft: isMe ? Radius.circular(12.r) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : Radius.circular(12.r),
                  ),
                ),
                child: message["type"] == "image"
                    ? GestureDetector(
                        onTap: () => _viewImage(context, message["content"]),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: CachedNetworkImage(
                                imageUrl: message["content"],
                                width: 0.6.sw,
                                height: 200.h,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _imageShimmer(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, size: 30.sp),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download, color: Colors.white),
                              onPressed: () =>
                                  _downloadImage(message["content"]),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        message["content"],
                        style:
                            TextStyle(fontSize: 16.sp, color: Colors.black87),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  void _viewImage(BuildContext context, String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => _imageShimmer(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, size: 50.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _downloadImage(String imageUrl) async {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
      barrierDismissible: false,
    );

    if (await Permission.storage.request().isGranted) {
      try {
        bool? success = await GallerySaver.saveImage(imageUrl);
        Get.back();

        if (success == true) {
          Fluttertoast.showToast(
            msg: "✅ Image saved to gallery!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "❌ Failed to save image!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Get.back();
        Fluttertoast.showToast(
          msg: "❌ Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      Get.back();
      Fluttertoast.showToast(
        msg: "⚠️ Permission Denied!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }
}

_imageShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: 200.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),
  );
}



// import 'package:chat/pages/message/Chat/controller.dart';
// import 'package:chat/pages/message/Chat/widgets/chat_right_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class ChatList extends GetView<ChatController> {
//   const ChatList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         // color: Colors.white,
//         padding: EdgeInsets.only(bottom: 50.h),
//         child: CustomScrollView(
//           reverse: true,
//           controller: controller.msgScrolling,
//           slivers: [
//             SliverPadding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 0.w,
//                 vertical: 0.w,
//               ),
//               sliver: SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     var item = controller.state.Msgcontentlist[index];
//                     if (controller.user_id == item.uid) {
//                       return ChatRightItem(item);
//                     }
//                   },
//                   childCount: controller.state.Msgcontentlist.length,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
