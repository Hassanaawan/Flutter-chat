import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/entities/msg.dart';
import 'package:chat/common/utils/Colors.dart';
import 'package:chat/pages/message/messages/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageList extends GetView<MessagesController> {
  const MessageList({super.key});

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM d, h:mm a')
        .format(dateTime); // Example: Mar 20, 10:30 AM
  }

  Widget messageListItem(QueryDocumentSnapshot<Msg> item, String token) {
    final msg = item.data();
    final isCurrentUser = msg.from_uid == token;
    final lastMessage = msg.last_msg ?? 'No messages yet';
    final lastMessageTime = formatTimestamp(msg.last_time);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: InkWell(
        onTap: () {
          var to_uid = "";
          var to_name = "";
          var to_avatar = "";
          if (item.data().from_uid == controller.token) {
            to_uid = item.data().to_uid ?? "";
            to_name = item.data().to_name ?? "";
            to_avatar = item.data().to_avatar ?? "";
          } else {
            to_uid = item.data().from_uid ?? "";
            to_name = item.data().from_name ?? "";
            to_avatar = item.data().from_avatar ?? "";
          }
          Get.toNamed("/chat", parameters: {
            "doc_id": item.id,
            "to_uid": to_uid,
            "to_name": to_name,
            "to_avatar": to_avatar,
          });
        },
        child: Row(
          children: [
            // Avatar Section
            Container(
              padding: EdgeInsets.only(right: 15.w),
              child: CircleAvatar(
                radius: 27.w,
                backgroundImage: CachedNetworkImageProvider(
                  isCurrentUser
                      ? (msg.to_avatar ?? '')
                      : (msg.from_avatar ?? ''),
                ),
              ),
            ),
            // Message Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    isCurrentUser
                        ? (msg.to_name ?? 'Unknown')
                        : (msg.from_name ?? 'Unknown'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  // Last Message & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryColor.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        lastMessageTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.onLoading,
        onRefresh: controller.onRefresh,
        header: const WaterDropHeader(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = controller.state.msgList[index];
                    return messageListItem(item, controller.token);
                  },
                  childCount: controller.state.msgList.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
