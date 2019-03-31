import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/data/ratesResponse.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';

abstract class Repository {
  //JUST EXAMPLE
  Future<RatesResponse> getRates(
      String baseCurrencyCode, List<String> outputCurrenciesCodes);
  Future<List<Currency>> getPossibleCurrencies(BuildContext context);
}
