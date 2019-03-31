import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';

class CurrencyWidget extends StatelessWidget {
  final Currency currency;

  CurrencyWidget({Key key, this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
               fit: BoxFit.none, image: NetworkImage(currency.iconUrl))),
      )
    ],);
  }
}
