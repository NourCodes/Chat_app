import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Auth {
  final firebaseMessaging = FirebaseMessaging.instance;
  void setupNotification() async {
    // request permission for receiving notifications
    await firebaseMessaging.requestPermission();

    // get the token for this device
    final token = await firebaseMessaging.getToken();

    // subscribe to the "chat" topic
    firebaseMessaging.subscribeToTopic("chat");
  }

  // instance of FirebaseAuth to interact with Firebase authentication
  final _firebase = FirebaseAuth.instance;
  // asynchronous method to create a user with provided email and password
  Future createUser(String email, String password, BuildContext context,
      String username, File? selectedImage) async {
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

      // retrieve the download URL for the uploaded image from Firebase Storage
      final imageUrl = await storageRef.getDownloadURL();

      // access the Firestore instance and add the user information to the "users" collection
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        // store the username provided during account creation
        "username": username,
        // store the email address associated with the user account
        "email": email,
        // store the download URL of the user's profile image in Firestore
        "imageUrl": imageUrl,
      });

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

  // this function adds a new message to the Firestore database
  Future<void> addMessages(String message) async {
    // get the current user from Firebase authentication
    final user = _firebase.currentUser!;

    // retrieve user data from Firestore based on the current user's ID
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    // add the new message to the 'chat' collection in Firestore
    await FirebaseFirestore.instance.collection("chat").add({
      "text": message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!["username"],
      'userImage': userData.data()!["imageUrl"],
    });
  }

// fetches chat messages from Firestore using a stream
  Stream get chats {
    return FirebaseFirestore.instance
        .collection("chat")
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  User? get currentUser {
    return _firebase.currentUser;
  }
}
