import 'package:flutter/material.dart';

const EdgeInsetsGeometry tbd =
    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5);

class DetailCardListItem extends StatelessWidget {
  final String? data;
  final IconData icon;

  const DetailCardListItem({super.key, required this.data, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        child: Container(
            padding: tbd,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon),
              Flexible(
                  child: Text(
                data ?? '',
                overflow: TextOverflow.ellipsis,
              ))
            ])));
  }
}
