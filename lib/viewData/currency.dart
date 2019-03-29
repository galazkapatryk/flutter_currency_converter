class Currency {
  final String currencyTitle;
  final double currencyQuantity;
  final String currencyComparasion;

  Currency(
      {this.currencyTitle, this.currencyQuantity, this.currencyComparasion});

  factory Currency.initial() {
    return Currency(
      currencyTitle: "initial",
      currencyQuantity: 0,
      currencyComparasion: "initial"
    );
  }
}
