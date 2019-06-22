import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = 'MyApplication_';
const List<String> _supportedLanguages = ['en', 'ru'];
Future<SharedPreferences> _preferences = SharedPreferences.getInstance();


GlobalTranslations allTranslations = new GlobalTranslations();


class GlobalTranslations{

  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;


  static final GlobalTranslations _translations = new GlobalTranslations._internal();

  factory GlobalTranslations(){
    return _translations;
  }

  GlobalTranslations._internal();

  // one-time initialization
  Future<Null> init([String language]) async {
    if(_locale == null){
      await setNewLanguage(language);
    }
    return null;
  }


  Iterable<Locale> supportedLocales() => _supportedLanguages.map<Locale>(
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


  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }

  setPreferredLanguage(String language) async {
    return _setApplicationSavedInformation('language', language);
  }

  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = false]) async {

    String language = newLanguage;
    if(language == null){
      language = await getPreferredLanguage();
    }

    if(language == ''){
      language = 'en';
    }

    _locale = Locale(language, '');

    String jsonContent = await rootBundle.loadString('locale/i18n_${_locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent);

    if(saveInPrefs){
      await setPreferredLanguage(language);
    }

    if(_onLocaleChangedCallback != null){
      _onLocaleChangedCallback();
    }

    return null;
  }


  set onLocaleChangedCallback(VoidCallback callback){
    _onLocaleChangedCallback = callback;
  }


  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences preferences = await _preferences;

    return preferences.getString(_storageKey + name) ?? '';
  }

  Future<bool> _setApplicationSavedInformation(String name, String value) async {
    final SharedPreferences preferences = await _preferences;

    return preferences.setString(_storageKey + name, value);
  }

}

