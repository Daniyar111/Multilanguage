import 'package:flutter/material.dart';

import '../utils/global_translations.dart';



class OtherScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('other_screen.title')),
      ),
      body: Container(
        child: Center(
          child: Text(localizations.formatMonthYear(DateTime.now())),
        ),
      ),
    );
  }
}
