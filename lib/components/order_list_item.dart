import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viwi/tables/order/order.dart';
import 'package:viwi/utils/unassigned.dart';

class OrderListItem extends StatelessWidget {
  OrderListItem({super.key, required this.order, required this.size});

  final Order order;
  final DateFormat format = DateFormat('dd.MM.yyyy | HH:mm');
  final Size size;

  @override
  Widget build(BuildContext context) {
    // Color c = decideColor(order.state!.colorState);
    final address = order.addresses.firstOrNull;
    return Container(
        decoration: listBoxDecorations(context, isnew: order.isnew),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                    // color: c,
                    color: Color(order.state!.colorState),
                    child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 2.5, bottom: 2.5),
                        alignment: Alignment.center,
                        child: Text(order.state?.name ?? ''))),
              ],
            ),
            Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    order.code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(format.format(order.date.toLocal())),
                  Text(
                    '${order.price.toString()} ${order.currency}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Flexible(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _Contact(
                  data: "${address?.name ?? ''}${address?.lastname == null ? '' : ' ${address?.lastname}'}",
                  icon: Icons.person_outlined,
                  size: size,
                ),
                _Contact(
                  data: order.email ?? '',
                  icon: Icons.email_outlined,
                  size: size,
                ),
                _Contact(
                  data: address?.phone ?? '',
                  icon: Icons.phone,
                  size: size,
                ),
              ]))
            ])
          ],
        ));
  }
}

class _Contact extends StatelessWidget {
  const _Contact({required this.data, required this.icon, required this.size});

  final String data;
  final IconData icon;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 16,
            ),
            SizedBox(
              width: size.width / 90,
            ),
            Flexible(
              child: Text(
                data,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            )
          ],
        ));
  }
}
