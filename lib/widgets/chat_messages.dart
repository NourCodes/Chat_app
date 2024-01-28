import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create an instance of the Auth class to access user authentication data
    Auth auth = Auth();
    // get the current user
    final currentUser = auth.currentUser;

    // listen for changes in the chat messages stream
    return StreamBuilder(
      stream: auth.chats,
      builder: (context, snapshot) {
        // display a loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // display a message when there are no chat messages available
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

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            right: 12,
            left: 12,
          ),
          // reverse the ListView to display messages from bottom to top
          reverse: true,
          itemBuilder: (context, index) {
            final chats = loadedMessages[index].data();
            final nextMessages = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentUserId = chats["userId"];
            final nextMessageUserId =
                nextMessages != null ? nextMessages["userId"] : null;
            final nextUserIsSame = nextMessageUserId == currentUserId;

            // check if the next message is from the same user and return the appropriate message bubble
            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chats['text'],
                  isMe: currentUser!.uid == currentUserId);
            } else {
              return MessageBubble.first(
                  userImage: chats['userImage'],
                  username: chats['username'],
                  message: chats['text'],
                  isMe: currentUser!.uid == currentUserId);
            }
          },
          itemCount: loadedMessages.length,
        );
      },
    );
  }
}
