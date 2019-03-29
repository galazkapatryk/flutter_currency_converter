class RatesResponse {
  String base;
  List<Rate> rates;
  String date;

  RatesResponse({this.base, this.rates, this.date});

  RatesResponse.fromJson(
      Map<String, dynamic> json, List<String> outputCurrenciesCodes) {
    base = json['base'];
    rates = outputCurrenciesCodes.map((currencyCode) {
      return Rate(currencyCode, (json['rates'] as Map<dynamic,dynamic>)[currencyCode]);
    }).toList();
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base'] = this.base;
    data['rates'] = this.rates;
    data['date'] = this.date;
    return data;
  }
}

class Rates {
  List<Rate> rates = List();

  Rates.fromJson(
      Map<dynamic, dynamic> json, List<String> outputCurrenciesCodes) {
    outputCurrenciesCodes.forEach((currencyCode) {
      rates.add(Rate(currencyCode, json[currencyCode]));
    });
  }
}

class Rate {
  String currencyCode;
  double value;

  Rate(this.currencyCode, this.value);
}
