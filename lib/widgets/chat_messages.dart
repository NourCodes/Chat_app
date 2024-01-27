import 'package:chat_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();

    // streamBuilder listens for changes in chat messages and rebuilds the UI accordingly
    return StreamBuilder(
      stream: auth.chats,
      builder: (context, snapshot) {
        // display a loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // display a message when there are no chat messages
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Messages"),
          );
        }
        // display an error message if there's an error fetching chat messages
        if (snapshot.hasError) {
          return const Center(child: Text("An Error Occurred"));
        }

        // extract chat messages from the snapshot
        final loadedMessages = snapshot.data!.docs;

        // display the chat messages in a ListView
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(
              loadedMessages[index]["text"],
            ),
          ),
          itemCount: loadedMessages.length,
        );
      },
    );
  }
}
