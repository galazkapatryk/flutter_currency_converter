import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/app/globals.dart';
import 'package:flutter_currency_converter/redux/actions/actions.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:flutter_currency_converter/widgets/currencyWidget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    print("build home");
    return Scaffold(
      body: StoreConnector<AppState, _HomeViewModel>(
          converter: (store) => _HomeViewModel.create(store),
          builder: (context, _HomeViewModel viewModel) => Container(
                color: Colors.white,
                child: HomeView(viewModel: viewModel),
              )),
    );
  }
}

class _HomeViewModel {
  final Currency inputCurrency;
  final Currency outputCurrency;
  final double currencyRate;
  final List<Currency> possibleCurrency;
  final Function(Currency) onInputCurrencyChanged;
  final Function(Currency) onOutputCurrencyChanged;
  final Function(List<Currency>) onCurrencyListDownloaded;
  final Function(double) onCurrencyRateChanged;

  _HomeViewModel(
      {this.inputCurrency,
      this.outputCurrency,
      this.currencyRate,
      this.onInputCurrencyChanged,
      this.onOutputCurrencyChanged,
      this.onCurrencyListDownloaded,
      this.onCurrencyRateChanged,
      this.possibleCurrency});

  factory _HomeViewModel.create(Store<AppState> store) {
    _onRateChanged(double rate) {
      print("on rate changed $rate");
      store.dispatch(ChangeCurrencyRate(rate));
    }
    _calculateRate() {
      print('input currency:${store.state.homeState.inputCurrency.currencyCode}');
      print('output currency:${store.state.homeState.outputCurrency.currencyCode}');
      repository
          .getRates(store.state.homeState.inputCurrency.currencyCode, store.state.homeState.outputCurrency.currencyCode)
          .then((response) {
        _onRateChanged(response.rate.value);
      });
    }
    _onInputCurrencyChanged(Currency inputCurrency) {
      print('change input currency');
      store.dispatch(ChangeInputCurrency(inputCurrency));
      _calculateRate();
    }

    _onOutputCurrencyChanged(Currency outputCurrency) {
      print('change output currency');
      store.dispatch(ChangeOutputCurrency(outputCurrency));
      _calculateRate();
    }

    _onCurrencyListDownloaded(List<Currency> currencies) {
      store.dispatch(CurrencyListDownloaded(currencies));
    }


    print('create viewmodel');
    return _HomeViewModel(
        inputCurrency: store.state.homeState.inputCurrency,
        outputCurrency: store.state.homeState.outputCurrency,
        possibleCurrency: store.state.homeState.possibleCurrencies,
        currencyRate: store.state.homeState.currenciesFactor,
        onInputCurrencyChanged: _onInputCurrencyChanged,
        onOutputCurrencyChanged: _onOutputCurrencyChanged,
        onCurrencyListDownloaded: _onCurrencyListDownloaded,
        onCurrencyRateChanged: _onRateChanged);
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
    repository.getPossibleCurrencies(context).then((response) {
      widget.viewModel.onCurrencyListDownloaded(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: 150,
          height: 75,
          child: Center(
              child: PageView.builder(
            itemBuilder: (context, position) {
              return CurrencyWidget(
                  currency: widget.viewModel.possibleCurrency[position]);
            },
            itemCount: widget.viewModel.possibleCurrency.length,
            onPageChanged: inputCurrencyChanged,
          ))),
      Align(
          alignment: Alignment.center,
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: '1',
            textAlign: TextAlign.center,
            decoration: InputDecoration.collapsed(),
          )),
      Align(
          alignment: Alignment.center,
          child: Text(
              '${widget.viewModel.inputCurrency.currencyCode}->${widget.viewModel.outputCurrency.currencyCode}->${widget.viewModel.currencyRate}')),
      Container(
          width: 150,
          height: 75,
          child: Center(
              child: PageView.builder(
            itemBuilder: (context, position) {
              return CurrencyWidget(
                  currency: widget.viewModel.possibleCurrency[position]);
            },
            itemCount: widget.viewModel.possibleCurrency.length,
            onPageChanged: outputCurrencyChanged,
          )))
    ]);
  }

  inputCurrencyChanged(int position) {
    widget.viewModel
        .onInputCurrencyChanged(widget.viewModel.possibleCurrency[position]);
  }

  outputCurrencyChanged(int position) {
    widget.viewModel
        .onOutputCurrencyChanged(widget.viewModel.possibleCurrency[position]);
  }
}
