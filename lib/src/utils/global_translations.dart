import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


const List<String> _kSupportedLanguages = ['en', 'ru'];

GlobalTranslations allTranslations = new GlobalTranslations();


class GlobalTranslations{

  Locale _locale;
  Map pickLists;
  Map<dynamic, dynamic> _localizedValues;
  Map<String, String> _cache = {};


  GlobalTranslations._internal();

  static final GlobalTranslations _translations = new GlobalTranslations._internal();

  factory GlobalTranslations(){
    return _translations;
  }


  // one-time initialization
  Future<Null> init([String language]) async {
    if(_locale == null){
      await setNewLanguage(language);
    }
    return null;
  }


  Iterable<Locale> supportedLocales() => _kSupportedLanguages.map<Locale>(
      (language){
        return new Locale(language, '');
      }
  );


  String text(String key){
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '$key not found'
        : _localizedValues[key];
  }


  String get currentLanguage => _locale == null ? '' : _locale.languageCode;

  Locale get locale => _locale;


  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = false]) async {

    String language = newLanguage;

    if(language == ''){
      language = 'en';
    }

    _locale = Locale(language, '');

    String jsonContent = await rootBundle.loadString('locale/i18n_${_locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent);



    return null;
  }


}

