import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/AppState.dart';
import 'package:flutter_currency_converter/app/Globals.dart';
import 'package:flutter_currency_converter/home/HomeState.dart';
import 'package:flutter_currency_converter/redux/actions/Actions.dart';
import 'package:flutter_currency_converter/viewData/Currency.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    repository.getRates("USD", ["PLN"]).then((response) {
      print(response.rates.first.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _HomeViewModel>(
        converter: (store) => _HomeViewModel.create(store),
        builder: (context, _HomeViewModel viewModel) =>
            HomeView(viewModel: viewModel),
      ),
    );
  }
}

class _HomeViewModel {
  final Currency inputCurrency;
  final Currency outputCurrency;
  final Function(Currency) onInputCurrencyChanged;
  final Function(Currency) onOutputCurrencyChanged;

  _HomeViewModel(
      {this.inputCurrency,
      this.outputCurrency,
      this.onInputCurrencyChanged,
      this.onOutputCurrencyChanged});

  factory _HomeViewModel.create(Store<AppState> store) {
    _onInputCurrencyChanged(Currency inputCurrency) {
      store.dispatch(ChangeInputCurrency(inputCurrency));
    }

    _onOutputCurrencyChanged(Currency outputCurrency) {
      store.dispatch(ChangeOutputCurrency(outputCurrency));
    }

    return _HomeViewModel(
        inputCurrency: store.state.homeState.inputCurrency,
        outputCurrency:store.state.homeState.outputCurrency,
        onInputCurrencyChanged: _onInputCurrencyChanged,
        onOutputCurrencyChanged: _onOutputCurrencyChanged);
  }
}

class HomeView extends StatefulWidget {
  final _HomeViewModel viewModel;

  const HomeView({Key key, this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    repository.getRates("USD", ["PLN"]).then((response) {
      widget.viewModel.onInputCurrencyChanged(
          Currency()..currencyTitle = response.rates[0].currencyCode);
      print(response.rates.first.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.viewModel.inputCurrency.currencyTitle),
    );
  }
}
