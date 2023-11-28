// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Item extends $Item with RealmEntity, RealmObjectBase, RealmObject {
  Item(
    ObjectId id,
    int amount,
    double price, {
    String? type,
    String? name,
    String? code,
    String? currency,
    int? externalId,
    Feed? feed,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'code', code);
    RealmObjectBase.set(this, 'currency', currency);
    RealmObjectBase.set(this, 'externalId', externalId);
    RealmObjectBase.set(this, 'feed', feed);
  }

  Item._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get amount => RealmObjectBase.get<int>(this, 'amount') as int;
  @override
  set amount(int value) => RealmObjectBase.set(this, 'amount', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String? get code => RealmObjectBase.get<String>(this, 'code') as String?;
  @override
  set code(String? value) => RealmObjectBase.set(this, 'code', value);

  @override
  String? get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String?;
  @override
  set currency(String? value) => RealmObjectBase.set(this, 'currency', value);

  @override
  int? get externalId => RealmObjectBase.get<int>(this, 'externalId') as int?;
  @override
  set externalId(int? value) => RealmObjectBase.set(this, 'externalId', value);

  @override
  Feed? get feed => RealmObjectBase.get<Feed>(this, 'feed') as Feed?;
  @override
  set feed(covariant Feed? value) => RealmObjectBase.set(this, 'feed', value);

  @override
  Stream<RealmObjectChanges<Item>> get changes =>
      RealmObjectBase.getChanges<Item>(this);

  @override
  Item freeze() => RealmObjectBase.freezeObject<Item>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Item._);
    return const SchemaObject(ObjectType.realmObject, Item, 'Item', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('amount', RealmPropertyType.int),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('code', RealmPropertyType.string, optional: true),
      SchemaProperty('currency', RealmPropertyType.string, optional: true),
      SchemaProperty('externalId', RealmPropertyType.int, optional: true),
      SchemaProperty('feed', RealmPropertyType.object,
          optional: true, linkTarget: 'Feed'),
    ]);
  }
}
