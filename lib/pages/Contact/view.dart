import 'package:chat/common/widgets/app.dart';
import 'package:chat/pages/Contact/widgets/contactList.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar _buildAppBar() {
      return transparentAppBar(
        title: Text("Contact"),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ContactList(),
    );
  }
}
