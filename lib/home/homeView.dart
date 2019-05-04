import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_currency_converter/app/fonts.dart';
import 'package:flutter_currency_converter/app/globals.dart';
import 'package:flutter_currency_converter/app/style.dart';
import 'package:flutter_currency_converter/home/homeViewModel.dart';
import 'package:flutter_currency_converter/viewData/currency.dart';
import 'package:flutter_currency_converter/widgets/currencyWidget.dart';

class HomeView extends StatefulWidget {
  final HomeViewModel viewModel;

  HomeView({Key key, this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState(
        TextEditingController(text: '${viewModel.inputCurrencyCount}'),
        PageController(
            initialPage: findCurrencyIndex(
                viewModel.possibleCurrency, viewModel.inputCurrency)),
        PageController(
            initialPage: findCurrencyIndex(
                viewModel.possibleCurrency, viewModel.outputCurrency)));
  }

  findCurrencyIndex(List<Currency> currencies, Currency currency) {
    return currencies.indexWhere(
        (Currency element) => element.currencyCode == currency.currencyCode);
  }
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final TextEditingController inputValueController;
  final PageController inputCurrencyPageController;
  final PageController outputCurrencyPageController;
  var focusNode = FocusNode();
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
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(focusNode));
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(colors: Styles.backgroundGradients)),
      child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: 80,
        ),
        Text(
          "${widget.viewModel.inputCurrency.currencyCode} count:",
          style: TextStyle(
              fontSize: 24, fontFamily: LatoRegular, color: Colors.white),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 150,
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                focusNode: focusNode,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24, fontFamily: LatoBold, color: Colors.white),
                decoration: InputDecoration.collapsed(),
                controller: inputValueController,
                keyboardType: TextInputType.number,
              )),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.all(5),
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
                SizedBox(
                    width: 45,
                    child: Column(
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
                                builder:
                                    (BuildContext context, Widget _widget) {
                                  return Transform.rotate(
                                      angle: _reverseAnimationController.value *
                                          3.6,
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
                    )),
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
          height: 30,
        ),
        Text(
          "${widget.viewModel.outputCurrencyCount.toStringAsFixed(2)} ${widget.viewModel.outputCurrency.currencyCode}",
          style: TextStyle(
              fontSize: 24, fontFamily: LatoBold, color: Colors.white),
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
