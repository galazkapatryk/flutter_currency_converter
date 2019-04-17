import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_currency_converter/app/buildType.dart';
import 'package:flutter_currency_converter/app/currencyApp.dart';
import 'package:flutter_currency_converter/redux/store.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  var store = await createStore();
  runApp(new CurrencyApp(
    buildType: BuildType.api,
    store: store,
  ));
}
