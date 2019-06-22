import 'package:flutter/material.dart';

import '../helpers/global_translations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    final String language = allTranslations.currentLanguage;
    final String buttonText = language == 'ru' ? '=> English' : '=> Russian';

    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('main_title')),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(buttonText),
              onPressed: () async{
                await allTranslations.setNewLanguage(language == 'ru' ? 'en' : 'ru');
                setState(() {});
              },
            ),
            Text(allTranslations.text('main_body'))
          ],
        ),
      ),
    );
  }
}
