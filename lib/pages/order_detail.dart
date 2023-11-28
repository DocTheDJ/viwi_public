import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:viwi/BL/order_detail_provider.dart';
import 'package:viwi/BL/orders_provider.dart';
import 'package:viwi/components/floating_filter_button.dart';
import 'package:viwi/components/order_data_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  void makeCall(BuildContext context, int index) {
    final p = context.read<OrdersProvider>().orders?[index].addresses.firstOrNull?.phone;
    if (p != null) {
      final phone = Uri(scheme: 'tel', path: p);
      canLaunchUrl(phone).then((value) {
        if (value) {
          launchUrl(phone);
        }
      });
      launchUrlString('tel://$p');
    } else {
      _unknownNumber(context);
    }
  }

  void _unknownNumber(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [Text('No number found.')]),
              actionsAlignment: MainAxisAlignment.center,
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: context.watch<OrderDetailProvider>().page ?? 0);
    final tmp = context.watch<OrdersProvider>();
    final size = MediaQuery.of(context).size;
    return Consumer<OrderDetailProvider>(
        builder: (_, page, __) => Scaffold(
              appBar: AppBar(
                title: Text(tmp.orders![page.page ?? 0].code),
                actions: [
                  IconButton(onPressed: () => page.decrement(tmp.orderLength ?? 0, controller: controller), icon: const Icon(Icons.arrow_back)),
                  IconButton(onPressed: () => page.increment(tmp.orderLength ?? 0, controller: controller), icon: const Icon(Icons.arrow_forward))
                ],
              ),
              body: PageView.builder(
                  itemCount: tmp.orders?.length,
                  controller: controller,
                  onPageChanged: (value) => page.setPage(value),
                  itemBuilder: (context, position) => OrderDetailData(
                        order: tmp.orders![position],
                      )),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Wrap(
                spacing: 20,
                children: [
                  FilterButton(
                    filterSize: size.height / 15,
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.arrow_back,
                    name: null,
                    buttonColor: Theme.of(context).colorScheme.secondaryContainer,
                    childColor: Theme.of(context).colorScheme.secondary,
                  ),
                  FilterButton(
                    filterSize: size.height / 15,
                    onPressed: () => makeCall(context, page.page ?? 0),
                    icon: Icons.phone_outlined,
                    name: null,
                    buttonColor: Theme.of(context).colorScheme.primary,
                    childColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  FilterButton(
                    filterSize: size.height / 15,
                    onPressed: () => page.swapPart(),
                    icon: page.showItems ? Icons.description_outlined : Icons.payments_outlined,
                    name: null,
                    buttonColor: Theme.of(context).colorScheme.secondaryContainer,
                    childColor: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
            ));
  }
}
