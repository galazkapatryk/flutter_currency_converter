import 'dart:convert';

import 'package:flutter_currency_converter/data/RatesResponse.dart';
import 'package:flutter_currency_converter/data/Repository.dart';
import 'package:http/http.dart' as http;

class ApiRepository extends Repository {
  @override
  Future<RatesResponse> getRates(
      String baseCurrencyCode, List<String> outputCurrenciesCodes) async {
    final response =
        await http.get('https://api.exchangeratesapi.io/latest?base=$baseCurrencyCode&symbols=${outputCurrenciesCodes.join(',')}');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return RatesResponse.fromJson(json.decode(response.body),outputCurrenciesCodes);
    } else {
      print(response.body);
      throw Exception('Failed to load post');
    }
  }
}
