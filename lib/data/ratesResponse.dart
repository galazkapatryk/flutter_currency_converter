class RatesResponse {
  String base;
  Rate rate;
  String date;

  RatesResponse({this.base, this.rate, this.date});

  RatesResponse.fromJson(
      Map<String, dynamic> json, String outputCurrencyCode) {
    base = json['base'];
    rate = Rate(outputCurrencyCode, (json['rates'] as Map<dynamic,dynamic>)[outputCurrencyCode]);
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base'] = this.base;
    data['rate'] = this.rate;
    data['date'] = this.date;
    return data;
  }
}

class Rate {
  String currencyCode;
  double value;

  Rate(this.currencyCode, this.value);
}
