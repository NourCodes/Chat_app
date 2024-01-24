import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImage extends StatefulWidget {
  final void Function(File pickedImage) onPickedImage;
  const UserImage({Key? key, required this.onPickedImage}) : super(key: key);

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? selectedImageFile;
  void _imagePicked() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      selectedImageFile = File(pickedImage!.path);
    });
    widget.onPickedImage(selectedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          foregroundImage:
              selectedImageFile != null ? FileImage(selectedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _imagePicked,
          icon: const Icon(
            Icons.image,
          ),
          label: Text("Add Image",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
        ),
      ],
    );
  }
}
