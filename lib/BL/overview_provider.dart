// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:realm/realm.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/utils/delete_feed.dart';
import 'package:viwi/utils/library/helpers/base_helper.dart';

class OverviewProvider extends ChangeNotifier {
  OverviewProvider(BuildContext context) {
    _checkLastVersion(context);
  }

  List<Feed> _feeds = globals.realm.all<Feed>().toList();
  RealmResults<Order> _day = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 1))]);
  RealmResults<Order> _week = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 7))]);
  RealmResults<Order> _month = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 30))]);
  RealmResults<Order> _year = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 365))]);
  AppUpdateInfo? _updateInfo;

  CountSum get day => CountSum(_day);
  CountSum get week => CountSum(_week);
  CountSum get month => CountSum(_month);
  CountSum get year => CountSum(_year);
  List<Feed> get feeds => _feeds;

  bool get updateAvailable => _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable;

  static const _feedQuery = 'feed.id == \$0';

  CountSum dayFeed(ObjectId feed) => CountSum(_day.query(_feedQuery, [feed]));
  CountSum weekFeed(ObjectId feed) => CountSum(_week.query(_feedQuery, [feed]));
  CountSum monthFeed(ObjectId feed) => CountSum(_month.query(_feedQuery, [feed]));
  CountSum yearFeed(ObjectId feed) => CountSum(_year.query(_feedQuery, [feed]));

  void refresh() {
    _feeds = globals.realm.all<Feed>().toList();
    _day = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 1))]);
    _week = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 7))]);
    _month = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 30))]);
    _year = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 365))]);
    notifyListeners();
  }

  void delete(Feed feed) {
    deleteFeed(feed, refresh);
  }

  void _checkLastVersion(BuildContext context) async {
    // _rightVersion = await BaseHelper.checkLastVersion();
    InAppUpdate.checkForUpdate().then((value) {
      _updateInfo = value;
      notifyListeners();
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}

class CountSum {
  CountSum(RealmResults<Order> coll) {
    collection = coll;
    setOther();
  }

  void setOther() async {
    count = collection.length;
    sum = collection.fold(0.0, (previousValue, element) => previousValue + element.price).round();
  }

  late RealmResults<Order> collection;
  late int count;
  late int sum;
}
