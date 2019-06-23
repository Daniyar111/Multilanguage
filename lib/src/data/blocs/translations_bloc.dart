import 'dart:async';
import 'dart:ui';

import 'bloc_provider.dart';
import '../../utils/global_translations.dart';
import '../../utils/preferences.dart';

class TranslationsBloc implements BlocBase{

  StreamController<String> _languageController = StreamController<String>.broadcast();
  Stream<String> get currentLanguage => _languageController.stream;

  StreamController<Locale> _localeController = StreamController<Locale>();
  Stream<Locale> get currentLocale => _localeController.stream;


  void setNewLanguage(String newLanguage) async {

    // Save the selected language as a user preferences
    await preferences.setPreferredLanguage(newLanguage);

    // Notification the translations module about the new language
    await allTranslations.setNewLanguage(newLanguage);

    _languageController.sink.add(newLanguage);
    _localeController.sink.add(allTranslations.locale);

  }

  @override
  void dispose() {
    _languageController?.close();
    _localeController?.close();
  }
}