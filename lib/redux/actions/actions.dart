import 'package:flutter_currency_converter/viewData/currency.dart';

class ChangeCurrencyPair{
  final Currency inputCurrency;
  final Currency outputCurrency;

  ChangeCurrencyPair(this.inputCurrency, this.outputCurrency);
}

class ChangeCurrencyRate {
  final double currencyRate;

  ChangeCurrencyRate(this.currencyRate);
}

class ChangeCurrencyCount {
  final double currencyCount;

  ChangeCurrencyCount(this.currencyCount);
}

class CurrencyListDownloaded {
  final List<Currency> currencies;

  CurrencyListDownloaded(this.currencies);
}
