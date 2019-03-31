class CurrencyDto {
  String currencyCode;
  String currencyName;
  String currencyIcon;

  CurrencyDto({this.currencyCode, this.currencyName, this.currencyIcon});

  CurrencyDto.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    currencyName = json['currencyName'];
    currencyIcon = json['currencyIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['currencyName'] = this.currencyName;
    data['currencyIcon'] = this.currencyIcon;
    return data;
  }
}