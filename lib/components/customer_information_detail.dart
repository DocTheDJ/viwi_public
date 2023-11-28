import 'package:flutter/material.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/utils/unassigned.dart';

class CustomerInformation extends StatelessWidget {
  const CustomerInformation({super.key, required this.order});

  final Order order;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        padding: listBoxPadding(size),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (var i in order.addresses)
            _AddressCards(
              address: i,
              headline: i.billing ? 'Fakturační údaje:' : 'Doručovací údaje:',
              icon: i.billing ? Icons.description_outlined : Icons.home_outlined,
              size: size,
            ),
          order.note == null
              ? const SizedBox.shrink()
              : _Extra(
                  headline: 'Poznámka:',
                  icon: Icons.message_outlined,
                  data: order.note!,
                  size: size,
                ),
          order.referer == null
              ? const SizedBox.shrink()
              : _Extra(
                  headline: 'Odkud zákazník přišel:',
                  icon: Icons.record_voice_over_outlined,
                  data: order.referer!,
                  size: size,
                ),
        ]));
  }
}

class _AddressCards extends StatelessWidget {
  const _AddressCards({required this.address, required this.headline, required this.icon, required this.size});
  final String headline;
  final IconData icon;
  final Address address;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                SizedBox(width: size.width / 75),
                Text(
                  headline,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            )),
        SizedBox(
          height: size.height / 90,
        ),
        Container(
            decoration: listBoxDecorations(context),
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NameLine(addr: address),
                    address.company == null ? const SizedBox.shrink() : Text(address.company!),
                    address.street == null ? const SizedBox.shrink() : Text('${address.street!} ${address.housenumber ?? ''}'),
                    address.city == null ? const SizedBox.shrink() : Text(address.city!),
                    address.zip == null ? const SizedBox.shrink() : Text(address.zip!),
                    address.country == null ? const SizedBox.shrink() : Text(address.country!),
                  ],
                )
              ],
            )),
        SizedBox(
          height: size.height / 40,
        )
      ],
    );
  }
}

class _NameLine extends StatelessWidget {
  const _NameLine({required this.addr});
  final Address addr;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(addr.name ?? ''), addr.lastname == null ? const SizedBox.shrink() : Text(' ${addr.lastname}')],
    );
  }
}

class _Extra extends StatelessWidget {
  const _Extra({required this.headline, required this.icon, required this.data, required this.size});

  final IconData icon;
  final String headline;
  final String data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                SizedBox(
                  width: size.width / 75,
                ),
                Text(headline, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            )),
        SizedBox(
          height: size.height / 90,
        ),
        Container(
          decoration: listBoxDecorations(context),
          padding: const EdgeInsets.all(20),
          child: Row(children: [Flexible(child: Text(data))]),
        ),
        SizedBox(
          height: size.height / 40,
        )
      ],
    );
  }
}
