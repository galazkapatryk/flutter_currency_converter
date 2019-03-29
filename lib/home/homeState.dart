import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:meta/meta.dart';

class HomeState {
  final Currency inputCurrency;
  final Currency outputCurrency;

  HomeState({@required this.inputCurrency, @required this.outputCurrency});

  factory HomeState.initial() {
    return HomeState(inputCurrency: Currency(), outputCurrency: Currency());
  }

}
