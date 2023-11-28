import 'package:realm/realm.dart';
import 'package:viwi/tables/feed/feed.dart';
part 'state.g.dart';

class StateFields {
  static const String fieldName = 'name';
  static const String fieldColorState = 'colorstate';
  static const String fieldFeed = 'feed';
  static const String fieldExternalId = 'externalId';
}

@RealmModel()
class $StateDB {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late int colorState = 0x1FFFFFFF;
  late int? externalId;
  late $Feed? feed;

  // @Ignored()
  // static Map<String, dynamic> properties = {
  //   'name': {'type': 'string', 'name': 'name'},
  //   'feed': {'type': 'Feed', 'name': 'feed'},
  //   'colorState': {'type': 'int', 'name': 'colorState'},
  //   'eid': {'type': 'int?', 'name': 'externalId'},
  // };

  // static String getTableName() {
  //   return 'State';
  // }

  @override
  String toString() {
    return '$name, $colorState';
  }

  @Ignored()
  StateDB fromMap(Map<String, dynamic> data) {
    final color = (data[StateFields.fieldColorState] != '' && data[StateFields.fieldColorState] != null)
        ? 'FF${data[StateFields.fieldColorState].toString().substring(1)}'
        : '1FFFFFFF';
    return StateDB(ObjectId(), data[StateFields.fieldName],
        feed: data[StateFields.fieldFeed], externalId: int.tryParse(data[StateFields.fieldExternalId] ?? 'f'), colorState: int.parse(color, radix: 16));
  }
}
