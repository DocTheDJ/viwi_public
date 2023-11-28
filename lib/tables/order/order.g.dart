// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Order extends $Order with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Order(
    ObjectId id,
    String code,
    DateTime date,
    double price,
    String currency, {
    String? email,
    StateDB? state,
    Feed? feed,
    bool isnew = true,
    String? note,
    String? referer,
    int? externalId,
    Iterable<Address> addresses = const [],
    Iterable<Item> items = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Order>({
        'isnew': true,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'code', code);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'currency', currency);
    RealmObjectBase.set(this, 'state', state);
    RealmObjectBase.set(this, 'feed', feed);
    RealmObjectBase.set(this, 'isnew', isnew);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'referer', referer);
    RealmObjectBase.set(this, 'externalId', externalId);
    RealmObjectBase.set<RealmList<Address>>(
        this, 'addresses', RealmList<Address>(addresses));
    RealmObjectBase.set<RealmList<Item>>(this, 'items', RealmList<Item>(items));
  }

  Order._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get code => RealmObjectBase.get<String>(this, 'code') as String;
  @override
  set code(String value) => RealmObjectBase.set(this, 'code', value);

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String;
  @override
  set currency(String value) => RealmObjectBase.set(this, 'currency', value);

  @override
  StateDB? get state => RealmObjectBase.get<StateDB>(this, 'state') as StateDB?;
  @override
  set state(covariant StateDB? value) =>
      RealmObjectBase.set(this, 'state', value);

  @override
  Feed? get feed => RealmObjectBase.get<Feed>(this, 'feed') as Feed?;
  @override
  set feed(covariant Feed? value) => RealmObjectBase.set(this, 'feed', value);

  @override
  RealmList<Address> get addresses =>
      RealmObjectBase.get<Address>(this, 'addresses') as RealmList<Address>;
  @override
  set addresses(covariant RealmList<Address> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<Item> get items =>
      RealmObjectBase.get<Item>(this, 'items') as RealmList<Item>;
  @override
  set items(covariant RealmList<Item> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool get isnew => RealmObjectBase.get<bool>(this, 'isnew') as bool;
  @override
  set isnew(bool value) => RealmObjectBase.set(this, 'isnew', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  String? get referer =>
      RealmObjectBase.get<String>(this, 'referer') as String?;
  @override
  set referer(String? value) => RealmObjectBase.set(this, 'referer', value);

  @override
  int? get externalId => RealmObjectBase.get<int>(this, 'externalId') as int?;
  @override
  set externalId(int? value) => RealmObjectBase.set(this, 'externalId', value);

  @override
  Stream<RealmObjectChanges<Order>> get changes =>
      RealmObjectBase.getChanges<Order>(this);

  @override
  Order freeze() => RealmObjectBase.freezeObject<Order>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Order._);
    return const SchemaObject(ObjectType.realmObject, Order, 'Order', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('code', RealmPropertyType.string),
      SchemaProperty('date', RealmPropertyType.timestamp),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('currency', RealmPropertyType.string),
      SchemaProperty('state', RealmPropertyType.object,
          optional: true, linkTarget: 'StateDB'),
      SchemaProperty('feed', RealmPropertyType.object,
          optional: true, linkTarget: 'Feed'),
      SchemaProperty('addresses', RealmPropertyType.object,
          linkTarget: 'Address', collectionType: RealmCollectionType.list),
      SchemaProperty('items', RealmPropertyType.object,
          linkTarget: 'Item', collectionType: RealmCollectionType.list),
      SchemaProperty('isnew', RealmPropertyType.bool),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('referer', RealmPropertyType.string, optional: true),
      SchemaProperty('externalId', RealmPropertyType.int, optional: true),
    ]);
  }
}
