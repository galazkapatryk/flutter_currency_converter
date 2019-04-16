import 'package:flutter_currency_converter/viewData/currency.dart';

class ChangeInputCurrency {
  final Currency inputCurrency;

  ChangeInputCurrency(this.inputCurrency);
}

class ChangeOutputCurrency {
  final Currency outputCurrency;

  ChangeOutputCurrency(this.outputCurrency);
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
