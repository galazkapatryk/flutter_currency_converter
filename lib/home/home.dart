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
  final List<Currency> possibleCurrency;
  final Function(Currency) onInputCurrencyChanged;
  final Function(Currency) onOutputCurrencyChanged;
  final Function(List<Currency>) onCurrencyListDownloaded;

  _HomeViewModel(
      {this.inputCurrency,
      this.outputCurrency,
      this.onInputCurrencyChanged,
      this.onOutputCurrencyChanged,
      this.onCurrencyListDownloaded,
      this.possibleCurrency});

  factory _HomeViewModel.create(Store<AppState> store) {
    print("create viewmodel");
    _onInputCurrencyChanged(Currency inputCurrency) {
      print("store dispatch");
      store.dispatch(ChangeInputCurrency(inputCurrency));
    }

    _onOutputCurrencyChanged(Currency outputCurrency) {
      store.dispatch(ChangeOutputCurrency(outputCurrency));
    }

    _onCurrencyListDownloaded(List<Currency> currencies) {
      store.dispatch(CurrencyListDownloaded(currencies));
    }

    return _HomeViewModel(
        inputCurrency: store.state.homeState.inputCurrency,
        outputCurrency: store.state.homeState.outputCurrency,
        possibleCurrency: store.state.homeState.possibleCurrencies,
        onInputCurrencyChanged: _onInputCurrencyChanged,
        onOutputCurrencyChanged: _onOutputCurrencyChanged,
        onCurrencyListDownloaded: _onCurrencyListDownloaded);
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
    print("home child ${widget.viewModel.inputCurrency.currencyTitle}");
    return Column(
        children:[Container(
          height: 150,
            child:Center(child:PageView.builder(
          itemBuilder: (context, position) {
            return CurrencyWidget(
                currency: widget.viewModel.possibleCurrency[position]);
          },
          itemCount: widget.viewModel.possibleCurrency.length,
        ))),Align(alignment: Alignment.center,child:TextFormField(
          keyboardType: TextInputType.number,
          initialValue: '1',
          textAlign: TextAlign.center,
          decoration: InputDecoration.collapsed(),
        ))]);
  }
}
