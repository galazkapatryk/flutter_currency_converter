import 'package:flutter_currency_converter/data/RatesResponse.dart';
import 'package:flutter_currency_converter/data/Repository.dart';

class MockRepository extends Repository {
  @override
  Future<RatesResponse> getRates(
      String baseCurrencyCode, List<String> outputCurrenciesCodes) {
    return Future.error(Error());
  }
}
