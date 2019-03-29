import 'package:flutter_currency_converter/data/ratesResponse.dart';

abstract class Repository {
  //JUST EXAMPLE
  Future<RatesResponse> getRates(
      String baseCurrencyCode, List<String> outputCurrenciesCodes);
}
