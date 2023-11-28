import 'package:flutter/material.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/globals.dart' as globals;

class OrderDetailProvider extends ChangeNotifier {
  int _page = 0;
  bool _showItems = true;
  bool _isChanging = false;

  int? get page => _page;
  bool get showItems => _showItems;
  List<StateDB> states(Feed feed) => globals.realm.query<StateDB>(r'feed.id == $0', [feed.id]).toList();
  bool get isChanging => _isChanging;

  void setPage(int position) async {
    _page = position;
    notifyListeners();
  }

  void swapChanging() async {
    _isChanging = !_isChanging;
    notifyListeners();
  }

  void swapPart() async {
    _showItems = !_showItems;
    notifyListeners();
  }

  void pageJumpTo(PageController controller) {
    controller.jumpToPage(_page);
  }

  void increment(int max, {PageController? controller}) async {
    _page = (_page + 1) % max;
    controller != null ? pageJumpTo(controller) : null;
    notifyListeners();
  }

  void decrement(int max, {PageController? controller}) async {
    _page = (_page - 1) % max;
    controller != null ? pageJumpTo(controller) : null;
    notifyListeners();
  }

  void updateSeen(Order order) async {
    if (order.isnew) {
      globals.realm.write(() {
        order.isnew = false;
        globals.realm.add<Order>(order, update: true);
      });
    }
  }
}
