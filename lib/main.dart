import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/utils/global_translations.dart';

void main() async {

  // Initialize the translations module
  await allTranslations.init();

  runApp(App());
}