import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/components/gridview_widget.dart';
import 'package:note/database/models/note.dart';
import 'package:note/database/reponsitories/note_local_reponsitory.dart';
import 'package:note/helper/appLocalizations.dart';
import 'package:note/screens/note/note_screen.dart';

import '../../routes.dart';

class Home extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [];
  List<Note> result = [];
  late bool isLoading;
  late TextEditingController searchQuery;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    searchQuery = TextEditingController(text: '');
    refreshNotes();
    print('init');
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNote();
    result.clear();
    result.addAll(notes);
    setState(() => isLoading = false);
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      result.clear();
      result.addAll(notes);
      setState(() {});
    } else {
      List<Note> _searchList = [];
      notes.forEach((note) {
        if (note.content.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            note.title.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          _searchList.add(note);
        }
      });
      // Refresh the UI
      result.clear();
      result.addAll(_searchList);
      setState(() {});
    }
  }

  searchSection(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: searchQuery,
      onChanged: (_searchText) => _runFilter(_searchText),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.translate("searchNotes"),
        hintStyle: TextStyle(color: Color(0xff7b7b7b)),
        filled: true,
        fillColor: Color(0xff333333),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        suffixIcon: searchQuery.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchQuery.text = '';
                  _runFilter(searchQuery.text);
                },
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        backgroundColor: Color(0xff292929),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.translate("home")!,
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
                children: [
                  searchSection(context),
                  Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : result.isEmpty
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .translate("empty")!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              : GridViewNotes(notes: result)),
                ],
              ),
            ),
            Positioned(
              child: FlatButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NoteScreen()),
                  );
                  refreshNotes();
                },
                child: Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.black,
                ),
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
    );
  }
}
