// ignore_for_file: unused_import, must_be_immutable

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viwi/BL/drawer_screen_provider.dart';
import 'package:viwi/BL/overview_provider.dart';
import 'package:viwi/components/confirmation_dialog.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/tables/feed/feed.dart';
import 'package:viwi/tables/order/order.dart';
import 'package:viwi/utils/library/helpers/base_helper.dart';
// import 'package:viwi/utils/library/presta.dart';
// import 'package:viwi/utils/download.dart';
import 'package:viwi/utils/unassigned.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:in_app_update/in_app_update.dart';

const tips = [
  'Kvůli rychlosti se stahuje pouze poslední rok dat.',
  'V detailu můžete změnit stav objednávky?',
  'Potažením ze shora obnovíte data?',
  'Podržením eshopu v navigaci jej můžete odstranit?',
  'Můžete změnit barvy stavů v nastavení?',
  'Můžete zobrazit detail produktu?'
];

class Overview extends StatelessWidget {
  const Overview({super.key});

  void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final t = context.read<DrawerScreenProvider>();
    // context.read<OverviewProvider>()._checkLastVersion(context);
    // final now = DateTime.now();
    return Consumer<OverviewProvider>(builder: (_, bloc, __) {
      return ListView(padding: listBoxPadding(size), children: [
        bloc.updateAvailable
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: listBoxDecColorLess(context, color: Theme.of(context).colorScheme.primary),
                child: ListTile(
                  onTap: () => InAppUpdate.performImmediateUpdate().catchError((e) {
                    showSnack(context, e.toString());
                    return AppUpdateResult.inAppUpdateFailed;
                  }),
                  // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.viwi.viwi&pcampaignid=web_share'),
                  //     mode: LaunchMode.externalApplication),
                  leading: Container(
                    decoration: listBoxDecColorLess(context, color: Theme.of(context).colorScheme.secondary),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.download,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  title: const Text('Nová aktulizace je k dispozici!'),
                  subtitle: Text(
                    'Klepněte pro více informací.',
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ))
            : const SizedBox.shrink(),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: _OverviewCard(
                      head: 'Dnes',
                      data: t.isFeedChosen ? bloc.dayFeed(t.activeFeed!.id) : bloc.day,
                      // onBuild: _getSizeOfOne,
                    )),
                StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: _OverviewCard(
                      head: 'Týden',
                      data: t.isFeedChosen ? bloc.weekFeed(t.activeFeed!.id) : bloc.week,
                    )),
                StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: _OverviewCard(
                      head: 'Měsíc',
                      data: t.isFeedChosen ? bloc.monthFeed(t.activeFeed!.id) : bloc.month,
                    )),
                StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: _OverviewCard(
                      head: 'Rok',
                      data: t.isFeedChosen ? bloc.yearFeed(t.activeFeed!.id) : bloc.year,
                    )),
              ],
            )),
        OverviewShopTiles(op: bloc),
        // for (var (index, f) in bloc.feeds.indexed)
        //   _ShopTileOver(
        //     now: now,
        //     feed: f,
        //     onClick: () => startCheckingDialog(context, f, index),
        //     size: size,
        //   ),
        Tip(
          // getSize: _getterSize,
          size: size,
        )
      ]);
    });
  }
}

class OverviewShopTiles extends StatelessWidget {
  OverviewShopTiles({super.key, required this.op});

  OverviewProvider op;

  @override
  Widget build(BuildContext context) {
    final t = context.read<DrawerScreenProvider>();
    final now = DateTime.now();
    final size = MediaQuery.of(context).size;
    return t.isFeedChosen
        ? _ShopTileOver(
            now: now,
            feed: t.activeFeed!,
            onClick: () => startCheckingDialog(context, t.activeFeed!, null),
            size: size,
          )
        : Column(
            children: [
              for (var (index, f) in op.feeds.indexed)
                _ShopTileOver(
                  now: now,
                  feed: f,
                  onClick: () => startCheckingDialog(context, f, index),
                  size: size,
                )
            ],
          );
  }
}

// class OverviewPage extends StatefulWidget {
//   const OverviewPage({super.key, this.feeds, required this.goTO, this.ifEmpty});

//   final List<Feed>? feeds;
//   final Function goTO;
//   final Function? ifEmpty;

//   @override
//   State<OverviewPage> createState() => _OverviewPageState();
// }

// class _OverviewPageState extends State<OverviewPage> {
//   CountSum? day;
//   CountSum? week;
//   CountSum? month;
//   CountSum? year;
//   bool tipIsLarge = false;
//   Size? blockSize;
//   bool? rightVerion = true;

//   void _getData() async {
//     final ids = widget.feeds?.map((e) => e.id).toList();
//     var daysD = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 1))]);
//     var weeksD = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 7))]);
//     var monthsD = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 30))]);
//     var yearsD = globals.realm.query<Order>(r'date >= $0', [DateTime.now().subtract(const Duration(days: 365))]);
//     if (ids != null) {
//       if (ids.isNotEmpty) {
//         String output = '';
//         ids.asMap().forEach((key, value) {
//           output += 'feed.id == \$$key OR ';
//         });
//         output = output.substring(0, output.length - 4);
//         daysD = daysD.query(output, ids);
//         weeksD = weeksD.query(output, ids);
//         monthsD = monthsD.query(output, ids);
//         yearsD = yearsD.query(output, ids);
//       }
//     }
//     day = CountSum(daysD);
//     week = CountSum(weeksD);
//     month = CountSum(monthsD);
//     year = CountSum(yearsD);
//   }

//   // void _getFeeds() async {
//   //   if (widget.feed == null) {
//   //     feeds = globals.realm.all<Feed>().toList();
//   //   } else {
//   //     feeds = [widget.feed!];
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _getData();
//     _getVersion();
//     // _getFeeds();
//   }

//   void _getVersion() async {
//     final t = await BaseHelper.checkLastVersion();
//     setState(() => rightVerion = t);
//   }

//   Size? _getterSize() {
//     return blockSize;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final now = DateTime.now();
//     WidgetsBinding.instance.addPostFrameCallback((_) => widget.ifEmpty == null ? null : widget.ifEmpty!());
//     return ListView(padding: listBoxPadding(size), children: [
//       rightVerion != null && !rightVerion!
//           ? Container(
//               margin: const EdgeInsets.only(top: 10),
//               decoration: listBoxDecColorLess(context, color: Theme.of(context).colorScheme.primary),
//               child: ListTile(
//                 onTap: () => launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.viwi.viwi&pcampaignid=web_share'),
//                     mode: LaunchMode.externalApplication),
//                 leading: Container(
//                   decoration: listBoxDecColorLess(context, color: Theme.of(context).colorScheme.secondary),
//                   padding: const EdgeInsets.all(10),
//                   child: Icon(
//                     Icons.download,
//                     color: Theme.of(context).colorScheme.primaryContainer,
//                   ),
//                 ),
//                 title: const Text('Nová aktulizace je k dispozici!'),
//                 subtitle: Text(
//                   'Klepněte pro více informací.',
//                   style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
//                 ),
//               ))
//           : const SizedBox.shrink(),
//       Container(
//           margin: const EdgeInsets.only(top: 10, bottom: 10),
//           child: StaggeredGrid.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             children: [
//               StaggeredGridTile.count(
//                   crossAxisCellCount: 1,
//                   mainAxisCellCount: 1,
//                   child: _OverviewCard(
//                     head: 'Dnes',
//                     data: day,
//                     // onBuild: _getSizeOfOne,
//                   )),
//               StaggeredGridTile.count(
//                   crossAxisCellCount: 1,
//                   mainAxisCellCount: 1,
//                   child: _OverviewCard(
//                     head: 'Týden',
//                     data: week,
//                   )),
//               StaggeredGridTile.count(
//                   crossAxisCellCount: 1,
//                   mainAxisCellCount: 1,
//                   child: _OverviewCard(
//                     head: 'Měsíc',
//                     data: month,
//                   )),
//               StaggeredGridTile.count(
//                   crossAxisCellCount: 1,
//                   mainAxisCellCount: 1,
//                   child: _OverviewCard(
//                     head: 'Rok',
//                     data: year,
//                   )),
//             ],
//           )),
//       for (var f in widget.feeds!)
//         _ShopTileOver(
//           now: now,
//           feed: f,
//           onClick: () => widget.goTO(f),
//           size: size,
//         ),
//       Tip(
//         // getSize: _getterSize,
//         size: size,
//       )
//     ]);
//   }
// }

class _OverviewCard extends StatelessWidget {
  _OverviewCard({required this.head, this.data, this.onBuild});

  final String head;
  final CountSum? data;
  final Function? onBuild;
  final GlobalKey blockKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onBuild == null ? null : onBuild!(blockKey);
    });
    return Container(
      key: blockKey,
      decoration: listBoxDecorations(context),
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style: TextStyle(
                fontSize: 35,
                // color: globals.colorScheme.activeBackground,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${data?.count} objednávek',
                    style: TextStyle(
                        // color: Colors.black.withOpacity(0.4)
                        color: Theme.of(context).colorScheme.tertiaryContainer),
                  ),
                  Text(
                    data?.sum.toString() ?? 'unknown',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('CZK',
                      style: TextStyle(
                          // color: Colors.black.withOpacity(0.4)
                          color: Theme.of(context).colorScheme.tertiaryContainer)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

// class _CountSum {
//   _CountSum(RealmResults<Order> coll) {
//     collection = coll;
//     setOther();
//   }

//   void setOther() async {
//     count = collection.length;
//     sum = collection.fold(0.0, (previousValue, element) => previousValue + element.price).round();
//   }

//   late RealmResults<Order> collection;
//   late int count;
//   late int sum;
// }

class Tip extends StatefulWidget {
  const Tip(
      {super.key,
      // required this.getSize,
      required this.size});

  // final Function getSize;
  final Size size;

  @override
  State<Tip> createState() => _TipState();
}

class _TipState extends State<Tip> {
  bool tipIsLarge = false;
  final PageController _controller = PageController(initialPage: 0);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (_currentPage < tips.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(_currentPage, duration: const Duration(seconds: 1), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size.height / 10,
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (value) => value != _currentPage ? _currentPage = value : null,
          itemBuilder: (context, index) => Container(
              decoration: listBoxDecColorLess(context),
              child: ListTile(
                leading: Container(
                  // decoration: listBoxDecColorLess(context, color: globals.colorScheme.activeBackground),
                  decoration: listBoxDecColorLess(context, color: Theme.of(context).colorScheme.primary),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.question_mark,
                    // color: globals.colorScheme.activeChild,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                title: const Text('Věděli jste, že...'),
                subtitle: Text(
                  tips[index % tips.length],
                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                // tileColor: globals.colorScheme.inactiveBackground,
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
              )),
        ));
  }
}

class _ShopTileOver extends StatelessWidget {
  const _ShopTileOver({required this.now, required this.feed, required this.onClick, required this.size});

  final DateTime now;
  final Feed feed;
  final Function onClick;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: listBoxDecColorLess(context),
        child: ListTile(
          onTap: () => onClick(),
          leading: Container(
            // decoration: listBoxDecColorLess(context, color: globals.colorScheme.activeBackground),
            decoration: listBoxDecColorLess(context, color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.store,
              // color: globals.colorScheme.activeChild,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          title: Text(feed.name),
          subtitle: Row(
            children: [
              Text(
                'Vaše předplatné vyprší za:',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${feed.expiration?.difference(now).inDays} dní',
                style: TextStyle(
                    // color: globals.colorScheme.activeBackground,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ));
  }
}
