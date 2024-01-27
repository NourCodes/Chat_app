import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submitMessage() {
    final message = _controller.text;
    if (message.trim().isEmpty) {
      return;
    }
    //clear the message
    _controller.clear();
    FocusScope.of(context).unfocus();

    //send message to firebase
    Auth auth = Auth();
    auth.addMessages(message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 1.0,
        bottom: 14.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enableSuggestions: true,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Send a message",
              ),
            ),
          ),
          IconButton(
            onPressed: submitMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
