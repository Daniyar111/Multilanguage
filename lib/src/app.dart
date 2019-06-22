import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'utils/global_translations.dart';
import 'screens/home_screen.dart';

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();

//    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: <LocalizationsDelegate>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: allTranslations.supportedLocales(),
      home: HomeScreen()
    );
  }

  void _onLocaleChanged() async {
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }
}
