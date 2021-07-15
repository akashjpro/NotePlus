import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatelessWidget {
  @override
  final int b = 0xFF000000;

  Widget build(BuildContext context) {
    Widget buildColor(int a) {
      return new Container(
        child: IconButton(onPressed: () { }, icon: Icon(Icons.circle,color: Color(a),size: 40.0,),),

        margin: EdgeInsets.only(right: 3.0,left: 3.0),
        // width: 30,
        // height: 30,
        // // padding: EdgeInsets.all(10.0),
        //
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
        backgroundColor: Color(0xFF000000),
        title: Text(
          "Note Detail",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black54,
        padding: EdgeInsets.all(15.0),
        child: ListView(

          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              // 'Note title',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
              decoration: InputDecoration.collapsed(
                hintText: "Note title",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Monday, 12 July 2021 09:00 AM',
                  style: TextStyle(color: Colors.white),
                )),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quote Of The Day",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child:
              Image.asset('images/1.jpg'),
            ),
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
          ],
        ),
      ),
    );
  }
}

class MyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: Row(
        children: [

        ],
    ));
  }

}