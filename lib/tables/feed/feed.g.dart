// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Feed extends $Feed with RealmEntity, RealmObjectBase, RealmObject {
  Feed(
    ObjectId id,
    String name,
    String link,
    String origin, {
    String? access,
    DateTime? lastUpdate,
    DateTime? lastAccessCheck,
    DateTime? expiration,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'link', link);
    RealmObjectBase.set(this, 'origin', origin);
    RealmObjectBase.set(this, 'access', access);
    RealmObjectBase.set(this, 'lastUpdate', lastUpdate);
    RealmObjectBase.set(this, 'lastAccessCheck', lastAccessCheck);
    RealmObjectBase.set(this, 'expiration', expiration);
  }

  Feed._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get link => RealmObjectBase.get<String>(this, 'link') as String;
  @override
  set link(String value) => RealmObjectBase.set(this, 'link', value);

  @override
  String get origin => RealmObjectBase.get<String>(this, 'origin') as String;
  @override
  set origin(String value) => RealmObjectBase.set(this, 'origin', value);

  @override
  String? get access => RealmObjectBase.get<String>(this, 'access') as String?;
  @override
  set access(String? value) => RealmObjectBase.set(this, 'access', value);

  @override
  DateTime? get lastUpdate =>
      RealmObjectBase.get<DateTime>(this, 'lastUpdate') as DateTime?;
  @override
  set lastUpdate(DateTime? value) =>
      RealmObjectBase.set(this, 'lastUpdate', value);

  @override
  DateTime? get lastAccessCheck =>
      RealmObjectBase.get<DateTime>(this, 'lastAccessCheck') as DateTime?;
  @override
  set lastAccessCheck(DateTime? value) =>
      RealmObjectBase.set(this, 'lastAccessCheck', value);

  @override
  DateTime? get expiration =>
      RealmObjectBase.get<DateTime>(this, 'expiration') as DateTime?;
  @override
  set expiration(DateTime? value) =>
      RealmObjectBase.set(this, 'expiration', value);

  @override
  Stream<RealmObjectChanges<Feed>> get changes =>
      RealmObjectBase.getChanges<Feed>(this);

  @override
  Feed freeze() => RealmObjectBase.freezeObject<Feed>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Feed._);
    return const SchemaObject(ObjectType.realmObject, Feed, 'Feed', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('link', RealmPropertyType.string),
      SchemaProperty('origin', RealmPropertyType.string),
      SchemaProperty('access', RealmPropertyType.string, optional: true),
      SchemaProperty('lastUpdate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lastAccessCheck', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('expiration', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}
