// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:viwi/BL/drawer_screen_provider.dart';
import 'package:viwi/BL/order_detail_provider.dart';
import 'package:viwi/BL/orders_provider.dart';
import 'package:viwi/components/order_list_item.dart';
import 'package:viwi/pages/order_detail.dart';
import 'package:viwi/pages/overview.dart';
import 'package:viwi/tables/feed/feed.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/tables/state/state.dart';

import '../tables/order/order.dart';
import '../utils/unassigned.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(builder: (_, bloc, __) => bloc.currentScreen);
  }
}

class OrderList extends StatelessWidget {
  OrderList({super.key});

  final TextEditingController _controller = TextEditingController();

  void clearInput(OrdersProvider o) {
    _controller.clear();
    o.search(null);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<OrdersProvider>(
        builder: (_, bloc, __) => Column(
              children: [
                LinearProgressIndicator(
                  value: bloc.progress,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(
                  height: size.height / 60,
                ),
                Container(
                    decoration: listBoxDecorations(context),
                    margin: EdgeInsets.only(bottom: size.height / 30, left: size.width / 30, right: size.width / 30),
                    padding: EdgeInsets.only(left: size.width / 40, right: size.width / 20),
                    child: TextField(
                      onChanged: (value) => bloc.search(value),
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: 'Hledáte něco konkrétního?',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(onPressed: () => clearInput(bloc), icon: const Icon(Icons.clear))),
                    )),
                Expanded(
                    child: RefreshIndicator(
                        onRefresh: () => bloc.startRefresh(context),
                        child: Container(
                            margin: EdgeInsets.only(bottom: size.height / 11),
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: bloc.orders?.length ?? 0,
                                padding: EdgeInsets.only(left: size.width / 30, right: size.width / 30, bottom: size.height / 100),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: size.height / 80,
                                    ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        context.read<OrderDetailProvider>().setPage(index);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetails()))
                                            .then((value) => context.read<OrdersProvider>().refreshOrders());
                                      },
                                      child: OrderListItem(
                                        order: bloc.orders![index],
                                        size: size,
                                      ));
                                })))),
              ],
            ));
  }
}
