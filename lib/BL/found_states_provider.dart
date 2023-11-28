import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viwi/BL/orders_provider.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/utils/unassigned.dart';

class FoundStatesProvider extends ChangeNotifier {
  FoundStatesProvider(this._feed) {
    _states = globals.realm.query<StateDB>(r'feed.id == $0', [_feed.id]).toList();
  }
  final Feed _feed;

  late List<StateDB> _states;
  bool _loading = true;
  double _progress = 0;
  String? _message;

  List<StateDB> get states => _states;
  bool get loading => _loading;
  double get progress => _progress;
  Feed get feed => _feed;
  String get message => _message ?? '';

  void setProgress(double amount, {bool notify = true}) {
    _progress += amount;
    notify ? notifyListeners() : null;
  }

  void addProgressMessage(String message, {bool notify = true}) {
    _message = message;
    notify ? notifyListeners() : null;
  }

  void updateProgress(double amount, String message) {
    setProgress(amount, notify: false);
    addProgressMessage(message, notify: false);
    notifyListeners();
  }

  void startImport(BuildContext context) {
    runImport(_feed, updateProgress, () {
      _progress = 0;
      _loading = false;
      notifyListeners();
      context.read<OrdersProvider>().refreshOrders();
    }, context, true);
  }
}
