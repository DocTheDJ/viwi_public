import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:viwi/BL/drawer_screen_provider.dart';
import 'package:viwi/pages/order_detail.dart';
import 'package:viwi/pages/order_list.dart';
import 'package:viwi/pages/overview.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/utils/unassigned.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._feed) {
    if (_feed != null) {
      _orders = globals.realm.query<Order>(r'feed.id == $0 SORT(date DESC)', [_feed?.id]).toList();
      final b = globals.realm.query<StateDB>(r'feed.id == $0', [_feed?.id]).toList();
      _filters = [...startingFilters, ...b.map((e) => ButtonHelper(name: e.name, value: e))];
    }
  }

  Widget _currentScreen = OrderList();
  ScreenEnums _screenEnums = ScreenEnums.orderlist;
  final Feed? _feed;
  List<Order>? _orders;
  List<ButtonHelper>? _filters;
  int? _activeFilter = 1;
  double _progress = 0;

  Isolate? _i;

  Widget get currentScreen => _currentScreen;
  bool get isScreenOverview => _screenEnums == ScreenEnums.overview;
  bool get isScreenList => _screenEnums == ScreenEnums.orderlist;
  bool get isScreenDetial => _screenEnums == ScreenEnums.orderdetail;
  List<Order>? get orders => _orders;
  List<ButtonHelper>? get filters => _filters;
  int? get orderLength => orders?.length;
  Feed? get thisFeed => _feed;
  double get progress => _progress;
  List<ButtonHelper> get startingFilters => [ButtonHelper(name: 'Přehled', value: null), ButtonHelper(name: 'Všechny', value: 0)];

  void advanceProgress(double amount) {
    _progress += amount;
    notifyListeners();
  }

  Future<void> startRefresh(context) async {
    _i ??= await runImport(_feed!, (amount, text) => advanceProgress(amount), () {
      setActive(_activeFilter);
      globals.realm.write(() {
        _feed!.lastUpdate = DateTime.now();
        globals.realm.add<Feed>(_feed!, update: true);
      });
      _progress = 0;
      _i = null;
    }, context, false);
  }

  void setActive(int? position, {bool notify = true}) {
    _activeFilter = position;
    if (_activeFilter != null && _filters != null) {
      final tmp = _filters![_activeFilter!].value;
      if (tmp == null) {
        changeCurrentScreen(ScreenEnums.overview, notify: false);
      } else {
        if (tmp.runtimeType == StateDB) {
          _orders = globals.realm.query<Order>(r'feed.id == $0 AND state.id == $1 SORT(date DESC)', [_feed?.id, tmp.id]).toList();
        } else {
          _orders = globals.realm.query<Order>(r'feed.id == $0 SORT(date DESC)', [_feed?.id]).toList();
        }
        isScreenOverview ? changeCurrentScreen(ScreenEnums.orderlist, notify: false) : null;
      }
    }
    notify ? notifyListeners() : null;
  }

  void changeCurrentScreen(ScreenEnums screen, {bool notify = true}) {
    switch (screen) {
      case ScreenEnums.overview:
        setCurrentScreen(const Overview());
        break;
      case ScreenEnums.orderlist:
        setCurrentScreen(OrderList());
        break;
      case ScreenEnums.orderdetail:
        setCurrentScreen(const OrderDetails());
        break;
      default:
        setCurrentScreen(const Overview());
        break;
    }
    screenEnums(screen, notify: false);
    if (notify) notifyListeners();
  }

  void setCurrentScreen(Widget newscreen, {bool notify = true}) {
    _currentScreen = newscreen;
    if (notify) notifyListeners();
  }

  void screenEnums(ScreenEnums screen, {bool notify = true}) {
    _screenEnums = screen;
    if (notify) notifyListeners();
  }

  void refreshOrders() async {
    setActive(_activeFilter);
  }

  void search(String? wanted) async {
    if (wanted == null || wanted == '') {
      setActive(_activeFilter);
    } else {
      setActive(_activeFilter, notify: false);
      _orders = _orders!
          .where((element) =>
              element.code.startsWith(wanted) ||
              (element.email?.contains(wanted) ?? false) ||
              element.price.toString().startsWith(wanted) ||
              (element.addresses.first.name?.toLowerCase().contains(wanted) ?? false))
          .toList();
      notifyListeners();
    }
  }

  bool isActive(int? position) => _activeFilter == position;
}
