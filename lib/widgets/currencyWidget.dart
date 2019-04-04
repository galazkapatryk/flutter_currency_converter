import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';

class CurrencyWidget extends StatelessWidget {
  final Currency currency;

  CurrencyWidget({Key key, this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.yellow, Colors.yellowAccent]),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child:Padding(padding: EdgeInsets.all(20),child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.none,
                          image: NetworkImage(currency.iconUrl))),
                ),
                Text('${currency.currencyTitle} (${currency.currencyCode})')
              ],
            )));
  }
}
