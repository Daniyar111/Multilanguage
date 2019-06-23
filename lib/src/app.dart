import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/other_screen.dart';
import 'utils/global_translations.dart';
import 'screens/home_screen.dart';
import 'data/blocs/translations_bloc.dart';
import 'data/blocs/bloc_provider.dart';

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  TranslationsBloc translationsBloc;

  @override
  void initState() {
    super.initState();

    translationsBloc = TranslationsBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TranslationsBloc>(
      bloc: translationsBloc,
      child: StreamBuilder<Locale>(
        stream: translationsBloc.currentLocale,
        initialData: allTranslations.locale,
        builder: (BuildContext context, AsyncSnapshot<Locale> snapshot){

          return MaterialApp(
            title: 'Internatianolization',
            locale: snapshot.data ?? allTranslations.locale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: allTranslations.supportedLocales(),
            routes: {
//              '/': (BuildContext context) => HomeScreen(),
              '/other_screen': (BuildContext context) => OtherScreen()
            },
            home: HomeScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    translationsBloc?.dispose();
    super.dispose();

  }
}
