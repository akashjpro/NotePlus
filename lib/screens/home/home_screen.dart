import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:note/components/gridview_widget.dart';
import 'package:note/database/models/note.dart';
import 'package:note/database/reponsitories/note_local_reponsitory.dart';
import 'package:note/helper/appLocalizations.dart';
import 'package:note/screens/note/note_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Home extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Note> notes = [];
  List<Note> result = [];
  bool _vantay = false;
  bool _guongmat = false;
  bool isLoading = true;
  late TextEditingController searchQuery;
  final LocalAuthentication auth = LocalAuthentication(); //authentication
  late bool? _authenticated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchQuery = TextEditingController(text: '');
    _authenticated = null;
    initValueCheck();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    setState(() {
      _authenticated = false;
    });
    auth.stopAuthentication();
    super.dispose();
  }

  var androidStrings = const AndroidAuthMessages(
      cancelButton: 'Hủy bỏ',
      goToSettingsButton: 'Cài đặt',
      goToSettingsDescription: 'Hãy bật xác thực vân tay trong phần cài đặt.',
      signInTitle: 'Xác thực',
      biometricHint: 'Để truy cập ứng dụng',
      biometricNotRecognized: 'Chưa thiết lập sinh trắc học',
      biometricSuccess: 'Xác thực thành công',
      biometricRequiredTitle: 'Kiểu xác thực');

  var iosStrings = const IOSAuthMessages(
      cancelButton: 'Hủy bỏ',
      goToSettingsButton: 'Cài đặt',
      goToSettingsDescription: 'Kiểm tra lại cài đặt vân tay');

  var localizedReason = Platform.isAndroid
      ? 'Quét vân tay hoặc hình vẽ để tiến hành xác thực'
      : 'Quét vân tay hoặc mã pin để tiến hành xác thực';

  Future<void> _authenticateWithLocalAuth(BuildContext context) async {
    bool authenticated = false;
    bool isAvailable = await auth.canCheckBiometrics;
    bool isDeviceSupported = await auth.isDeviceSupported();
    List<BiometricType> list = await auth.getAvailableBiometrics();

    if (isAvailable && isDeviceSupported) {
      try {
        authenticated = await auth.authenticate(
            localizedReason: localizedReason,
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false,
            iOSAuthStrings: iosStrings,
            androidAuthStrings: androidStrings);
      } on PlatformException catch (e) {
        print(e);
        return;
      }
      if (!mounted) return;
      setState(() {
        _authenticated = authenticated;
      });
      refreshNotes();
    }
  }

  Future<bool> _turnOnLocalAuth(
      BuildContext context, bool value, StateSetter myState) async {
    bool authenticated = false;
    bool isAvailable = await auth.canCheckBiometrics;
    bool isDeviceSupported = await auth.isDeviceSupported();
    List<BiometricType> list = await auth.getAvailableBiometrics();

    if (isAvailable && isDeviceSupported) {
      try {
        authenticated = await auth.authenticate(
            localizedReason: localizedReason,
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false,
            iOSAuthStrings: iosStrings,
            androidAuthStrings: androidStrings);
      } on PlatformException catch (e) {
        print(e);
        return false;
      }
      if (!mounted) return false;
    }
    if (authenticated) {
      return true;
    }
    return false;
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
    return isLoading
        ? Container(
            color: Colors.black.withOpacity(0.5),
          )
        : Scaffold(
            backgroundColor: Color(0xff292929),
            appBar: AppBar(
              backgroundColor: Color(0xff292929),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                AppLocalizations.of(context)!.translate("home")!,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                if (_authenticated!)
                  IconButton(
                      onPressed: () {
                        _showBottom(context);
                      },
                      icon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ))
              ],
            ),
            body: FutureBuilder(builder: (context, check) {
              return _authenticated!
                  ? Container(
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
                                                    color: Colors.white,
                                                    fontSize: 24),
                                              )
                                            : GridViewNotes(notes: result)),
                              ],
                            ),
                          ),
                          Positioned(
                            child: FlatButton(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => NoteScreen()),
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
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IconButton(
                            iconSize: 100,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                _authenticateWithLocalAuth(context),
                          ),
                          Text(
                            'Vui lòng xác thực !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
            }));
  }

  void toggleSwitchVantay(bool value) {
    setState(() {
      _vantay = value;
    });
  }

  void saveToPreferences(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  initValueCheck() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.get('vantay') == null || prefs.get('vantay') == false) {
      setState(() {
        _vantay = false;
        print('Vân tay: $_vantay');
      });
    }
    if (prefs.get('vantay') == true) {
      setState(() {
        _vantay = true;
        print('Vân tay: $_vantay');
      });
    }
    if (!_vantay) {
      setState(() {
        _authenticated = true;
        print('authen : $_authenticated');
      });
    } else {
      setState(() {
        _authenticated = false;
        print('authen : $_authenticated');
      });
    }
    if (_authenticated != null) isLoading = false;
    refreshNotes();
  }

  void _showBottom(BuildContext ctx) {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.black,
        context: ctx,
        builder: (ctx) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setModelState) {
              return Container(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ListTile(
                      shape: Border(
                          top: BorderSide(color: Colors.white.withOpacity(0.5)),
                          bottom:
                              BorderSide(color: Colors.white.withOpacity(0.5))),
                      title: Text(
                        'Xác thực',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Switch(
                          activeColor: Colors.orange,
                          activeTrackColor: Colors.yellow,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.orange,
                          value: _vantay,
                          onChanged: (value) async {
                            var check = await _turnOnLocalAuth(
                                context, value, setModelState);
                            if (check) {
                              setModelState(() {
                                _vantay = value;
                              });
                              _vantay = value;
                              if (_vantay == true) {
                                saveToPreferences('vantay', true);
                                Navigator.of(context)
                                    .pushReplacementNamed(Home.routeName);
                              } else
                                saveToPreferences('vantay', false);
                            }
                          }),
                    ),
                  ],
                ),
              );
            }));
  }
}
