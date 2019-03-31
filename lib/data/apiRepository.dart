import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/data/currencyDto.dart';
import 'package:flutter_currency_converter/data/ratesResponse.dart';
import 'package:flutter_currency_converter/data/repository.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:http/http.dart' as http;

class ApiRepository extends Repository {
  @override
  Future<RatesResponse> getRates(String baseCurrencyCode,
      List<String> outputCurrenciesCodes) async {
    final response = await http.get(
        'https://api.exchangeratesapi.io/latest?base=$baseCurrencyCode&symbols=${outputCurrenciesCodes
            .join(',')}');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return RatesResponse.fromJson(
          json.decode(response.body), outputCurrenciesCodes);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<List<Currency>> getPossibleCurrencies(BuildContext context) {
   return DefaultAssetBundle.of(context).loadString("assets/currencies.json").then((
        json) async {
      List<dynamic> list = jsonDecode(json);
      List<CurrencyDto> listCurrencyDto = list.map((dynamic) {return CurrencyDto.fromJson(dynamic);} ).toList();
      List<Currency> listCurrency = listCurrencyDto.map((currencyDto) {
        return Currency.fromDto(
            currencyDto.currencyName, currencyDto.currencyCode,
            currencyDto.currencyIcon);
      }).toList();
      return listCurrency;
  });
  }
}
