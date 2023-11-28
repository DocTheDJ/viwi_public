import 'package:realm/realm.dart';
import 'package:viwi/tables/feed/feed.dart';
part 'address.g.dart';

class AddressFields {
  static const String fieldName = 'name';
  static const String fieldLastname = 'lastname';
  static const String fieldCompany = 'company';
  static const String fieldStreet = 'street';
  static const String fieldHousenumber = 'housenumber';
  static const String fieldCity = 'city';
  static const String fieldZip = 'zip';
  static const String fieldCountry = 'country';
  static const String fieldPhone = 'phone';
  static const String fieldBilling = 'billing';
  static const String fieldExternalId = 'externalId';
  static const String fieldFeed = 'feed';

  static const Map<String, dynamic> properties = {
    fieldName: 'string?',
    fieldLastname: 'string?',
    fieldCompany: 'string?',
    fieldStreet: 'string?',
    fieldHousenumber: 'string?',
    fieldCity: 'string?',
    fieldZip: 'string?',
    fieldCountry: 'string?',
    fieldBilling: 'bool',
    fieldFeed: 'Feed?',
    fieldExternalId: 'int?',
    fieldPhone: 'string?',
  };
}

@RealmModel()
class $Address {
  @PrimaryKey()
  late ObjectId id;

  late String? name;
  late String? lastname;
  late String? company;
  late String? street;
  late String? housenumber;
  late String? city;
  late String? zip;
  late String? country;
  late String? phone;
  late bool billing;
  late $Feed? feed;
  late int? externalId;

  // @Ignored()
  // static Map<String, dynamic> properties = {
  //   'name': {'type': 'string?', 'name': 'name'},
  //   'lastname': {'type': 'string?', 'name': 'lastname'},
  //   'company': {'type': 'string?', 'name': 'company'},
  //   'street': {'type': 'string?', 'name': 'street'},
  //   'housenumber': {'type': 'string?', 'name': 'housenumber'},
  //   'city': {'type': 'string?', 'name': 'city'},
  //   'zip': {'type': 'string?', 'name': 'zip'},
  //   'country': {'type': 'string?', 'name': 'country'},
  //   'billing': {'type': 'bool', 'name': 'billing'},
  //   'feed': {'type': 'Feed?', 'name': 'feed'},
  //   'eid': {'type': 'int?', 'name': 'externalId'},
  //   'phone': {'type': 'string?', 'name': 'phone'},
  // };

  @override
  String toString() {
    return '{$name, $lastname, $company, $street, $housenumber, $city, $zip, $country, $billing, externalId: $externalId, $phone}';
  }
  // static String getTableName() {
  //   return 'Address';
  // }

  @Ignored()
  static List<String> wanted = [
    AddressFields.fieldName,
    AddressFields.fieldLastname,
    AddressFields.fieldCompany,
    AddressFields.fieldStreet,
    AddressFields.fieldHousenumber,
    AddressFields.fieldCity,
    AddressFields.fieldZip,
    AddressFields.fieldCountry,
    AddressFields.fieldBilling,
    AddressFields.fieldPhone
  ];

  @Ignored()
  Address fromMap(Map<String, dynamic> data) {
    final billing = data[AddressFields.fieldBilling];
    return Address(
        ObjectId(),
        billing is bool
            ? billing
            : billing is int
                ? billing == 1
                : billing == '1',
        name: data[AddressFields.fieldName],
        lastname: data[AddressFields.fieldLastname],
        company: data[AddressFields.fieldCompany],
        street: data[AddressFields.fieldStreet],
        housenumber: data[AddressFields.fieldHousenumber],
        city: data[AddressFields.fieldCity],
        zip: data[AddressFields.fieldZip],
        country: data[AddressFields.fieldCountry],
        feed: data[AddressFields.fieldFeed],
        externalId: data[AddressFields.fieldExternalId],
        phone: data[AddressFields.fieldPhone]);
  }

  @Ignored()
  (String, List) getQuery(Map<String, dynamic> data, List<String> wanted) {
    String output = '';
    List listOut = [];
    wanted.asMap().forEach((index, element) {
      output += '$element == \$$index AND ';
      if (AddressFields.properties[element] == 'bool') {
        listOut.add(data[element] == '1');
      } else {
        listOut.add(data[element]);
      }
    });
    return (output.substring(0, output.length - 5), listOut);
  }
}
