// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Address extends $Address with RealmEntity, RealmObjectBase, RealmObject {
  Address(
    ObjectId id,
    bool billing, {
    String? name,
    String? lastname,
    String? company,
    String? street,
    String? housenumber,
    String? city,
    String? zip,
    String? country,
    String? phone,
    Feed? feed,
    int? externalId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'lastname', lastname);
    RealmObjectBase.set(this, 'company', company);
    RealmObjectBase.set(this, 'street', street);
    RealmObjectBase.set(this, 'housenumber', housenumber);
    RealmObjectBase.set(this, 'city', city);
    RealmObjectBase.set(this, 'zip', zip);
    RealmObjectBase.set(this, 'country', country);
    RealmObjectBase.set(this, 'phone', phone);
    RealmObjectBase.set(this, 'billing', billing);
    RealmObjectBase.set(this, 'feed', feed);
    RealmObjectBase.set(this, 'externalId', externalId);
  }

  Address._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get lastname =>
      RealmObjectBase.get<String>(this, 'lastname') as String?;
  @override
  set lastname(String? value) => RealmObjectBase.set(this, 'lastname', value);

  @override
  String? get company =>
      RealmObjectBase.get<String>(this, 'company') as String?;
  @override
  set company(String? value) => RealmObjectBase.set(this, 'company', value);

  @override
  String? get street => RealmObjectBase.get<String>(this, 'street') as String?;
  @override
  set street(String? value) => RealmObjectBase.set(this, 'street', value);

  @override
  String? get housenumber =>
      RealmObjectBase.get<String>(this, 'housenumber') as String?;
  @override
  set housenumber(String? value) =>
      RealmObjectBase.set(this, 'housenumber', value);

  @override
  String? get city => RealmObjectBase.get<String>(this, 'city') as String?;
  @override
  set city(String? value) => RealmObjectBase.set(this, 'city', value);

  @override
  String? get zip => RealmObjectBase.get<String>(this, 'zip') as String?;
  @override
  set zip(String? value) => RealmObjectBase.set(this, 'zip', value);

  @override
  String? get country =>
      RealmObjectBase.get<String>(this, 'country') as String?;
  @override
  set country(String? value) => RealmObjectBase.set(this, 'country', value);

  @override
  String? get phone => RealmObjectBase.get<String>(this, 'phone') as String?;
  @override
  set phone(String? value) => RealmObjectBase.set(this, 'phone', value);

  @override
  bool get billing => RealmObjectBase.get<bool>(this, 'billing') as bool;
  @override
  set billing(bool value) => RealmObjectBase.set(this, 'billing', value);

  @override
  Feed? get feed => RealmObjectBase.get<Feed>(this, 'feed') as Feed?;
  @override
  set feed(covariant Feed? value) => RealmObjectBase.set(this, 'feed', value);

  @override
  int? get externalId => RealmObjectBase.get<int>(this, 'externalId') as int?;
  @override
  set externalId(int? value) => RealmObjectBase.set(this, 'externalId', value);

  @override
  Stream<RealmObjectChanges<Address>> get changes =>
      RealmObjectBase.getChanges<Address>(this);

  @override
  Address freeze() => RealmObjectBase.freezeObject<Address>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Address._);
    return const SchemaObject(ObjectType.realmObject, Address, 'Address', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('lastname', RealmPropertyType.string, optional: true),
      SchemaProperty('company', RealmPropertyType.string, optional: true),
      SchemaProperty('street', RealmPropertyType.string, optional: true),
      SchemaProperty('housenumber', RealmPropertyType.string, optional: true),
      SchemaProperty('city', RealmPropertyType.string, optional: true),
      SchemaProperty('zip', RealmPropertyType.string, optional: true),
      SchemaProperty('country', RealmPropertyType.string, optional: true),
      SchemaProperty('phone', RealmPropertyType.string, optional: true),
      SchemaProperty('billing', RealmPropertyType.bool),
      SchemaProperty('feed', RealmPropertyType.object,
          optional: true, linkTarget: 'Feed'),
      SchemaProperty('externalId', RealmPropertyType.int, optional: true),
    ]);
  }
}
