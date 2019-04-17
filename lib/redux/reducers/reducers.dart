import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/home/homeState.dart';
import 'package:flutter_currency_converter/redux/actions/actions.dart';
import 'package:redux/redux.dart';

HomeState changeCurrencyPair(HomeState state, ChangeCurrencyPair action) {
  return HomeState(
      inputCurrency: action.inputCurrency,
      outputCurrency: action.outputCurrency,
      possibleCurrencies: state.possibleCurrencies,
      currenciesFactor: state.currenciesFactor,
      inputCurrencyCount: state.inputCurrencyCount);
}

HomeState getPossibleCurrenciesReducer(
    HomeState state, CurrencyListDownloaded action) {
  return HomeState(
      inputCurrency: state.inputCurrency,
      outputCurrency: state.outputCurrency,
      possibleCurrencies: action.currencies,
      currenciesFactor: state.currenciesFactor,
      inputCurrencyCount: state.inputCurrencyCount);
}

HomeState changeCurrencyRate(HomeState state, ChangeCurrencyRate action) {
  return HomeState(
      inputCurrency: state.inputCurrency,
      outputCurrency: state.outputCurrency,
      possibleCurrencies: state.possibleCurrencies,
      currenciesFactor: action.currencyRate,
      inputCurrencyCount: state.inputCurrencyCount);
}

HomeState changeCurrencyCount(HomeState state, ChangeCurrencyCount action) {
  return HomeState(
      inputCurrency: state.inputCurrency,
      outputCurrency: state.outputCurrency,
      possibleCurrencies: state.possibleCurrencies,
      currenciesFactor: state.currenciesFactor,
      inputCurrencyCount: action.currencyCount);
}

final Reducer<HomeState> homeStateReducers = combineReducers<HomeState>([
  new TypedReducer<HomeState, CurrencyListDownloaded>(
      getPossibleCurrenciesReducer),
  new TypedReducer<HomeState, ChangeCurrencyPair>(
      changeCurrencyPair),
  new TypedReducer<HomeState, ChangeCurrencyRate>(changeCurrencyRate),
  new TypedReducer<HomeState, ChangeCurrencyCount>(changeCurrencyCount)
]);

AppState appStateReducer(AppState state, action) {
  return AppState(homeState: homeStateReducers(state.homeState, action));
}
