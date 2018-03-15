import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';

import 'state.dart';

class ProfileViewModel extends BaseViewModel<ProfileState> {
  final UserDataService _dataService;

  ProfileViewModel(
      this._dataService,
      Stream<Null> onErrorRetryButtonPressed,) {

    onErrorRetryButtonPressed.listen(_retryLoading);
  }

  @override
  ProfileState initialState() => new ProfileState.loading();

  @override
  Stream<ProfileState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  _loadData() async {
    try {
      setState(new ProfileState.loading());

      final beers = await _dataService.fetchUserBeers();

      setState(new ProfileState.load(beers));
    } catch (e) {
      debugPrint(e.toString());

      setState(new ProfileState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }
}