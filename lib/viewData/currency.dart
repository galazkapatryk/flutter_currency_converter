class Currency {
  final String currencyTitle;
  final String currencyCode;
  final String iconUrl;

  Currency({this.currencyTitle, this.iconUrl, this.currencyCode});

  factory Currency.initial() {
    return Currency(currencyTitle: "American Dollar", iconUrl: "", currencyCode: "USD");
  }

  factory Currency.fromDto(
      String currencyTitle, String currencyCode, String currencyIcon) {
    return Currency(
        currencyTitle: currencyTitle,
        iconUrl: currencyIcon,
        currencyCode: currencyCode);
  }
}
