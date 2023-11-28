import 'package:flutter/material.dart';
import 'package:viwi/pages/order_list.dart';
import 'package:viwi/pages/overview.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/globals.dart' as globals;

class DrawerScreenProvider extends ChangeNotifier {
  Widget _currentScreen = const Overview();
  ScreenEnums _screenEnums = ScreenEnums.overview;
  List<Feed> _feeds = globals.realm.all<Feed>().toList();
  int? _activeFeed;

  List<Feed> get feeds => _feeds;
  Feed? get activeFeed => _activeFeed == null ? null : _feeds[_activeFeed!];
  int get length => _feeds.length;
  int? get activePosition => _activeFeed;

  void refreshfeeds() {
    _feeds = globals.realm.all<Feed>().toList();
    notifyListeners();
  }

  Feed getWanted(int position) => _feeds[position];

  void changeActive(int? position, {bool notify = true}) {
    _activeFeed = position;
    notify ? notifyListeners() : null;
  }

  Widget get currentScreen => _currentScreen;

  void setCurrentScreen(Widget newscreen, {bool notify = true}) {
    _currentScreen = newscreen;
    notify ? notifyListeners() : null;
  }

  void screenEnums(ScreenEnums screen, {bool notify = true}) {
    _screenEnums = screen;
    notify ? notifyListeners() : null;
  }

  bool get isScreenOverview => _screenEnums == ScreenEnums.overview;

  bool get isScreenList => _screenEnums == ScreenEnums.orderlist;

  bool get isFeedChosen => activeFeed != null;

  void changeCurrentScreen(ScreenEnums screen, {bool notify = true}) {
    switch (screen) {
      case ScreenEnums.overview:
        setCurrentScreen(const Overview());
        break;
      case ScreenEnums.orderlist:
        setCurrentScreen(const OrdersPage());
        break;
      default:
        setCurrentScreen(const Overview());
        break;
    }
    screenEnums(screen, notify: false);
    notify ? notifyListeners() : null;
  }

  void changeToScreen(ScreenEnums screen, int? position) {
    changeCurrentScreen(screen, notify: false);
    changeActive(position, notify: false);
    notifyListeners();
  }
}

enum ScreenEnums { overview, orderlist, orderdetail }
