import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/components/search_widget.dart';
import 'package:note/components/gridview_widget.dart';
import 'package:note/database/models/note.dart';
import 'package:note/screens/note/note_screen.dart';

import '../../routes.dart';

final List<Note> notes = [
  Note(
      content: 'Hello , I am Anaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      id: 1,
      uriImage: 'images/test.png',
      typeColor: 0xff800000,
      title: 'Test Quick Actionsaaaaaaaaaaaaaaaaaaaaa',
      webLink: 'aaaaaaaaaaaa.com'),
  Note(
      content: 'Hello , I am An',
      id: 1,
      typeColor: 0xffCC9966,
      title: 'Test Quick Actions'),
  Note(
      content: 'Hello , I am An',
      id: 1,
      uriImage: 'images/test3.png',
      typeColor: 0xff339966,
      title: 'Test Quick Actions'),
  Note(
      content: 'Hello , I am An',
      id: 1,
      uriImage: 'images/test4.png',
      typeColor: 0xffCC9900,
      title: 'Test Quick Actions'),
  Note(
      content: 'Hello , I am An',
      id: 1,
      uriImage: 'images/test2.png',
      typeColor: 0xff000055,
      title: 'Test Quick Actions'),
  Note(
      content: 'Hello , I am An',
      id: 1,
      uriImage: 'images/test.png',
      typeColor: 0xff800000,
      title: 'Test Quick Actions'),
];

class Home extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          backgroundColor: Color(0xff292929),
          elevation: 0,
          title: Text(
            'Home',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              Container(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [SearchSection(), GridViewNotes(notes: notes)],
                ),
              ),
              Positioned(
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushNamed(context, NoteScreen.routeName);
                    },
                    child: Icon(Icons.add,size: 50,color: Colors.black,),
                    color: Color(0xfffdbe3b),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                  ),
                  bottom: 30,
                  right: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
