import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/translations_model.dart';
import 'preferences.dart';


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
  Future<Null> init() async {
    if(_locale == null){
      await setNewLanguage();
    }
    return null;
  }

  // Returns the list of supported locales
  Iterable<Locale> supportedLocales() => _kSupportedLanguages.map<Locale>(
      (language){
        return new Locale(language, '');
      }
  );

  /// Return the translation that corresponds to the [key]
  ///
  /// The [key] might be a sequence of [key].[sub-key].[sub-key]
  ///
  /// If [values] is defined, allows replacement of a template value
  ///
  /// If [plural] is defined, looks for the following definitions:
  ///   '=0': if [plural == 0] takes this string
  ///   '=1': if [plural == 1] takes this string
  ///   '>1': if [plural > 1] takes this string
  ///
  /// If [gender] is defined, looks for the following definitions:
  ///   'male': if [gender == GlobalTranslationsGender.male] takes this string
  ///   'female': if [gender == GlobalTranslationsGender.female] takes this string
  ///   'other': if [gender == GlobalTranslationsGender.other] takes this string
  ///
  /// Examples:
  /// text('Value: {{myVal}}, Name: {{myName}}', values: { 'myVal': 123, 'myName': 'Didier'})
  ///
  /// text('demoPage.tests.string_plural', plural: 1)
  ///
  /// text('demoPage.tests.string_gender', gender: GlobalTranslationsGender.male)
  ///
  /// Of course combinations of (plural or gender) and values are possible

  String text(String key, {Map<String, dynamic> values, num plural, GlobalTranslationsGender gender}) {

    // [gender] and [plural] cannot be set at the same time
    assert((){
      if (gender != null && plural != null){
        throw FlutterError('Gender and plural cannot be defined at the same time');
      }
      return true;
    }());


    // Processes the template replacements if any
    String _processTemplate(String template){
      if (values == null){
        return template;
      }

      String output = template;

      values.forEach((String key, dynamic value){
        if (value != null && (value is String || value is num)){
          output = output.replaceAll('{{$key}}', value.toString());
        }
      });

      return output;
    }

    // Return the requested string
    String string = '$key not found';

    if (_localizedValues != null) {
      // Check if the requested [key] is in the cache
      if (_cache[key] != null){
        return _processTemplate(_cache[key]);
      }

      // Iterate the key until found or not
      bool found = true;
      Map<dynamic, dynamic> _values = _localizedValues;
      List<String> _keyParts = key.split('.');
      int _keyPartsLen = _keyParts.length;
      int index = 0;
      int lastIndex = _keyPartsLen - 1;

      while(index < _keyPartsLen && found){
        var value = _values[_keyParts[index]];

        if (value == null) {
          // Not found
          found = false;
          break;
        }

        // Check if we deal with plural or gender
        if ((plural != null || gender != null) && index == lastIndex && value is Map){
          if (plural != null){
            if (plural == 0 && value.containsKey("=0")){
              string = value["=0"];
              found = true;
            }
            else if (plural == 1 && value.containsKey("=1")){
              string = value["=1"];
              found = true;
            }
            else if (plural > 1 && value.containsKey(">1")){
              string = value[">1"];
              found = true;
            }
            if (found){
              break;
            }
          }
          else if (gender != null){
            if (gender == GlobalTranslationsGender.male && value.containsKey("male")){
              string = value["male"];
              found = true;
            }
            else if (gender == GlobalTranslationsGender.female && value.containsKey("female")){
              string = value["female"];
              found = true;
            }
            else if (gender == GlobalTranslationsGender.other && value.containsKey("other")){
              string = value["other"];
              found = true;
            }
          }
        }

        // Check if we found the requested key
        if (value is String && index == lastIndex){
          string = value;

          // Add to cache
          _cache[key] = string;
          break;
        }

        // go to next subKey
        _values = value;
        index++;
      }
    }
    return _processTemplate(string);
  }


  String get currentLanguage => _locale == null ? '' : _locale.languageCode;

  Locale get locale => _locale;


  Future<Null> setNewLanguage([String newLanguage]) async {
    String language = newLanguage;
    if (language == null){
      language = await preferences.getPreferredLanguage();
    }

    // If not in the preferences, get the current locale
    if (language == ''){
      String currentLocale = Platform.localeName.toLowerCase();
      if (currentLocale.length > 2){
        if (currentLocale[2] == "-" || currentLocale[2] == "_"){
          language = currentLocale.substring(0, 2);
        }
      }
    }

    if (!_kSupportedLanguages.contains(language)){
      language = "";
    }

    // Set the locale
    if (language == ""){
      language = preferences.defaultLanguage;
    }
    _locale = Locale(language, "");

    // Load the language strings
    String jsonContent = await rootBundle.loadString("assets/locale/i18n_${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    // Clear the cache
    _cache = {};

    return null;
  }



  // Number to String
  // Stringify a value, based on a format (also based on the current Locale)
  String valueToString(num value, {GlobalTranslationsNumberFormat format = GlobalTranslationsNumberFormat.normal, int numberOfDecimals = 2,}){
    NumberFormat numberFormat;

    switch(format){
      case GlobalTranslationsNumberFormat.currency:
        numberFormat = NumberFormat.currency(locale: _locale.languageCode);
        break;

      case GlobalTranslationsNumberFormat.compact:
        numberFormat = NumberFormat.compact(locale: _locale.languageCode);
        break;

      case GlobalTranslationsNumberFormat.compactCurrency:
        numberFormat = NumberFormat.compactCurrency(locale: _locale.languageCode);
        break;

      case GlobalTranslationsNumberFormat.compactLong:
        numberFormat = NumberFormat.compactLong(locale: _locale.languageCode);
        break;

      case GlobalTranslationsNumberFormat.compactSimpleCurrency:
        numberFormat = NumberFormat.compactSimpleCurrency(locale: _locale.languageCode);
        break;

      case GlobalTranslationsNumberFormat.fixedNumberOfDecimals:
        final String decimals = "0000000000000000".substring(0, numberOfDecimals);
        numberFormat = NumberFormat("0.$decimals", _locale.languageCode);
        break;

      default:
        numberFormat = NumberFormat(null, _locale.languageCode);
    }

    return numberFormat.format(value);
  }

}

