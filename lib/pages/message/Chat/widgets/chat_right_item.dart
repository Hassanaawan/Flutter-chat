import 'package:chat/common/entities/entities.dart';
import 'package:chat/common/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

Widget ChatRightItem(Msgcontent item) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(4), // Tail effect
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.content ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('hh:mm a')
                            .format(item.addtime!.toDate()), // Format time
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.done_all, // Double ticks like WhatsApp
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat/common/entities/entities.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget ChatRightItem(Msgcontent item) {
//   return Container(
//     padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
//     child: Container(
//       padding:
//           EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
//       decoration: BoxDecoration(
        // gradient: LinearGradient(colors: [
        //   Color(0xFFF66666),
        //   Color(0xFFD20A0A), // Primary Color
        //   Color(0xFF720404),
        //   Color(0xFF520303), // Darkest shade
        // ], transform: GradientRotation(90)),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.w),
//           topRight: Radius.circular(10.w),
//           bottomLeft: Radius.circular(10.w),
//           bottomRight: Radius.circular(10.w),
//         ),
//       ),
//       child: item.type == "text"
//           ? Text(
//               "${item.content}",
//               style: TextStyle(color: Colors.black),
//             )
//           : ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 200.w),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: CachedNetworkImage(imageUrl: "${item.content}"),
//               ),
//             ),
//     ),
//   );
// }
