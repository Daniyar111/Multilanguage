import 'package:shared_preferences/shared_preferences.dart';


const String _storageKey = 'Appli_';
const String _kDefaultLanguage = 'en';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();



class Preferences{

  Preferences._internal();

  static final Preferences _preferences = Preferences._internal();

  factory Preferences(){
    return _preferences;
  }



  Future<String> _getSavedInformation(String name) async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(_storageKey + name) ?? '';
  }


  Future<bool> _setSavedInformation(String name, String value) async {
    final SharedPreferences preferences = await _prefs;
    return preferences.setString(_storageKey + name, value);
  }



  getPreferredLanguage() async {
    return _getSavedInformation('language');
  }

  setPreferredLanguage(String language) async {
    return _setSavedInformation('language', language);
  }

  String get defaultLanguage => _kDefaultLanguage;


}