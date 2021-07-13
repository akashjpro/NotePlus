import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note/entities/note.dart';

class GridViewNotes extends StatefulWidget {
  List<Note> notes;
  GridViewNotes({required this.notes, Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GridViewNotesState();
  }
}

class GridViewNotesState extends State<GridViewNotes> {
  Color hexToColor(String code) {
    return new Color(int.parse(code, radix: 16));
  }
  List<Widget> note_builder(List<Note> notes) {
    var items = notes.map((Note) => Container(
          width: 190.0,
          decoration: BoxDecoration(
            border:Border.all(width: 0,style: BorderStyle.none),
            borderRadius: BorderRadius.circular(15),
            color:Color(Note.typeColor),
          ),
          child:Column(
            children: [
              Note.uriImage == null
                  ? Container()
                  : Expanded(child: ClipRRect(
                     borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15)),
                     child: Image.asset(
                      Note.uriImage ?? '',
                      width: 190,
                      height: 400,
                      fit: BoxFit.fill,
                ),
              )),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Note.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      Note.content,
                      style: TextStyle(
                        color:Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Note.webLink == null
                        ? Container()
                        : Text(
                      Note.webLink ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(Note.id * 1000).toIso8601String(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
    return items.toList();
  }
  List<StaggeredTile> staggered_tile_builder(List<Note> notes) {
    var items = notes.map((Note){
      if(Note.uriImage==null) return StaggeredTile.extent(1,120);
      else return StaggeredTile.extent(1,350);
    });
    return items.toList();
  }
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 16,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10),
      physics:  NeverScrollableScrollPhysics(),
      children: note_builder(widget.notes),
      staggeredTiles:staggered_tile_builder(widget.notes),
    );
    // TODO: implement build
    // return GridView.extent(

    // );
  }
}
