import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/utils/global_translations.dart';

void main() async {

  await allTranslations.init();

  runApp(App());
}