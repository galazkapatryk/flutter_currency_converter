import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/buildType.dart';
import 'package:flutter_currency_converter/app/currencyApp.dart';

void main() => runApp(new CurrencyApp(
      buildType: BuildType.api
    ));
