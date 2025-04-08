import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/utils/Colors.dart';
import 'package:chat/pages/message/Chat/controller.dart';
import 'package:chat/pages/message/Chat/widgets/chat_List.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF66666),
              Color(0xFFD20A0A), // Primary Color
              Color(0xFF720404),
              Color(0xFF520303), // Darkest shade
            ],
            transform: GradientRotation(90),
          ),
        ),
      ),
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              controller.state.to_avatar.value.isNotEmpty
                  ? controller.state.to_avatar.value
                  : 'https://via.placeholder.com/150', // Fallback image
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.state.to_name.value,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Online", // TODO: Implement real presence tracking
                style: TextStyle(fontSize: 12.sp, color: Colors.greenAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: AppColors.primaryColor),
                title: Text("Gallery",
                    style: TextStyle(color: AppColors.primaryColor)),
                onTap: () {
                  controller.imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera, color: AppColors.primaryColor),
                title: Text("Camera",
                    style: TextStyle(color: AppColors.primaryColor)),
                onTap: () {
                  controller.imgFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ChatList()), // ✅ Chat messages list
            _buildMessageInput(context), // ✅ Message input field
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: controller.textController,
              focusNode: controller.contentNode,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primaryColor),
            onPressed: controller.sendMessage,
          ),
          IconButton(
            icon: Icon(Icons.photo, color: AppColors.primaryColor),
            onPressed: () => _showPicker(context),
          ),
        ],
      ),
    );
  }
}



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat/common/utils/Colors.dart';
// import 'package:chat/pages/message/Chat/widgets/chat_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import 'controller.dart';

// class ChatPage extends GetView<ChatController> {
//   const ChatPage({super.key});

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     flexibleSpace: Container(
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             Color(0xFFF66666),
  //             Color(0xFFD20A0A), // Primary Color
  //             Color(0xFF720404),
  //             Color(0xFF520303), // Darkest shade
  //           ],
  //           transform: GradientRotation(90),
  //         ),
  //       ),
  //     ),
  //     elevation: 0,
  //     title: Row(
  //       children: [
  //         CircleAvatar(
  //           backgroundImage: CachedNetworkImageProvider(
  //             controller.state.to_avatar.value,
  //           ),
  //         ),
  //         SizedBox(width: 10.w),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               controller.state.to_name.value,
  //               style: TextStyle(
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white),
  //             ),
  //             Text(
  //               "Online", // Add presence tracking if needed
  //               style: TextStyle(fontSize: 12.sp, color: Colors.greenAccent),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[100],
  //     appBar: _buildAppBar(),
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           Expanded(child: ChatList()), // ✅ Chat messages list
  //           _buildMessageInput(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildMessageInput() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: controller.textController,
  //             focusNode: controller.contentNode,
  //             decoration: InputDecoration(
  //               hintText: "Type a message...",
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //                 borderSide: BorderSide.none,
  //               ),
  //               filled: true,
  //               fillColor: Colors.grey[200],
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 10.w),
  //         IconButton(
  //           icon: Icon(Icons.send, color: AppColors.primaryColor),
  //           onPressed: controller.sendMessage,
  //         ),
  //         IconButton(
  //             icon: Icon(Icons.photo, color: AppColors.primaryColor),
  //             onPressed: () {}),
  //       ],
  //     ),
  //   );
//   }
// }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat/common/utils/Colors.dart';
// import 'package:chat/pages/message/Chat/widgets/chat_List.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:get/get.dart';

// import 'controller.dart';

// class ChatPage extends GetView<ChatController> {
//   const ChatPage({super.key});
//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       flexibleSpace: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFF66666),
//               Color(0xFFD20A0A), // Primary Color
//               Color(0xFF720404),
//               Color(0xFF520303), // Darkest shade
//             ],
//             transform: GradientRotation(90),
//           ),
//         ),
//       ),
//       title: Container(
//         padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 0.w, bottom: 0.w),
//         child: Row(
//           children: [
//             Container(
//               padding:
//                   EdgeInsets.only(left: 0.w, right: 0.w, top: 0.w, bottom: 0.w),
//               child: InkWell(
//                 onTap: () {},
//                 child: CircleAvatar(
//                   backgroundImage: CachedNetworkImageProvider(
//                     controller.state.to_avatar.value,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(
//                   left: 10.w, right: 0.w, top: 5.w, bottom: 0.w),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 180.w,
//                     height: 44.w,
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             controller.state.to_name.value,
//                             maxLines: 1,
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.white,
//                               overflow: TextOverflow.clip,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             controller.state.to_location.value,
//                             maxLines: 1,
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.white,
//                               overflow: TextOverflow.clip,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: SafeArea(
//         child: ConstrainedBox(
//           constraints: BoxConstraints.expand(),
//           child: Stack(
//             children: [
//               const ChatList(),
//               Positioned(
//                 bottom: 0.h,
//                 height: 50.h,
//                 child: Container(
//                   width: 360.w,
//                   height: 50.h,
//                   color: Colors.white,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 217.w,
//                         height: 50.h,
//                         color: Colors.white,
//                         child: TextField(
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 6,
//                           controller: controller.textController,
//                           autofocus: false,
//                           focusNode: controller.contentNode,
//                           decoration: const InputDecoration(
//                             hintText: "Message",
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 50.w,
//                         height: 50.h,
//                         margin: EdgeInsets.only(left: 5.w),
//                         color: Colors.white,
//                         child: GestureDetector(
//                           onTap: () {},
//                           child: Icon(
//                             Icons.photo,
//                             color: AppColors.secondaryColor,
//                             size: 30.w,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 50.w,
//                         height: 50.h,
//                         margin: EdgeInsets.only(left: 5.w),
//                         color: Colors.white,
//                         child: GestureDetector(
//                           onTap: () {
//                             controller.sendMessage();
//                           },
//                           child: Icon(
//                             Icons.send,
//                             color: AppColors.secondaryColor,
//                             size: 30.w,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
