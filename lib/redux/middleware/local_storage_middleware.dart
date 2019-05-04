import 'dart:convert';

import 'package:flutter_currency_converter/app/appState.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

void localStoreMiddleware(Store<AppState> store, action, NextDispatcher next) {
  saveStateToPrefs(store.state);
  next(action);
}

String APP_STATE_KEY = "APP_STATE";

Future<AppState> loadStateFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  try {
    var stateString = preferences.getString(APP_STATE_KEY);
    Map stateMap = json.decode(stateString);
    return AppState.fromJson(stateMap);
  } catch (ex) {
    return AppState.initial();
  }
}

void saveStateToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var stateString = json.encode(state.toJson());
  await preferences.setString(APP_STATE_KEY, stateString);
}
