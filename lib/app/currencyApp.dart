import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/app/buildType.dart';
import 'package:flutter_currency_converter/app/globals.dart';
import 'package:flutter_currency_converter/data/apiRepository.dart';
import 'package:flutter_currency_converter/data/mockRepository.dart';
import 'package:flutter_currency_converter/home/home.dart';
import 'package:flutter_currency_converter/redux/reducers/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CurrencyApp extends StatelessWidget {
  final BuildType buildType;
  final Store store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initial(),
  );

  CurrencyApp({Key key, @required this.buildType});

  @override
  Widget build(BuildContext context) {
    setupRepository(buildType);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Home(),
      ),
    );
  }

  void setupRepository(BuildType buildType) {
    if (buildType == BuildType.api)
      repository = ApiRepository();
    else if (buildType == BuildType.mock) repository = MockRepository();
  }
}
