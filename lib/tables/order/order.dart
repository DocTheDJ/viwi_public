import 'package:realm/realm.dart';
import 'package:viwi/tables/state/state.dart';
import 'package:viwi/tables/feed/feed.dart';
import 'package:viwi/tables/address/address.dart';
import 'package:viwi/tables/item/item.dart';
part 'order.g.dart';

class OrderFields {
  static const String fieldCode = 'code';
  static const String fieldDate = 'date';
  static const String fieldEmail = 'email';
  static const String fieldPrice = 'price';
  static const String fieldCurrency = 'currency';
  static const String fieldState = 'state';
  static const String fieldFeed = 'feed';
  static const String fieldAddresses = 'addresses';
  static const String fieldItems = 'items';
  static const String fieldIsNew = 'isnew';
  static const String fieldNote = 'note';
  static const String fieldReferer = 'referer';
  static const String fieldExternalId = 'externalId';
}

@RealmModel()
class $Order {
  @PrimaryKey()
  late ObjectId id;

  late String code;
  late DateTime date;
  late String? email;
  // late String? phone;
  late double price;
  late String currency;
  late $StateDB? state;
  late $Feed? feed;
  late List<$Address> addresses;
  late List<$Item> items;
  late bool isnew = true;
  late String? note;
  late String? referer;
  late int? externalId;

  // @Ignored()
  // static Map<String, dynamic> properties = {
  //   'code': {'type': 'string', 'name': 'code'},
  //   'date': {'type': 'date', 'name': 'date'},
  //   'email': {'type': 'string', 'name': 'email'},
  //   // 'phone': {'type': 'string', 'name': 'phone'},
  //   'price': {'type': 'double', 'name': 'price'},
  //   'currency': {'type': 'string', 'name': 'currency'},
  //   'state': {'type': 'State', 'name': 'state'},
  //   'items': {'type': 'Item[]', 'name': 'items'},
  //   'addresses': {'type': 'Address[]', 'name': 'addresses'},
  //   'feed': {'type': 'Feed', 'name': 'feed'},
  //   'note': {'type': 'string', 'name': 'note'},
  //   'referer': {'type': 'string', 'name': 'referer'},
  //   'eid': {'type': 'int?', 'name': 'externalId'}
  // };

  // static String getTableName() {
  //   return 'Order';
  // }

  @Ignored()
  Order fromMap(Map<String, dynamic> data) {
    return Order(
      ObjectId(),
      data[OrderFields.fieldCode].toString(),
      DateTime.parse(data[OrderFields.fieldDate]),
      double.parse((data[OrderFields.fieldPrice]).toString().replaceAll(',', '.')),
      (data[OrderFields.fieldCurrency] ?? 'CZK'),
      state: data[OrderFields.fieldState],
      feed: data[OrderFields.fieldFeed],
      addresses: data[OrderFields.fieldAddresses],
      items: data[OrderFields.fieldItems],
      email: data[OrderFields.fieldEmail],
      // phone: data[$Order.properties['phone']['name']],
      note: data[OrderFields.fieldNote],
      referer: data[OrderFields.fieldReferer],
      externalId: data[OrderFields.fieldExternalId],
    );
  }

  @override
  String toString() {
    return '$code, $date, $email, $price, $currency, $state, $addresses';
  }
}
