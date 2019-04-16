import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:meta/meta.dart';

class HomeState {
  final Currency inputCurrency;
  final Currency outputCurrency;
  final List<Currency> possibleCurrencies;
  final double inputCurrencyCount;
  final double currenciesFactor;

  double getOutputCurrencyCount() {
    print(inputCurrencyCount);
    return inputCurrencyCount * currenciesFactor;
  }

  HomeState(
      {@required this.inputCurrency,
      @required this.outputCurrency,
      @required this.possibleCurrencies,
      @required this.inputCurrencyCount,
      @required this.currenciesFactor});

  factory HomeState.initial() {
    print("home state initial");
    return HomeState(
        inputCurrency: Currency.initial(),
        outputCurrency: Currency.initial(),
        possibleCurrencies: [],
        inputCurrencyCount: 1,
        currenciesFactor: 1);
  }
}
