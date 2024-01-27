import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/messages.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Chat App"),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.logOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          ChatMessages(),
          Messages(),
        ],
      ),
    );
  }
}
