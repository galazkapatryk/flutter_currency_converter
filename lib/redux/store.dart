import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/redux/middleware/local_storage_middleware.dart';
import 'package:flutter_currency_converter/redux/reducers/reducers.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Store<AppState>> createStore() async {
  var state = await loadStateFromPrefs();
  return Store<AppState>(appStateReducer,
      initialState: state,
      middleware: [localStoreMiddleware]);
}
