import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:meta/meta.dart';

class HomeState {
  Currency inputCurrency;
  Currency outputCurrency;
  List<Currency> possibleCurrencies;
  double inputCurrencyCount;
  double currenciesFactor;

  double getOutputCurrencyCount() {
    return inputCurrencyCount * currenciesFactor;
  }

  HomeState(
      {@required this.inputCurrency,
      @required this.outputCurrency,
      @required this.possibleCurrencies,
      @required this.inputCurrencyCount,
      @required this.currenciesFactor});

  factory HomeState.initial() {
    return HomeState(
        inputCurrency: Currency.initial(),
        outputCurrency: Currency.initial(),
        possibleCurrencies: [],
        inputCurrencyCount: 1,
        currenciesFactor: 1);
  }

  HomeState.fromJson(Map<String, dynamic> json) {
    inputCurrency = Currency.fromJson(json['inputCurrency']);
    outputCurrency = Currency.fromJson(json['outputCurrency']);
    if (json['possibleCurrencies'] != null) {
      possibleCurrencies = List<Currency>();
      json['possibleCurrencies'].forEach((v) {
        possibleCurrencies.add(Currency.fromJson(v));
      });
    }
    inputCurrencyCount = json['inputCurrencyCount'];
    currenciesFactor = json['currenciesFactor'];
  }
  Map<String,dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['inputCurrency'] = inputCurrency.toJson();
    data['outputCurrency'] = outputCurrency.toJson();
    if (this.possibleCurrencies != null) {
      data['possibleCurrencies'] =
          this.possibleCurrencies.map((v) => v.toJson()).toList();
    }
    data['inputCurrencyCount'] = inputCurrencyCount;
    data['currenciesFactor'] = currenciesFactor;
    return data;
  }
}
