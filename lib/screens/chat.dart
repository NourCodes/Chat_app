import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/messages.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Auth auth = Auth();

  @override
  void initState() {
    super.initState();
    auth.setupNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
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
          Expanded(
            child: ChatMessages(),
          ),
          Messages(),
        ],
      ),
    );
  }
}
