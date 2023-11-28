import 'package:realm/realm.dart';
part 'feed.g.dart';

@RealmModel()
class $Feed {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late String link;
  late String origin;
  late String? access;
  late DateTime? lastUpdate;
  late DateTime? lastAccessCheck;
  late DateTime? expiration;

  @override
  String toString() {
    return 'id: $id, name: $name, origin: $origin, link: $link, lastUpdate: $lastUpdate';
  }
}
