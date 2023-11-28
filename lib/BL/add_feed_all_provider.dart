import 'package:flutter/material.dart';

class AddFeedAllProvider extends ChangeNotifier {
  String? _string;
  bool _loaded = false;
  String? _token;
  String? _name;

  bool get loaded => _loaded;
  String get token => _token ?? '';
  String get name => _name ?? '';

  void setMasterString(String incoming) {
    _string = incoming;
    _loaded = true;
    notifyListeners();
  }

  void masterSplit() {
    final parts = _string?.split('|');
    if (parts != null) {
      _token = parts[0];
      _name = parts[1];
    }
  }
}

enum FeedOrigins { shoptet, presta6, presta8 }

extension FeedOriginsVals on FeedOrigins {
  int? get value {
    switch (this) {
      case FeedOrigins.shoptet:
        return 0;
      case FeedOrigins.presta8:
        return 1;
      case FeedOrigins.presta6:
        return 2;
      default:
        return null;
    }
  }

  static FeedOrigins? fromValue(int value) {
    switch (value) {
      case 0:
        return FeedOrigins.shoptet;
      case 1:
        return FeedOrigins.presta8;
      case 2:
        return FeedOrigins.presta6;
      default:
        return null;
    }
  }
}
