// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class StateDB extends $StateDB with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  StateDB(
    ObjectId id,
    String name, {
    int colorState = 0x1FFFFFFF,
    int? externalId,
    Feed? feed,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<StateDB>({
        'colorState': 0x1FFFFFFF,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'colorState', colorState);
    RealmObjectBase.set(this, 'externalId', externalId);
    RealmObjectBase.set(this, 'feed', feed);
  }

  StateDB._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get colorState => RealmObjectBase.get<int>(this, 'colorState') as int;
  @override
  set colorState(int value) => RealmObjectBase.set(this, 'colorState', value);

  @override
  int? get externalId => RealmObjectBase.get<int>(this, 'externalId') as int?;
  @override
  set externalId(int? value) => RealmObjectBase.set(this, 'externalId', value);

  @override
  Feed? get feed => RealmObjectBase.get<Feed>(this, 'feed') as Feed?;
  @override
  set feed(covariant Feed? value) => RealmObjectBase.set(this, 'feed', value);

  @override
  Stream<RealmObjectChanges<StateDB>> get changes =>
      RealmObjectBase.getChanges<StateDB>(this);

  @override
  StateDB freeze() => RealmObjectBase.freezeObject<StateDB>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(StateDB._);
    return const SchemaObject(ObjectType.realmObject, StateDB, 'StateDB', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('colorState', RealmPropertyType.int),
      SchemaProperty('externalId', RealmPropertyType.int, optional: true),
      SchemaProperty('feed', RealmPropertyType.object,
          optional: true, linkTarget: 'Feed'),
    ]);
  }
}
