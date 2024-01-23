import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  // instance of FirebaseAuth to interact with Firebase authentication
  final _firebase = FirebaseAuth.instance;
  // asynchronous method to create a user with provided email and password
  Future createUser(String email, String password, BuildContext context) async {
    try {
      //create a new user with the provided email and password
      UserCredential result = await _firebase.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      // retrieve the created user from the result
      User? user = result.user;
      // return the created user
      return user!;
    } on FirebaseAuthException catch (e) {
      // handle FirebaseAuthException, which may occur during user creation
      // check if the associated widget is still mounted in the widget tree
      if (!context.mounted) {
        // if not mounted, return without further processing
        return;
      }
      // clear any existing snack bars to prevent multiple messages
      ScaffoldMessenger.of(context).clearSnackBars();
      // show a snack bar with an error message, or a default message if the error message is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed'),
        ),
      );
    }
  }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      //sign in the user with the provided email and password
      await _firebase.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      // check if the associated widget is still mounted in the widget tree
      if (!context.mounted) {
        // if not mounted, return without further processing
        return;
      }
      // clear any existing snack bars to prevent multiple messages
      ScaffoldMessenger.of(context).clearSnackBars();
      // show a snack bar with an error message, or a default message if the error message is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed'),
        ),
      );
    }
  }

  //returns a stream for tracking changes in authentication state
  Stream get users => _firebase.authStateChanges();
}
