import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:note/helper/shared_prefs.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteScreen extends StatefulWidget {
  static String routeName = "/note";

  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  File? imageFile;
  File? imageLocal;
  String? customImageFile;
  Image? image;

  //==========Test======================

  Future<void> _saveImage(File file) async {
    Directory a = await getApplicationDocumentsDirectory();
    final String path = a.path;
    final fileName = basename(file.path);
    final File localImage = await file.copy('$path/$fileName');
    print("iamge file = $localImage");
    print("iamge file = $path");
    print("iamge file = $fileName");

    setState(() {
      imageLocal = localImage;
    });
  }

  loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      setState(() {
        imageFile = ImageSharedPrefs.imageFrom64BaseString(imageString!);
      });
    }
  }
  //====================================

  _openGallery(BuildContext context) async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picture != null) {
      setState(() {
      _saveImage(File(picture.path));
      });

      // setState(() {
      //   imageFile = File(picture.path);
      // });
      // ImageSharedPrefs.saveImageToPrefs(
      //     ImageSharedPrefs.base64String(imageFile!.readAsBytesSync()));
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picture != null) {
      setState(() {
        _saveImage(File(picture.path));
      });
      // setState(() {
      // imageFile = File(picture.path);
      // });
      // ImageSharedPrefs.saveImageToPrefs(
      //     ImageSharedPrefs.base64String(imageFile!.readAsBytesSync()));
    }
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget showImage() {
    return imageFile == null
        ? Container()
        : Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ClipRRect(
                    child: Image.file(
                  imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ))));
  }
  @override
  void initState() {
    super.initState();
    loadImage();
  }
  @override
  Widget build(BuildContext context) {
    Widget buildColor(int a) {
      return new Container(
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.circle,
            color: Color(a),
            size: 40.0,
          ),
        ),
        margin: EdgeInsets.only(right: 3.0, left: 3.0),
      );
    }

    Widget fineColor = new Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          buildColor(0xFF000000),
          buildColor(0xFFD32F2F),
          buildColor(0xFF4527A0),
          buildColor(0xFF3D5AFE),
          buildColor(0xFFFFEA00),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff292929),
        elevation: 0,
        title: Text(
          "Note",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Color(0xff292929),
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              // 'Note title',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration.collapsed(
                hintText: "Note title",
                hintStyle: TextStyle(color: Color(0xffCECECE)),
              ),
            ),
            SizedBox(height: 8),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Monday, 12 July 2021 09:00 AM',
                  style: TextStyle(color: Colors.white),
                )),
            fineColor,
            TextButton(
                onPressed: () {
                  _showChoiceDialog(context);
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
            TextButton(
                onPressed: null,
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(right: 3),
                    ),
                    Text(
                      "Add url",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            SizedBox(height: 8),
            TextField(
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration.collapsed(
                  hintText: "Enter Note Here",
                  hintStyle: TextStyle(color: Color(0xffCECECE))),
            ),
            showImage(),
          ],
        ),
      ),
    );
  }
}
