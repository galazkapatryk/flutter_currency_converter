import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/BuildType.dart';
import 'package:flutter_currency_converter/app/CurrencyApp.dart';

void main() => runApp(new CurrencyApp(
      buildType: BuildType.api
    ));
