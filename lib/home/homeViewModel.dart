import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/app/globals.dart';
import 'package:flutter_currency_converter/redux/actions/actions.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final Currency inputCurrency;
  final Currency outputCurrency;
  final double inputCurrencyCount;
  final double outputCurrencyCount;
  final double currencyRate;
  final List<Currency> possibleCurrency;
  final Function(Currency, Currency) onCurrencyPairChanged;
  final Function(List<Currency>) onCurrencyListDownloaded;
  final Function(double) onCurrencyRateChanged;
  final Function(double) onCurrencyCountChanged;

  HomeViewModel(
      {this.inputCurrency,
      this.outputCurrency,
      this.inputCurrencyCount,
      this.currencyRate,
      this.onCurrencyPairChanged,
      this.onCurrencyListDownloaded,
      this.onCurrencyRateChanged,
      this.onCurrencyCountChanged,
      this.possibleCurrency,
      this.outputCurrencyCount});

  factory HomeViewModel.create(Store<AppState> store) {
    _onRateChanged(double rate) {
      store.dispatch(ChangeCurrencyRate(rate));
    }

    _calculateRate() {
      repository
          .getRates(store.state.homeState.inputCurrency.currencyCode,
              store.state.homeState.outputCurrency.currencyCode)
          .then((response) {
        _onRateChanged(response.rate.value);
      });
    }

    _onCurrencyPairChanged(Currency inputCurrency, Currency outputCurrency) {
      store.dispatch(ChangeCurrencyPair(inputCurrency, outputCurrency));
      _calculateRate();
    }

    _onCurrencyListDownloaded(List<Currency> currencies) {
      store.dispatch(CurrencyListDownloaded(currencies));
    }

    _onCurrencyCountChanged(double count) {
      store.dispatch(ChangeCurrencyCount(count));
    }

    return HomeViewModel(
        inputCurrency: store.state.homeState.inputCurrency,
        outputCurrency: store.state.homeState.outputCurrency,
        inputCurrencyCount: store.state.homeState.inputCurrencyCount,
        possibleCurrency: store.state.homeState.possibleCurrencies,
        currencyRate: store.state.homeState.currenciesFactor,
        outputCurrencyCount: store.state.homeState.getOutputCurrencyCount(),
        onCurrencyPairChanged: _onCurrencyPairChanged,
        onCurrencyListDownloaded: _onCurrencyListDownloaded,
        onCurrencyCountChanged: _onCurrencyCountChanged,
        onCurrencyRateChanged: _onRateChanged);
  }
}
