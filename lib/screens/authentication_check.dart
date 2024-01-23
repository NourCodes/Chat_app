import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/cupertino.dart';

//this page is responsible for checking the authentication status
// and navigating the user to the appropriate screen (AuthScreen or ChatScreen)
class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();

    // using a StreamBuilder to listen for changes in the authentication status
    return StreamBuilder(
      stream: auth.users,
      builder: (context, snapshot) {
        /// if user is authenticated, navigate to the ChatScreen
        if (snapshot.hasData) {
          return const ChatScreen();
        }
        // if the user is not authenticated, navigate to the AuthScreen.
        else {
          return const AuthScreen();
        }
      },
    );
  }
}
