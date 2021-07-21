import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  File? imagePicked;
  final Function(File) showImagePicked;
  PickImage(
      {Key? key, required this.imagePicked, required this.showImagePicked})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => PickImageState();
}

class PickImageState extends State<PickImage> {
  File? _file;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _file = widget.imagePicked;
  }

  Future getImageFrom(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    setState(() {
      _file = File(image!.path);
      widget.showImagePicked(_file!);
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    if (Platform.isAndroid) {
      showModalBottomSheet(
        elevation: 10,
        context: context,
        builder: (context) => Container(
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    getImageFrom(ImageSource.camera);
                  }),
              ListTile(
                leading: Icon(Icons.photo_album_rounded),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  getImageFrom(ImageSource.gallery);
                },
              )
            ],
          ),
        ),
      );
    } else if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    child: Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImageFrom(ImageSource.camera);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImageFrom(ImageSource.gallery);
                    },
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: TextButton(
          onPressed: () {
            _showImageSourceActionSheet(context);
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 3),
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
              Text(
                "Add image",
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }
}
