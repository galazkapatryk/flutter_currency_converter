import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:meta/meta.dart';

class HomeState {
  final Currency inputCurrency;
  final Currency outputCurrency;
  final List<Currency> possibleCurrencies;

  HomeState({@required this.inputCurrency, @required this.outputCurrency,@required this.possibleCurrencies});

  factory HomeState.initial() {
    print("home state initial");
    return HomeState(inputCurrency: Currency.initial(), outputCurrency: Currency(),possibleCurrencies: []);
  }

}
