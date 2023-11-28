import 'package:flutter/material.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/utils/unassigned.dart';

class ItemsListDetail extends StatelessWidget {
  const ItemsListDetail({super.key, required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      padding: listBoxPadding(size),
      separatorBuilder: (context, index) => SizedBox(
        height: size.height / 100,
      ),
      itemBuilder: (context, index) => GestureDetector(onTap: () => openDialog(context, items[index], size), child: _ItemDetail(item: items[index])),
    );
  }

  void openDialog(BuildContext context, Item item, Size size) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(30),
              backgroundColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              children: [
                _DialogRow(
                  header: 'Kód produktu:',
                  data: item.code,
                ),
                _DialogRow(
                  header: 'Název produktu:',
                  data: item.name,
                  maxWidth: size.width - 50,
                ),
                _DialogRow(
                  header: 'Počet kusů:',
                  data: item.amount.toString(),
                ),
                _DialogRow(
                  header: 'Cena za kus:',
                  data: '${item.price / item.amount} ${item.currency}',
                ),
                _DialogRow(
                  header: 'Cena celkem:',
                  data: '${item.price} ${item.currency}',
                ),
              ],
            ));
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => AlertDialog(
    //         contentPadding: const EdgeInsets.all(30),
    //         // backgroundColor: globals.colorScheme.inactiveBackground,
    //         // surfaceTintColor: globals.colorScheme.inactiveBackground,
    //         backgroundColor: Theme.of(context).colorScheme.background,
    //         surfaceTintColor: Theme.of(context).colorScheme.surface,
    //         content: _DialogPage(
    //           item: item,
    //           size: size,
    //         )));
  }
}

class _ItemDetail extends StatelessWidget {
  const _ItemDetail({required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
        decoration: listBoxDecorations(context),
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        height: size.height / 10,
        child: Row(children: [
          // const Expanded(flex: 2, child: Icon(Icons.flutter_dash)),
          Expanded(
              flex: 12,
              child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Flexible(
                          child:
                              Row(mainAxisSize: MainAxisSize.min, children: [Flexible(child: Text(item.name ?? 'unknown', overflow: TextOverflow.ellipsis))])),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        _ListItemNumbers(
                            data: item.amount.toString(),
                            size: size,
                            icon: Icons.inventory_2_outlined,
                            // iconColor: Colors.black45,
                            iconColor: colorScheme.tertiary,
                            flex: 2,
                            textStyle: TextStyle(color: colorScheme.tertiary, fontWeight: FontWeight.w500)),
                        _ListItemNumbers(
                            data: '${item.price / item.amount} ${item.currency}',
                            size: size,
                            icon: Icons.sell_outlined,
                            iconColor: colorScheme.tertiary,
                            flex: 4,
                            textStyle: TextStyle(color: colorScheme.tertiary, fontWeight: FontWeight.w500)),
                        _ListItemNumbers(
                            data: '${item.price} ${item.currency}',
                            size: size,
                            icon: Icons.payments_outlined,
                            flex: 4,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                      ])
                    ]))
                  ])))
        ]));
  }
}

class _ListItemNumbers extends StatelessWidget {
  const _ListItemNumbers({required this.data, required this.size, required this.icon, this.iconColor, required this.textStyle, required this.flex});
  final String data;
  final Size size;
  final IconData icon;
  final Color? iconColor;
  final TextStyle textStyle;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
              icon,
              size: 15,
              color: iconColor,
            ),
            SizedBox(
              width: size.width / 75,
            ),
            Text(
              data,
              style: textStyle,
            )
          ])
        ]));
  }
}

class _DialogPage extends StatelessWidget {
  const _DialogPage({required this.item, required this.size});

  final Item item;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * 0.75, maxWidth: size.width),
      child: ListView(
        shrinkWrap: true,
        children: [
          _DialogRow(
            header: 'Kód produktu:',
            data: item.code,
          ),
          _DialogRow(
            header: 'Název produktu:',
            data: item.name,
            maxWidth: size.width - 50,
          ),
          _DialogRow(
            header: 'Počet kusů:',
            data: item.amount.toString(),
          ),
          _DialogRow(
            header: 'Cena za kus:',
            data: '${item.price / item.amount} ${item.currency}',
          ),
          _DialogRow(
            header: 'Cena celkem:',
            data: '${item.price} ${item.currency}',
          ),
        ],
      ),
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     _DialogRow(
    //       header: 'Kód produktu:',
    //       data: item.code,
    //     ),
    //     _DialogRow(
    //       header: 'Název produktu:',
    //       data: item.name,
    //       maxWidth: size.width - 50,
    //     ),
    //     _DialogRow(
    //       header: 'Počet kusů:',
    //       data: item.amount.toString(),
    //     ),
    //     _DialogRow(
    //       header: 'Cena za kus:',
    //       data: '${item.price / item.amount} ${item.currency}',
    //     ),
    //     _DialogRow(
    //       header: 'Cena celkem:',
    //       data: '${item.price} ${item.currency}',
    //     ),
    //   ],
    // );
  }
}

class _DialogRow extends StatelessWidget {
  const _DialogRow({this.data, required this.header, this.maxWidth});

  final String ifNull = 'unknown';
  final String? data;
  final String header;
  final double? maxWidth;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        Container(
            width: maxWidth,
            padding: const EdgeInsets.only(bottom: 10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
            child: Row(children: [
              Flexible(
                  child: Text(
                data ?? ifNull,
                // overflow: TextOverflow.ellipsis,
                // maxLines: 2,
              ))
            ])),
      ],
    );
  }
}
