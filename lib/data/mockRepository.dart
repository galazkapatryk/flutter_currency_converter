import 'package:flutter_currency_converter/data/ratesResponse.dart';
import 'package:flutter_currency_converter/data/repository.dart';

class MockRepository extends Repository {
  @override
  Future<RatesResponse> getRates(
      String baseCurrencyCode, List<String> outputCurrenciesCodes) {
    return Future.error(Error());
  }
}
