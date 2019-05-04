import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/app/appState.dart';
import 'package:flutter_currency_converter/home/homeView.dart';
import 'package:flutter_currency_converter/home/homeViewModel.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
      body: StoreConnector<AppState, HomeViewModel>(
        converter: (store) => HomeViewModel.create(store),
        builder: (context, HomeViewModel viewModel) =>
            HomeView(viewModel: viewModel),
      ),
    );
  }
}
