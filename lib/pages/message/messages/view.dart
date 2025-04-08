import 'package:chat/common/widgets/app.dart';
import 'package:chat/pages/message/Chat/widgets/messageList.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});
  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text(
        "Message",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: const MessageList(),
    );
  }
}
