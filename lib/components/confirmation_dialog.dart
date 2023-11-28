import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:viwi/BL/found_states_provider.dart';
import 'package:viwi/BL/overview_provider.dart';
import 'package:viwi/pages/found_states_assignment.dart';
import 'package:viwi/tables/feed/feed.dart';
import 'package:provider/provider.dart';
import 'package:viwi/BL/drawer_screen_provider.dart';
import 'package:viwi/utils/delete_feed.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/utils/unassigned.dart';

void confirmationDialog(BuildContext context, Feed feed) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.surface,
            title: Text('Určite si přejete smazat: "${feed.name}" ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    _startDeletionDialog(context, feed).then((val) {
                      if (val) {
                        context.read<OverviewProvider>().delete(feed);
                        context.read<DrawerScreenProvider>().refreshfeeds();
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                      }
                    });
                  },
                  child: const Text('Ano')),
              TextButton(
                  onPressed: () {
                    deleteFeedData(feed);
                    globals.realm.write(() => feed.lastUpdate = null);
                    final o = context.read<OverviewProvider>();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider<FoundStatesProvider>(
                                create: (_) => FoundStatesProvider(feed),
                                child: FoundStatesPage(
                                  onFinish: () => o.refresh(),
                                )))).then((value) => o.refresh());
                  },
                  child: const Text('Aktualizace')),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ne'),
              )
            ],
          ));
}

Future<dynamic> _startDeletionDialog(BuildContext context, Feed feed) async {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        bool isChecking = true;
        String msg = '';
        bool ran = false;
        return StatefulBuilder(builder: (context, setState) {
          if (!ran) {
            setState(() => ran = true);
            startDeletionSolate(
                feed,
                (t) => setState(
                      () {
                        isChecking = false;
                        msg = t;
                      },
                    ), () {
              Navigator.pop(context, true);
            });
          }
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text('Deaktivace tokenu.'), isChecking ? const CircularProgressIndicator() : Text(msg)],
            ),
            actions: [
              msg == ''
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('Zavřít'))
            ],
          );
        });
      });
}

void startCheckingDialog(BuildContext context, Feed feed, int? position) async {
  final d = context.read<DrawerScreenProvider>();
  if (feed.lastAccessCheck == null || feed.expiration!.isBefore(DateTime.now()) || feed.lastAccessCheck!.day < DateTime.now().day) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          bool isChecking = true;
          String msg = '';
          bool ran = false;
          return StatefulBuilder(builder: (context, setState) {
            if (!ran) {
              setState(() => ran = true);
              _startCheckTokenIsolate(
                  feed,
                  (t) => setState(
                        () {
                          isChecking = false;
                          msg = t;
                        },
                      ), () {
                globals.realm.write(() => feed.lastAccessCheck = DateTime.now());
                d.changeToScreen(ScreenEnums.orderlist, position);
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              });
            }
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('Kontrola platnosti tokenu.'), isChecking ? const CircularProgressIndicator() : Text(msg)],
              ),
              actions: [
                msg == ''
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Zavřít'))
              ],
            );
          });
        });
  } else {
    d.changeToScreen(ScreenEnums.orderlist, position);
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }
}

void _startCheckTokenIsolate(Feed feed, action, okAction) async {
  final passPort = ReceivePort();
  var device = await getInfo();
  final value = feed.access;
  final d = await Isolate.spawn(tokenViability, [value, passPort.sendPort, device], onExit: passPort.sendPort, paused: true);
  d.addOnExitListener(passPort.sendPort);
  passPort.listen((message) {
    if (message != null) {
      if (message is DateTime) {
        action('');
        okAction();
        globals.realm.write(() => feed.expiration = message);
      } else {
        action('Token již není platný.');
      }
    } else {
      d.removeOnExitListener(passPort.sendPort);
    }
  });
  d.resume(d.pauseCapability!);
}
