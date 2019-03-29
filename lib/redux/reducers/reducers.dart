import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/home/homeState.dart';
import 'package:flutter_currency_converter/redux/actions/actions.dart';
import 'package:redux/redux.dart';

HomeState changeInputCurrencyReducer(
    HomeState state, ChangeInputCurrency action) {
  print("reducer change input");
  return HomeState(
      inputCurrency: action.inputCurrency,
      outputCurrency: state.outputCurrency);
}

final Reducer<HomeState> homeStateReducers = combineReducers<HomeState>([
  new TypedReducer<HomeState, ChangeInputCurrency>(changeInputCurrencyReducer),
]);

AppState appStateReducer(AppState state, action) {
  print("app state reducer");
  return AppState(homeState: homeStateReducers(state.homeState, action));
}
