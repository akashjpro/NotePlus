import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/components/pick_image_widget.dart';
import 'package:path_provider/path_provider.dart';

class NoteScreen extends StatefulWidget {
  static String routeName = "/note";
  @override
  State<StatefulWidget> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  File? imagePick;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    int b = 0xFF000000;
    final _backGrounColor = Color(b);
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
        // width: 30,
        // height: 30,
        // // padding: EdgeInsets.all(10.0),
        // decoration: BoxDecoration(shape: BoxShape.circle, color: Color(a)),
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
            if (imagePick != null)
              GestureDetector(
                child: Image.file(imagePick!),
                onTap: () => _showImageTapActionSheet(context),
              ),
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
            PickImage(
              imagePicked: imagePick,
              showImagePicked: showImage,
            ),
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
            )
          ],
        ),
      ),
    );
  }

  void showImage(File file) {
    setState(() {
      imagePick = file;
    });
  }

  void unPickImage() {
    setState(() {
      imagePick = null;
    });
  }

  Future getImageFrom(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    setState(() {
      imagePick = File(image!.path);
    });
  }

  Future<void> saveFileToAppDirectory(File? filePicked) async {
    if (filePicked != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final File newImage = await filePicked.copy('$appDocPath/image1.png');
      print(newImage.path);
    }
  }

  void _showImageTapActionSheet(BuildContext context) {
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
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    unPickImage();
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
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      unPickImage();
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
}
