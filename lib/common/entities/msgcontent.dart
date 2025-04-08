// import 'package:cloud_firestore/cloud_firestore.dart';

// class Msgcontent {
//   final String uid;
//   final String content;
//   final String type;
//   final Timestamp addtime;

//   Msgcontent({
//     required this.uid,
//     required this.content,
//     required this.type,
//     required this.addtime,
//   });

//   /// Convert Firestore document to Msgcontent object
//   factory Msgcontent.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     final data = snapshot.data();
//     return Msgcontent(
//       uid: data?['uid'] ?? '', // ✅ Provide default values
//       content: data?['content'] ?? '',
//       type: data?['type'] ?? 'text',
//       addtime: data?['addtime'] ?? Timestamp.now(),
//     );
//   }

//   /// Convert Msgcontent object to Firestore document
//   Map<String, dynamic> toFirestore() {
//     return {
//       "uid": uid,
//       "content": content,
//       "type": type,
//       "addtime": addtime,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Msgcontent {
  final String? uid;
  final String? content;
  final String? type;
  final Timestamp? addtime;

  Msgcontent({
    this.uid,
    this.content,
    this.type,
    this.addtime,
  });

  factory Msgcontent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Msgcontent(
      uid: data?['uid'],
      content: data?['content'],
      type: data?['type'],
      addtime: data?['addtime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (content != null) "content": content,
      if (type != null) "type": type,
      if (addtime != null) "addtime": addtime,
    };
  }
}
