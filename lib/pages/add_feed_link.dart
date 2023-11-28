import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:viwi/BL/found_states_provider.dart';
import 'package:viwi/components/inserting_step.dart';
import 'package:viwi/components/qr_test.dart';
import 'package:viwi/globals.dart' as globals;
import 'package:viwi/tables/feed/feed.dart';

import '../utils/unassigned.dart';
import 'found_states_assignment.dart';

class AddFeedLinkPageShoptet extends StatefulWidget {
  const AddFeedLinkPageShoptet({super.key, required this.name, required this.origin, this.colorScheme, required this.onFinish, required this.access});

  final String access;
  final String name;
  final String origin;
  final Color? colorScheme;
  final Function onFinish;

  @override
  State<AddFeedLinkPageShoptet> createState() => _AddFeedLinkState();
}

class _AddFeedLinkState extends State<AddFeedLinkPageShoptet> {
  final TextEditingController _controller = TextEditingController();
  Feed? createdFeed;

  void _setController(String value) {
    setState(() {
      _controller.text = value;
    });
  }

  void _setFeed(Feed val) {
    setState(() {
      createdFeed = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Text('Přidat link'),
          backgroundColor: widget.colorScheme,
        ),
        body: Center(
          child: ListView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 7),
                InsertFeedHeader(size: size, current: 4),
                SizedBox(height: size.height / 15),
                Container(
                    decoration: listBoxDecorations(context),
                    padding: EdgeInsets.only(left: size.width / 20, right: size.width / 20),
                    width: size.width / 1.5,
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'URL', border: InputBorder.none),
                    )),
                SizedBox(height: size.height / 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(
                            // globals.colorScheme.activeBackground
                            Theme.of(context).colorScheme.primary)),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRViewExample(
                                      onFinish: (value) => _setController(value),
                                    ))),
                        child: Text('Přečíst QR kód',
                            style: TextStyle(
                                // color: globals.colorScheme.activeChild
                                color: Theme.of(context).colorScheme.primaryContainer))),
                    SizedBox(width: size.width / 15),
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(
                            // globals.colorScheme.activeBackground
                            Theme.of(context).colorScheme.primary)),
                        onPressed: () async {
                          var feed = Feed(ObjectId(), widget.name, _controller.text, widget.origin, access: widget.access);
                          if (createdFeed == null) {
                            globals.realm.write(() => feed = globals.realm.add(feed));
                            _setFeed(feed);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider<FoundStatesProvider>(
                                      create: (_) => FoundStatesProvider(feed),
                                      child: FoundStatesPage(
                                        // feed: feed,
                                        onFinish: widget.onFinish,
                                        // colorScheme: widget.colorScheme,
                                      ))));
                        },
                        child: Text('Pokračovat',
                            style: TextStyle(
                                // color: globals.colorScheme.activeChild
                                color: Theme.of(context).colorScheme.primaryContainer)))
                  ],
                )
              ],
            )
          ]),
        ));
  }
}
