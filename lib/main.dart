// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viwi/BL/add_feed_all_provider.dart';
import 'package:viwi/BL/drawer_screen_provider.dart';
import 'package:viwi/BL/order_detail_provider.dart';
import 'package:viwi/BL/orders_provider.dart';
import 'package:viwi/BL/overview_provider.dart';
import 'package:viwi/components/floating_filter_button.dart';
import 'package:viwi/components/nav_drawer.dart';
import 'package:viwi/pages/add_feed_access.dart';
import 'package:viwi/pages/found_states_assignment.dart';
import 'package:viwi/pages/order_list.dart';
import 'package:viwi/pages/overview.dart';
import 'package:viwi/tables/feed/feed.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viwi/tables/state/state.dart';
import 'package:viwi/theme/dark_theme.dart';
import 'package:viwi/theme/light_theme.dart';
import 'package:viwi/utils/delete_feed.dart';
import 'package:viwi/utils/unassigned.dart';
import 'globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DrawerScreenProvider>(create: (_) => DrawerScreenProvider()),
    ChangeNotifierProvider<OverviewProvider>(create: (context) => OverviewProvider(context)),
    ChangeNotifierProxyProvider<DrawerScreenProvider, OrdersProvider>(
        create: (_) => OrdersProvider(null), update: (_, feed, __) => OrdersProvider(feed.activeFeed)),
    ChangeNotifierProvider<OrderDetailProvider>(create: (_) => OrderDetailProvider()),
    ChangeNotifierProvider<AddFeedAllProvider>(create: (_) => AddFeedAllProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViWi',
      theme: lightTheme,
      darkTheme: darkTheme,
      // theme: ThemeData(
      //   primaryColor: globals.colorScheme.inactiveBackground,
      //   useMaterial3: true,
      // ),
      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!);
      },
      home: Origin(),
    );
  }
}

class Origin extends StatelessWidget {
  Origin({super.key});

  final DateFormat format = DateFormat('dd.MM.yyyy | HH:mm');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final filterHeight = MediaQuery.of(context).size.height / 15;
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<DrawerScreenProvider>(
        builder: (_, provider, __) => Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              bottomOpacity: 0.5,
              bottom: provider.activeFeed == null
                  ? null
                  : PreferredSize(
                      preferredSize: Size.zero,
                      child: Text(
                        format.format(provider.activeFeed?.lastUpdate?.toLocal() ?? DateTime.now().subtract(const Duration(days: 365))),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
              title: Text(provider.activeFeed?.name ?? 'Prehled'),
              centerTitle: true,
              actions: [
                provider.isFeedChosen
                    ? IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StatesListPage(feed: provider.activeFeed!)))
                            .then((value) => context.read<OrdersProvider>().refreshOrders()),
                        icon: const Icon(Icons.settings))
                    : const SizedBox.shrink(),
              ],
            ),
            backgroundColor: colorScheme.background,
            drawer: NavDrawer(size: size),
            body: provider.currentScreen,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: provider.isFeedChosen && !context.watch<OrdersProvider>().isScreenDetial
                ? SizedBox(
                    height: size.height / 11,
                    child: Consumer<OrdersProvider>(
                        builder: (_, bloc, __) => ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => NewFilterButton(
                                  onPressed: () => bloc.setActive(index),
                                  height: filterHeight,
                                  name: bloc.filters?[index].name,
                                  backgroundColor: bloc.isActive(index) ? colorScheme.primary : colorScheme.secondaryContainer,
                                  childColor: bloc.isActive(index) ? colorScheme.primaryContainer : colorScheme.secondary,
                                ),
                            separatorBuilder: (context, index) => const SizedBox(
                                  width: 10,
                                ),
                            itemCount: bloc.filters?.length ?? 0)))
                : null));
  }

  // void _confirmationDialog(BuildContext context, Feed feed) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //             // backgroundColor: globals.colorScheme.globalBackground,
  //             // surfaceTintColor: globals.colorScheme.globalBackground,
  //             backgroundColor: Theme.of(context).colorScheme.background,
  //             surfaceTintColor: Theme.of(context).colorScheme.surface,
  //             title: Text('Určite si přejete smazat: "${feed.name}" ?'),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     _startDeletionDialog(context, feed).then((val) {
  //                       if (val) {
  //                         context.read<OverviewProvider>().delete(feed);
  //                         context.read<DrawerScreenProvider>().refreshfeeds();
  //                         Navigator.canPop(context) ? Navigator.pop(context) : null;
  //                       }
  //                     });
  //                   },
  //                   child: const Text('Ano')),
  //               TextButton(
  //                   onPressed: () {
  //                     deleteFeedData(feed);
  //                     globals.realm.write(() => feed.lastUpdate = null);
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => FoundStatesPage(
  //                                   feed: feed,
  //                                   onFinish: () => context.read<OverviewProvider>().refresh(),
  //                                 )));
  //                   },
  //                   child: const Text('Aktualizace')),
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('Ne'),
  //               )
  //             ],
  //           ));
  // }

  // Future<dynamic> _startDeletionDialog(BuildContext context, Feed feed) async {
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         bool isChecking = true;
  //         String msg = '';
  //         bool ran = false;
  //         return StatefulBuilder(builder: (context, setState) {
  //           if (!ran) {
  //             setState(() => ran = true);
  //             startDeletionSolate(
  //                 feed,
  //                 (t) => setState(
  //                       () {
  //                         isChecking = false;
  //                         msg = t;
  //                       },
  //                     ), () {
  //               Navigator.pop(context, true);
  //             });
  //           }
  //           return AlertDialog(
  //             actionsAlignment: MainAxisAlignment.center,
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [const Text('Deaktivace tokenu.'), isChecking ? const CircularProgressIndicator() : Text(msg)],
  //             ),
  //             actions: [
  //               msg == ''
  //                   ? const SizedBox.shrink()
  //                   : TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context, false);
  //                       },
  //                       child: const Text('Zavřít'))
  //             ],
  //           );
  //         });
  //       });
  // }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
//   Widget? page;
//   List<Feed> nav = [];
//   bool floatingFilter = false;
//   final StreamController _controller = StreamController.broadcast();
//   String appbarTitle = 'Přehled';
//   DateTime? appbarTime;
//   Feed? currFeed;
//   dynamic activeButton = 0;
//   final DateFormat format = DateFormat('dd.MM.yyyy | HH:mm');
//   List<ButtonHelper> filters = [];

//   void _setPage(Feed data) {
//     _setActiveButton(0);
//     _controller.add(activeButton);
//     _createFilters(data);
//     setState(() {
//       page = OrderListPage(
//         key: GlobalKey(),
//         feed: data,
//         filter: _controller.stream,
//         onFocus: _setFilterVis,
//         dateUpdate: _updateDate,
//       );
//       floatingFilter = true;
//       appbarTitle = data.name;
//       appbarTime = data.lastUpdate?.toLocal();
//       currFeed = data;
//     });
//   }

//   void _createFilters(Feed data) {
//     final states = globals.realm.query<StateDB>(r'feed.id == $0', [data.id]);
//     final manual = [
//       ButtonHelper(name: 'Přehled', value: null),
//       ButtonHelper(name: 'Všechny', value: 0),
//       ...states.map((e) => ButtonHelper(name: e.name, value: e))
//     ];
//     setState(() {
//       filters = manual;
//     });
//   }

//   void _setOverview() {
//     setState(() {
//       page = OverviewPage(
//         goTO: (feed) => _startCheckingDialog(feed),
//         ifEmpty: _checkForEmpty,
//         feeds: nav,
//       );
//       floatingFilter = false;
//       appbarTitle = 'Přehled';
//       appbarTime = null;
//       currFeed = null;
//     });
//   }

//   void _updateDate(Feed feed) {
//     setState(() {
//       appbarTime = feed.lastUpdate?.toLocal();
//     });
//   }

//   void _setFilterVis(bool vis) {
//     setState(() {
//       floatingFilter = vis;
//     });
//   }

//   void _getFeeds() {
//     final test = globals.realm.all<Feed>();
//     setState(() {
//       nav = test.toList();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getFeeds();
//     _setOverview();
//   }

//   void _setActiveButton(dynamic val) {
//     setState(() {
//       activeButton = val;
//     });
//   }

//   void _setFilter(dynamic val) {
//     _setActiveButton(val);
//     _controller.add(val);
//   }

//   void _checkForEmpty() {
//     if (nav.isEmpty) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => AddFeedAccessPage(
//                     onFinish: () {
//                       _getFeeds();
//                       _setOverview();
//                     },
//                   )));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final filterHeight = MediaQuery.of(context).size.height / 15;
//     final colorScheme = Theme.of(context).colorScheme;
//     return Scaffold(
//         appBar: AppBar(
//           scrolledUnderElevation: 0.0,
//           // backgroundColor: globals.colorScheme.globalBackground,
//           // backgroundColor: Theme.of(context).colorScheme.background,
//           bottomOpacity: 0.5,
//           bottom: appbarTime == null
//               ? null
//               : PreferredSize(
//                   preferredSize: Size.zero,
//                   child: Text(
//                     format.format(appbarTime!),
//                     style: const TextStyle(fontSize: 15),
//                   ),
//                 ),
//           title: Text(appbarTitle),
//           centerTitle: true,
//           actions: [
//             currFeed == null
//                 ? const SizedBox.shrink()
//                 : IconButton(
//                     onPressed: () =>
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => StatesListPage(feed: currFeed!))).then((value) => _setFilter(null)),
//                     icon: const Icon(Icons.settings)),
//           ],
//         ),
//         // backgroundColor: globals.colorScheme.globalBackground,
//         backgroundColor: colorScheme.background,
//         drawer: Drawer(
//           // backgroundColor: globals.colorScheme.globalBackground,
//           // surfaceTintColor: globals.colorScheme.globalBackground,
//           backgroundColor: colorScheme.background,
//           surfaceTintColor: colorScheme.background,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                   height: size.height / 6,
//                   width: size.width,
//                   child: DrawerHeader(
//                       child: SvgPicture.asset(
//                     'assets/images/fullappname.svg',
//                   ))),
//               ListView(padding: listDrawerPadding(size, bottom: size.height / 33), shrinkWrap: true, children: [
//                 _DrawerListItem(
//                   size: size,
//                   data: 'Kompletní přehled',
//                   onTap: () {
//                     Navigator.pop(context);
//                     _setOverview();
//                   },
//                   selected: currFeed == null,
//                   icon: Icons.description_outlined,
//                 )
//               ]),
//               Container(
//                   padding: EdgeInsets.only(bottom: size.height / 100),
//                   child: Text(
//                     'Aktivní eshopy',
//                     style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 16),
//                   )),
//               Container(
//                 margin: EdgeInsets.only(bottom: size.height / 20),
//                 height: size.height / 2,
//                 child: ListView.separated(
//                     separatorBuilder: (context, index) => SizedBox(
//                           height: size.height / 65,
//                         ),
//                     padding: listDrawerPadding(size, bottom: 5.0),
//                     shrinkWrap: true,
//                     itemCount: nav.length,
//                     itemBuilder: (context, index) {
//                       return _DrawerListItem(
//                         size: size,
//                         selected: nav[index] == currFeed,
//                         data: nav[index].name,
//                         onTap: () {
//                           _startCheckingDialog(nav[index]);
//                         },
//                         onLongPress: () => _conformationDialog(context, nav[index]),
//                       );
//                     }),
//               ),
//               ListView(
//                 padding: EdgeInsets.only(left: size.width / 6, right: size.width / 6),
//                 shrinkWrap: true,
//                 children: [
//                   _LessUsedItem(
//                     size: size,
//                     data: 'PŘIDAT ESHOP',
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AddFeedAccessPage(
//                                   onFinish: () {
//                                     _getFeeds();
//                                     // setState(() {
//                                     //   page = null;
//                                     // });
//                                     _setOverview();
//                                   },
//                                 ))),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//         body: page,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: floatingFilter
//             ? SizedBox(
//                 height: size.height / 11,
//                 child: ListView.separated(
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.all(8),
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) => NewFilterButton(
//                           onPressed: () => _setFilter(filters[index].value),
//                           height: filterHeight,
//                           name: filters[index].name,
//                           backgroundColor: activeButton == filters[index].value ? colorScheme.primary : colorScheme.secondaryContainer,
//                           childColor: activeButton == filters[index].value ? colorScheme.primaryContainer : colorScheme.secondary,
//                         ),
//                     separatorBuilder: (context, index) => const SizedBox(
//                           width: 10,
//                         ),
//                     itemCount: filters.length))
//             : null);
//   }

//   void _startCheckingDialog(Feed feed) async {
//     if (feed.lastAccessCheck == null || feed.lastAccessCheck!.day < DateTime.now().day) {
//       showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             bool isChecking = true;
//             String msg = '';
//             bool ran = false;
//             return StatefulBuilder(builder: (context, setState) {
//               if (!ran) {
//                 setState(() => ran = true);
//                 _startCheckTokenIsolate(
//                     feed,
//                     (t) => setState(
//                           () {
//                             isChecking = false;
//                             msg = t;
//                           },
//                         ), () {
//                   globals.realm.write(() => feed.lastAccessCheck = DateTime.now());
//                   _setPage(feed);
//                   Navigator.canPop(context) ? Navigator.pop(context) : null;
//                   Navigator.canPop(context) ? Navigator.pop(context) : null;
//                   // });
//                 });
//               }
//               return AlertDialog(
//                 actionsAlignment: MainAxisAlignment.center,
//                 backgroundColor: Theme.of(context).colorScheme.background,
//                 surfaceTintColor: Theme.of(context).colorScheme.background,
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [const Text('Kontrola platnosti tokenu.'), isChecking ? const CircularProgressIndicator() : Text(msg)],
//                 ),
//                 actions: [
//                   msg == ''
//                       ? const SizedBox.shrink()
//                       : TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text('Zavřít'))
//                 ],
//               );
//             });
//           });
//     } else {
//       _setPage(feed);
//       Navigator.canPop(context) ? Navigator.pop(context) : null;
//     }
//   }

//   void _startCheckTokenIsolate(Feed feed, action, okAction) async {
//     final passPort = ReceivePort();
//     var device = await getInfo();
//     final value = feed.access;
//     final d = await Isolate.spawn(tokenViability, [value, passPort.sendPort, device], onExit: passPort.sendPort, paused: true);
//     d.addOnExitListener(passPort.sendPort);
//     passPort.listen((message) {
//       if (message != null) {
//         if (message is DateTime) {
//           action('');
//           okAction();
//           globals.realm.write(() => feed.expiration = message);
//         } else {
//           action('Token již není platný.');
//         }
//       } else {
//         d.removeOnExitListener(passPort.sendPort);
//       }
//     });
//     d.resume(d.pauseCapability!);
//   }

//   Future<dynamic> _startDeletionDialog(Feed feed) async {
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           bool isChecking = true;
//           String msg = '';
//           bool ran = false;
//           return StatefulBuilder(builder: (context, setState) {
//             if (!ran) {
//               setState(() => ran = true);
//               startDeletionSolate(
//                   feed,
//                   (t) => setState(
//                         () {
//                           isChecking = false;
//                           msg = t;
//                         },
//                       ), () {
//                 Navigator.pop(context, true);
//               });
//             }
//             return AlertDialog(
//               actionsAlignment: MainAxisAlignment.center,
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [const Text('Deaktivace tokenu.'), isChecking ? const CircularProgressIndicator() : Text(msg)],
//               ),
//               actions: [
//                 msg == ''
//                     ? const SizedBox.shrink()
//                     : TextButton(
//                         onPressed: () {
//                           Navigator.pop(context, false);
//                         },
//                         child: const Text('Zavřít'))
//               ],
//             );
//           });
//         });
//   }

//   void _conformationDialog(BuildContext context, Feed feed) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               // backgroundColor: globals.colorScheme.globalBackground,
//               // surfaceTintColor: globals.colorScheme.globalBackground,
//               backgroundColor: Theme.of(context).colorScheme.background,
//               surfaceTintColor: Theme.of(context).colorScheme.surface,
//               title: Text('Určite si přejete smazat: "${feed.name}" ?'),
//               actions: [
//                 TextButton(
//                     onPressed: () {
//                       _startDeletionDialog(feed).then((val) {
//                         if (val) {
//                           // _setPage(feed);
//                           deleteFeed(feed, _getFeeds);
//                           _getFeeds();
//                           // setState(() {
//                           //   page = null;
//                           // });
//                           _setOverview();
//                           Navigator.canPop(context) ? Navigator.pop(context) : null;
//                         }
//                       });
//                     },
//                     child: const Text('Ano')),
//                 TextButton(
//                     onPressed: () {
//                       deleteFeedData(feed);
//                       globals.realm.write(() => feed.lastUpdate = null);
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => FoundStatesPage(
//                                     feed: feed,
//                                     onFinish: () => _setPage(feed),
//                                   )));
//                     },
//                     child: const Text('Aktualizace')),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Ne'),
//                 )
//               ],
//             ));
//   }
// }
