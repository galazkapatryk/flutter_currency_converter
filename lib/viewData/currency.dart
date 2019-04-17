class Currency {
  String currencyTitle;
  String currencyCode;
  String iconUrl;

  Currency({this.currencyTitle, this.iconUrl, this.currencyCode});

  Currency.fromJson(Map<String, dynamic> json) {
    currencyTitle = json['currencyTitle'];
    currencyCode = json['currencyCode'];
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyTitle'] = this.currencyTitle;
    data['currencyCode'] = this.currencyCode;
    data['iconUrl'] = this.iconUrl;
    return data;
  }

  factory Currency.initial() {
    return Currency(
        currencyTitle: "American Dollar", iconUrl: "", currencyCode: "USD");
  }

  factory Currency.fromDto(
      String currencyTitle, String currencyCode, String currencyIcon) {
    return Currency(
        currencyTitle: currencyTitle,
        iconUrl: currencyIcon,
        currencyCode: currencyCode);
  }
}
