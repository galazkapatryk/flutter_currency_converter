import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/home/HomeState.dart';

class AppState {
  final HomeState homeState;

  AppState({@required this.homeState});

  factory AppState.initial() {
    return AppState(homeState: HomeState.initial());
  }

  AppState copyWith({HomeState homeState}) {
    return AppState(homeState: homeState);
  }
}
