import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Auth {
  // instance of FirebaseAuth to interact with Firebase authentication
  final _firebase = FirebaseAuth.instance;
  // asynchronous method to create a user with provided email and password
  Future createUser(String email, String password, BuildContext context,
      File? selectedImage) async {
    try {
      //create a new user with the provided email and password
      UserCredential result = await _firebase.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      // retrieve the created user from the result
      User? user = result.user;

      // create a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance
          .ref() //gets the reference to the root of the storage
          .child(
              'user_images') // creates a directory named 'user_images' for user images
          .child(
              "${user!.uid}.jpg"); // unique file name based on the user's UID

      await storageRef.putFile(
          selectedImage!); // upload the selected image file to the specified storage location

      // return the created user
      return user;
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

  //asynchronous function to log out the current user
  Future logOut() async {
    return await _firebase.signOut();
  }
}
