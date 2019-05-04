import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/home/homeState.dart';

class AppState {
  HomeState homeState;

  AppState({@required this.homeState});

  factory AppState.initial() {
    return AppState(homeState: HomeState.initial());
  }

  AppState copyWith({HomeState homeState}) {
    return AppState(homeState: homeState);
  }
  AppState.fromJson(Map<String, dynamic> json) {
    homeState = json['homeState'] != null
        ? HomeState.fromJson(json['homeState'])
        : HomeState.initial();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeState != null) {
      data['homeState'] = this.homeState.toJson();
    }
    return data;
  }
}
