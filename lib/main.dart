import 'package:flutter/material.dart';
import 'package:note/routes.dart';
import 'package:note/screens/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helper/appLocalizations.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', ''),
        Locale('vi', 'VN'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'Note App',
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: Home.routeName,
      routes: routes,
    );
  }
}
