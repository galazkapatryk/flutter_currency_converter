import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/app/fonts.dart';
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
                Color.fromRGBO(255, 119, 95, 1),
                Color.fromRGBO(255, 150, 131, 1)
              ])),
            ),
      ),
    );
  }
}

class _HomeViewModel {
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

  _HomeViewModel(
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

  factory _HomeViewModel.create(Store<AppState> store) {
    _onRateChanged(double rate) {
      print("dispatch action ${store.state.homeState}");
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

    return _HomeViewModel(
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

class HomeView extends StatefulWidget {
  final _HomeViewModel viewModel;

  HomeView({Key key, this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print(viewModel.possibleCurrency.indexOf(viewModel.inputCurrency));
    return _HomeViewState(TextEditingController(text: '${viewModel.inputCurrencyCount}'),
        PageController(initialPage:viewModel.possibleCurrency.indexOf(viewModel.inputCurrency)),
    PageController(initialPage:viewModel.possibleCurrency.indexOf(viewModel.outputCurrency)));
  }
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final TextEditingController inputValueController;
  final PageController inputCurrencyPageController;
  final PageController outputCurrencyPageController;
  AnimationController _reverseAnimationController;
  bool enableScrollListener = true;

  _HomeViewState(this.inputValueController, this.inputCurrencyPageController,
      this.outputCurrencyPageController);

  void onInputTextChange() {
    widget.viewModel.onCurrencyCountChanged(
        double.tryParse(inputValueController.text.replaceAll(',', '.')) ?? '0');
  }

  void reversePages() {
    var outputCurrencyPosition = outputCurrencyPageController.page.toInt();
    var inputCurrencyPosition = inputCurrencyPageController.page.toInt();
    if (outputCurrencyPosition != inputCurrencyPosition &&
        inputCurrencyPageController.viewportFraction == 1.0 &&
        outputCurrencyPageController.viewportFraction == 1.0) {
      print('reverse start');
      enableScrollListener = false;
      inputCurrencyPageController.animateToPage(outputCurrencyPosition,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
      outputCurrencyPageController
          .animateToPage(inputCurrencyPosition,
              duration: Duration(milliseconds: 100), curve: Curves.linear)
          .whenComplete(() => {
                enableScrollListener = true,
                currencyPairChanged(
                    widget.viewModel.possibleCurrency[
                        inputCurrencyPageController.page.toInt()],
                    widget.viewModel.possibleCurrency[
                        outputCurrencyPageController.page.toInt()]),
                print('reverse complete')
              });
      _reverseAnimationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    repository.getPossibleCurrencies(context).then((response) {
      widget.viewModel.onCurrencyListDownloaded(response);
    });
    inputValueController.addListener(onInputTextChange);
    _reverseAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _reverseAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _reverseAnimationController.value = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: 80,
        ),
        Text(
          "${widget.viewModel.inputCurrency.currencyCode} count:",
          style: TextStyle(
              fontSize: 18, fontFamily: LatoRegular, color: Colors.white),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22, fontFamily: LatoBold, color: Colors.white),
          decoration: InputDecoration.collapsed(),
          controller: inputValueController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 40,
        ),
        Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcATop,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: RadialGradient(colors: [
                  Color.fromRGBO(255, 119, 95, 1),
                  Color.fromRGBO(255, 150, 131, 1)
                ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 150,
                    height: 150,
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: inputCurrencyPageController,
                      itemBuilder: (context, position) {
                        return CurrencyWidget(
                            currency:
                                widget.viewModel.possibleCurrency[position]);
                      },
                      itemCount: widget.viewModel.possibleCurrency.length,
                      onPageChanged: changeInputCurrency,
                    )),
                Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
                            animation: _reverseAnimationController,
                            child: GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 5),
                                            color: Colors.black12,
                                            blurRadius: 20)
                                      ]),
                                  height: 40,
                                  child: Image.asset('assets/reverse.png')),
                              onTap: reversePages,
                            ),
                            builder: (BuildContext context, Widget _widget) {
                              return Transform.rotate(
                                  angle:
                                      _reverseAnimationController.value * 3.6,
                                  child: _widget);
                            })),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Rate: \n",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: LatoRegular,
                                color: Colors.white)),
                        TextSpan(
                            text: widget.viewModel.currencyRate
                                .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: LatoBold,
                                color: Colors.white))
                      ]),
                    ),
                  ],
                ),
                SizedBox(
                    width: 150,
                    height: 150,
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: outputCurrencyPageController,
                      itemBuilder: (context, position) {
                        return CurrencyWidget(
                            currency:
                                widget.viewModel.possibleCurrency[position]);
                      },
                      itemCount: widget.viewModel.possibleCurrency.length,
                      onPageChanged: changeOutputCurrency,
                    )),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Text(
          "${widget.viewModel.outputCurrencyCount.toStringAsFixed(2)} ${widget.viewModel.outputCurrency.currencyCode}",
          style: TextStyle(
              fontSize: 18, fontFamily: LatoBold, color: Colors.white),
        )
      ])),
    );
  }

  changeInputCurrency(int position) {
    currencyPairChanged(widget.viewModel.possibleCurrency[position],
        widget.viewModel.outputCurrency);
  }

  changeOutputCurrency(int position) {
    currencyPairChanged(widget.viewModel.inputCurrency,
        widget.viewModel.possibleCurrency[position]);
  }

  currencyPairChanged(Currency inputCurrency, Currency outputCurrency) {
    if (enableScrollListener)
      widget.viewModel.onCurrencyPairChanged(inputCurrency, outputCurrency);
  }
}
