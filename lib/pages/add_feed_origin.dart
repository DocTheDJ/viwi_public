import 'package:flutter/material.dart';
import 'package:viwi/components/inserting_step.dart';
import 'package:viwi/pages/add_feed_link.dart';
import 'package:viwi/utils/unassigned.dart';
// import 'package:viwi/globals.dart' as globals;

const List<Map<String, String>> options = [
  {'Presta 1.7+': 'p'},
  {'Presta 1.6': 'p6'},
  {'Shoptet': 's'},
];

class AddFeedOriginPage extends StatefulWidget {
  const AddFeedOriginPage({super.key, required this.name, this.colorScheme, required this.onFinish, required this.access});

  final String access;
  final String name;
  final Color? colorScheme;
  final Function onFinish;

  @override
  State<AddFeedOriginPage> createState() => _AddFeedOriginState();
}

class _AddFeedOriginState extends State<AddFeedOriginPage> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Text('Vybráni zdroje'),
          backgroundColor: widget.colorScheme,
        ),
        body: Center(
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height / 7),
                InsertFeedHeader(size: size, current: 3),
                SizedBox(height: size.height / 15),
                Container(
                    decoration: listBoxDecorations(context),
                    padding: EdgeInsets.only(left: size.width / 20, right: size.width / 20),
                    width: size.width / 1.5,
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            items: options.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem<String>(
                                value: e.values.first,
                                child: Text(e.keys.first),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value;
                              });
                            }))),
                SizedBox(height: size.height / 40),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(
                        // globals.colorScheme.activeBackground
                        Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddFeedLinkPageShoptet(
                                    access: widget.access,
                                    name: widget.name,
                                    origin: dropdownValue!,
                                    colorScheme: widget.colorScheme,
                                    onFinish: widget.onFinish,
                                  )));
                    },
                    child: Text('Pokračovat',
                        style: TextStyle(
                            // color: globals.colorScheme.activeChild
                            color: Theme.of(context).colorScheme.primaryContainer)))
              ],
            )
          ]),
        ));
  }
}
