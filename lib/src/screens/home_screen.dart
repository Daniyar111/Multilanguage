import 'package:flutter/material.dart';

import '../utils/global_translations.dart';
import '../data/blocs/bloc_provider.dart';
import '../data/blocs/translations_bloc.dart';
import '../models/translations_model.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final TranslationsBloc translationsBloc = BlocProvider.of<TranslationsBloc>(context);

    final String pageTitle = allTranslations.text('homeScreen.title');

    final String otherLanguage = allTranslations.currentLanguage == 'ru' ? 'en' : 'ru';

    final String buttonCaption = allTranslations.text('homeScreen.buttons.${otherLanguage == 'en' ? 'english' : 'russian'}');

    String stringSize = allTranslations.valueToString(1.8, format: GlobalTranslationsNumberFormat.normal, numberOfDecimals: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('=> $buttonCaption'),
              onPressed: (){
                translationsBloc.setNewLanguage(otherLanguage);
              },
            ),
            Divider(),
            Text(allTranslations.text(
              'homeScreen.tests.string_values',
              values: {
                'name': 'Daniyar',
                'country': allTranslations.text('homeScreen.values.my_country')
              }
            )),
            Divider(),
            Text(allTranslations.text(
              'homeScreen.tests.string_plural',
              plural: 3
            )),
            Divider(),
            Text(allTranslations.text(
              'homeScreen.tests.string_plural',
              plural: 0
            )),
            Divider(),
            Text(allTranslations.text(
              'homeScreen.tests.string_gender',
              gender: GlobalTranslationsGender.male
            )),
            Divider(),
            Text(allTranslations.text(
              'homeScreen.tests.string_gender_values',
              gender: GlobalTranslationsGender.male,
              values: {
                'size': stringSize + 'm'
              }
            )),
            Divider(),
            RaisedButton(
              child: Text(allTranslations.text('homeScreen.buttons.selectDate')),
              onPressed: () => _selectDate(context),
            ),
            Divider(),
            RaisedButton(
              child: Text('==> Next Screen'),
              onPressed: () => Navigator.of(context).pushNamed('/other_screen'),
            )
          ],
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2020)
    );
  }
}

