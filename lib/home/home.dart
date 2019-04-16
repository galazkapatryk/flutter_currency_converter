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
    return Scaffold(
      body: StoreConnector<AppState, _HomeViewModel>(
        converter: (store) => _HomeViewModel.create(store),
        builder: (context, _HomeViewModel viewModel) => Container(
              child: HomeView(viewModel: viewModel),
              decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                Color.fromRGBO(101, 191, 191, 1),
                Color.fromRGBO(145, 216, 216, 1)
              ])),
            ),
      ),
    );
  }
}

class _HomeViewModel {
  final Currency inputCurrency;
  final Currency outputCurrency;
  final double outputCurrencyCount;
  final double currencyRate;
  final List<Currency> possibleCurrency;
  final Function(Currency) onInputCurrencyChanged;
  final Function(Currency) onOutputCurrencyChanged;
  final Function(List<Currency>) onCurrencyListDownloaded;
  final Function(double) onCurrencyRateChanged;
  final Function(double) onCurrencyCountChanged;

  _HomeViewModel(
      {this.inputCurrency,
      this.outputCurrency,
      this.currencyRate,
      this.onInputCurrencyChanged,
      this.onOutputCurrencyChanged,
      this.onCurrencyListDownloaded,
      this.onCurrencyRateChanged,
      this.onCurrencyCountChanged,
      this.possibleCurrency,
      this.outputCurrencyCount});

  factory _HomeViewModel.create(Store<AppState> store) {
    _onRateChanged(double rate) {
      print("on rate changed $rate");
      store.dispatch(ChangeCurrencyRate(rate));
    }

    _calculateRate() {
      print(
          'input currency:${store.state.homeState.inputCurrency.currencyCode}');
      print(
          'output currency:${store.state.homeState.outputCurrency.currencyCode}');
      repository
          .getRates(store.state.homeState.inputCurrency.currencyCode,
              store.state.homeState.outputCurrency.currencyCode)
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

    _onCurrencyCountChanged(double count) {
      print('change count');
      print(count);
      store.dispatch(ChangeCurrencyCount(count));
    }

    print('create viewmodel');
    return _HomeViewModel(
        inputCurrency: store.state.homeState.inputCurrency,
        outputCurrency: store.state.homeState.outputCurrency,
        possibleCurrency: store.state.homeState.possibleCurrencies,
        currencyRate: store.state.homeState.currenciesFactor,
        outputCurrencyCount: store.state.homeState.getOutputCurrencyCount(),
        onInputCurrencyChanged: _onInputCurrencyChanged,
        onOutputCurrencyChanged: _onOutputCurrencyChanged,
        onCurrencyListDownloaded: _onCurrencyListDownloaded,
        onCurrencyCountChanged: _onCurrencyCountChanged,
        onCurrencyRateChanged: _onRateChanged);
  }
}

class HomeView extends StatefulWidget {
  final _HomeViewModel viewModel;

  HomeView({Key key, this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  TextEditingController inputValueController = TextEditingController(text: '1');
  PageController inputCurrencyPageController = PageController(initialPage: 0);
  PageController outputCurrencyPageController = PageController(initialPage: 0);

  void onInputTextChange() {
    widget.viewModel.onCurrencyCountChanged(
        double.tryParse(inputValueController.text) ?? '0');
  }

  void reversePages() {
    print('${outputCurrencyPageController.page}');
    var outputCurrencyPosition = outputCurrencyPageController.page.toInt();
    var inputCurrencyPosition = inputCurrencyPageController.page.toInt();
    inputCurrencyPageController.animateToPage(outputCurrencyPosition,
        duration: Duration(milliseconds: 200), curve: Curves.linear);
    outputCurrencyPageController.animateToPage(inputCurrencyPosition,
        duration: Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    repository.getPossibleCurrencies(context).then((response) {
      widget.viewModel.onCurrencyListDownloaded(response);
    });
    inputValueController.addListener(onInputTextChange);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
      Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Container(
            width: 300,
            height: 150,
            child: PageView.builder(
              controller: inputCurrencyPageController,
              itemBuilder: (context, position) {
                return CurrencyWidget(
                    currency: widget.viewModel.possibleCurrency[position]);
              },
              itemCount: widget.viewModel.possibleCurrency.length,
              onPageChanged: inputCurrencyChanged,
            )),
        Container(
            width: 300,
            height: 150,
            child: PageView.builder(
              controller: outputCurrencyPageController,
              itemBuilder: (context, position) {
                return CurrencyWidget(
                    currency: widget.viewModel.possibleCurrency[position]);
              },
              itemCount: widget.viewModel.possibleCurrency.length,
              onPageChanged: outputCurrencyChanged,
            ))
      ])),
      Container(
          alignment: Alignment.center,
          child: GestureDetector(
            child:
                Container(height: 50, child: Image.asset('assets/reverse.png')),
            onTap: reversePages,
          ))
    ]));
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
