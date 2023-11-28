import 'package:realm/realm.dart';

import '../feed/feed.dart';
part 'item.g.dart';

class ItemFields {
  static const String fieldType = 'type';
  static const String fieldName = 'name';
  static const String fieldAmount = 'amount';
  static const String fieldPrice = 'price';
  static const String fieldCode = 'code';
  static const String fieldCurrency = 'currency';
  static const String fieldFeed = 'feed';
  static const String fieldExternalId = 'externalId';

  static const Map<String, dynamic> properties = {
    fieldType: 'string?',
    fieldName: 'string?',
    fieldAmount: 'int',
    fieldPrice: 'double',
    fieldCode: 'string?',
    fieldCurrency: 'string?',
    fieldFeed: 'Feed?',
    fieldExternalId: 'int?',
  };
}

@RealmModel()
class $Item {
  @PrimaryKey()
  late ObjectId id;

  late String? type;
  late String? name;
  late int amount;
  late double price;
  late String? code;
  late String? currency;
  late int? externalId;
  late $Feed? feed;

  // @Ignored()
  // static Map<String, dynamic> properties = {
  //   'type': {'type': 'string?', 'name': 'type'},
  //   'name': {'type': 'string?', 'name': 'name'},
  //   'amount': {'type': 'int', 'name': 'amount'},
  //   'price': {'type': 'double', 'name': 'price'},
  //   'code': {'type': 'string?', 'name': 'code'},
  //   'currency': {'type': 'string?', 'name': 'currency'},
  //   'feed': {'type': 'Feed?', 'name': 'feed'},
  //   'eid': {'type': 'int?', 'name': 'externalId'},
  // };

  // static String getTableName() {
  //   return 'Item';
  // }

  @Ignored()
  static List<String> wanted = [ItemFields.fieldType, ItemFields.fieldName, ItemFields.fieldAmount, ItemFields.fieldPrice, ItemFields.fieldCode];

  @override
  String toString() {
    return '{type: $type, name: $name, amount: $amount, price: $price, code: $code, currency: $currency, externalId: $externalId}';
  }

  @Ignored()
  Item fromMap(Map<String, dynamic> data) {
    return Item(ObjectId(), int.parse(data[ItemFields.fieldAmount]), double.parse((data[ItemFields.fieldPrice]).toString().replaceAll(',', '.')),
        code: data[ItemFields.fieldCode],
        currency: (data[ItemFields.fieldCurrency]) ?? 'CZK',
        type: data[ItemFields.fieldType],
        name: data[ItemFields.fieldName],
        externalId: int.tryParse(data[ItemFields.fieldExternalId] ?? 'f'),
        feed: data[ItemFields.fieldFeed]);
  }

  @Ignored()
  (String, List) getQuery(Map<String, dynamic> data, List<String> wanted) {
    String output = '';
    List listOut = [];
    wanted.asMap().forEach((key, value) {
      output += '$value == \$$key AND ';
      if (ItemFields.properties[value] == 'int') {
        listOut.add(int.tryParse(data[value]));
      } else {
        if (ItemFields.properties[value] == 'double') {
          listOut.add(double.tryParse(data[value].toString().replaceAll(',', '.')));
        } else {
          listOut.add(data[value]);
        }
      }
    });
    // for (var w in wanted) {
    //   if (data[w] == null) {
    //     output += '$w == nil';
    //   } else {
    //     output += '$w == "${data[w]}"';
    //   }
    //   output += ' AND ';
    // }
    return (output.substring(0, output.length - 5), listOut);
  }
}
