import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {

  static String routeName = "/note";

  @override
  Widget build(BuildContext context) {
    int b = 0xFF000000;
    final _backGrounColor = Color(b);
    Widget buildColor(int a) {
      return new Container(
        child: IconButton(onPressed: () { }, icon: Icon(Icons.circle,color: Color(a),size: 40.0,),),
        margin: EdgeInsets.only(right: 3.0,left: 3.0),
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
          style: TextStyle(color: Colors.white),
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
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration.collapsed(
                hintText: "Note title",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Monday, 12 July 2021 09:00 AM',
                  style: TextStyle(color: Colors.white),
                )),
            fineColor,
            TextButton(
                onPressed: null,
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
            TextField(
              decoration: InputDecoration.collapsed(
                  hintText: "Enter Note Here",
                  hintStyle: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
