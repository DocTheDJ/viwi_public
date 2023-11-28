import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viwi/components/customer_information_detail.dart';
import 'package:viwi/components/item_list_detail.dart';
import 'package:viwi/tables/tables.dart';
import 'package:viwi/utils/library/helpers/presta8.dart';
import 'package:provider/provider.dart';
import 'package:viwi/BL/order_detail_provider.dart';
import 'package:viwi/BL/orders_provider.dart';

import 'package:viwi/globals.dart' as globals;

class OrderDetailData extends StatelessWidget {
  OrderDetailData({super.key, required this.order});

  final Order order;
  final DateFormat format = DateFormat('dd.MM.yyyy | HH:mm');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final address = order.addresses.firstOrNull;
    context.read<OrderDetailProvider>().updateSeen(order);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0.0, 1.0), blurRadius: 6.0)],
                border: const Border(top: BorderSide(color: Colors.black26), bottom: BorderSide(color: Colors.black26)),
                color: Theme.of(context).colorScheme.secondaryContainer
                // globals.colorScheme.inactiveBackground
                ),
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  if (order.feed?.origin.startsWith('p') ?? false) {
                    _setNewState(context, size, order.externalId!);
                  }
                },
                child: Card(
                    color: Color(order.state!.colorState),
                    child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 2.5, bottom: 2.5),
                        alignment: Alignment.center,
                        child: Text(order.state!.name))),
              ),
              const SizedBox(
                height: 20,
              ),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      // color: globals.colorScheme.activeBackground,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      width: size.width / 30,
                    ),
                    Text(
                      format.format(order.date.toLocal()),
                      style: TextStyle(
                          // color: globals.colorScheme.activeBackground
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ]),
              // ]),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_outlined),
                          SizedBox(
                            width: size.width / 30,
                          ),
                          Text("${address?.name ?? ''}${address?.lastname == null ? '' : ' ${address?.lastname}'}")
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email_outlined),
                          SizedBox(
                            width: size.width / 30,
                          ),
                          Text(order.email ?? 'unknown')
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone_outlined),
                          SizedBox(
                            width: size.width / 30,
                          ),
                          Text(address?.phone ?? 'unknown')
                        ],
                      )
                    ],
                  )
                ],
              )
            ])),
        SizedBox(
          height: size.height / 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                // color: globals.colorScheme.activeBackground,
                color: Theme.of(context).colorScheme.primary,
                child: Container(
                    padding: const EdgeInsets.only(top: 7, bottom: 7, left: 30, right: 30),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Icon(
                        Icons.payments_outlined,
                        // color: globals.colorScheme.activeChild,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      SizedBox(
                        width: size.width / 25,
                      ),
                      Text(
                        '${order.price} ${order.currency}',
                        style: TextStyle(
                            // color: globals.colorScheme.activeChild,
                            color: Theme.of(context).colorScheme.primaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ])),
              )
            ],
          ),
        ),
        Expanded(
            child: context.watch<OrderDetailProvider>().showItems
                ? ItemsListDetail(
                    items: order.items.toList(),
                  )
                : CustomerInformation(
                    order: order,
                  )),
      ],
    );
  }

  void _setNewState(BuildContext context, Size size, int target) {
    showDialog(
        context: context,
        builder: (context) => Consumer<OrderDetailProvider>(builder: (_, provider, __) {
              final op = context.read<OrdersProvider>();
              final states = provider.states(op.thisFeed!);
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: size.height / 2,
                        width: size.width / 1.5,
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: states.length,
                            separatorBuilder: (context, index) => const Divider(
                                  height: 2,
                                ),
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    provider.swapChanging();
                                    _confirmChange(
                                        context,
                                        states[index],
                                        () => PrestaHelper8.updateOrder(order.feed!.link, target.toString(), states[index].externalId.toString()).then((value) {
                                              if (value) {
                                                globals.realm.write(() {
                                                  order.state = states[index];
                                                  globals.realm.add<Order>(order, update: true);
                                                });
                                                op.setActive(index + op.startingFilters.length);
                                                Navigator.pop(context);
                                              }
                                              provider.swapChanging();
                                            }), () {
                                      provider.swapChanging();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Card(
                                      // color: decideColor(states[index].colorState),
                                      color: Color(states[index].colorState),
                                      child: Container(
                                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                          alignment: Alignment.center,
                                          child: Text(states[index].name))),
                                ))),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    provider.isChanging ? const CircularProgressIndicator() : const SizedBox.shrink()
                  ],
                ),
              );
            }));
  }

  void _confirmChange(BuildContext context, StateDB state, Function onConfirm, Function onCancel) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                child: Text('Určitě si přejete změnit stav objednávky z ${order.state?.name} na ${state.name} ?'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: const Text('Ano')),
                TextButton(onPressed: () => onCancel(), child: const Text('Ne'))
              ],
            ));
  }
}
