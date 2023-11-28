library viwi.globals;

import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:viwi/tables/state/state.dart';
import 'package:viwi/tables/feed/feed.dart';
import 'package:viwi/tables/address/address.dart';
import 'package:viwi/tables/item/item.dart';
import 'package:viwi/tables/order/order.dart';
// import 'package:viwi/utils/unassigned.dart';

Realm realm = Realm(Configuration.local(
  [Feed.schema, Address.schema, Item.schema, StateDB.schema, Order.schema],
  schemaVersion: 13,
));

Color blue = const Color(0xFF00D1FF);
Color red = const Color(0xFFe24666);

// MyColorScheme colorScheme = MyColorScheme(blue, Colors.white, Colors.white, Colors.black, const Color(0xFFF8F8F8));
