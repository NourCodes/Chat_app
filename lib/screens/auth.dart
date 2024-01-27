import 'dart:io';
import 'package:chat_app/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final formKey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  File? _selectedImage;
  Auth auth = Auth();
  bool _isAuthenticating = false;

  Future submit() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      // validation failed, show error message
      Fluttertoast.showToast(
          msg: "Please Check your Data", gravity: ToastGravity.TOP);
      return;
    }

    if (!isLogin && _selectedImage == null) {
      // image is required for registration, show error message
      Fluttertoast.showToast(
          msg: "Please select a profile image for registration",
          gravity: ToastGravity.TOP);
      return;
    }
    formKey.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });

    if (isLogin) {
      await auth.signIn(_email, _password, context);
    } else {
      await auth.createUser(
          _email, _password, context, _username, _selectedImage);
    }
    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  right: 70,
                  left: 70,
                  bottom: 30,
                ),
                child: Image.asset('images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //if we are creating an account display add user image
                          if (!isLogin)
                            UserImage(
                              onPickedImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          if (!isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Username",
                              ),
                              enableSuggestions: false,
                              onSaved: (newValue) {
                                _username = newValue!;
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return "Please enter at least 4 characters";
                                }
                                return null;
                              },
                            ),
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password must be at least 6 character long";
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            obscureText: true,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (newValue) {
                              _password = newValue!;
                            },
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              onPressed: () {
                                submit();
                              },
                              child: Text(isLogin ? "Login" : "Signup"),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
