import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_currency_converter/data/ratesResponse.dart';
import 'package:flutter_currency_converter/data/repository.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';

class MockRepository extends Repository {
  @override
  Future<RatesResponse> getRates(
      String baseCurrencyCode, String outputCurrencyCode) {
    return Future.error(Error());
  }

  @override
  Future<List<Currency>> getPossibleCurrencies(BuildContext context) {
    return Future.error(Error());
  }

}
