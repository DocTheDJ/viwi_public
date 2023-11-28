import 'package:flutter/material.dart';
import 'package:viwi/components/inserting_step.dart';
import 'package:viwi/pages/add_feed_origin.dart';
import 'package:viwi/utils/unassigned.dart';
// import 'package:viwi/globals.dart' as globals;

class AddFeedNamePage extends StatefulWidget {
  const AddFeedNamePage({super.key, this.colorScheme, required this.onFinish, required this.access});

  final String access;
  final Color? colorScheme;
  final Function onFinish;

  @override
  State<AddFeedNamePage> createState() => _AddFeedNameState();
}

class _AddFeedNameState extends State<AddFeedNamePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Text('Název eshopu'),
          backgroundColor: widget.colorScheme,
        ),
        body: Center(
          child: ListView(
            children: [
              Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: size.height / 7),
                InsertFeedHeader(size: size, current: 2),
                SizedBox(height: size.height / 15),
                Container(
                    decoration: listBoxDecorations(context),
                    padding: EdgeInsets.only(left: size.width / 20, right: size.width / 20),
                    width: size.width / 1.5,
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Název', border: InputBorder.none),
                    )),
                SizedBox(height: size.height / 40),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(
                        // globals.colorScheme.activeBackground
                        Theme.of(context).colorScheme.primary)),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddFeedOriginPage(
                                        access: widget.access,
                                        name: _controller.text,
                                        colorScheme: widget.colorScheme,
                                        onFinish: widget.onFinish,
                                      )))
                        },
                    child: Text(
                      'Pokračovat',
                      style: TextStyle(
                          // color: globals.colorScheme.activeChild
                          color: Theme.of(context).colorScheme.primaryContainer),
                    ))
              ])
            ],
          ),
        ));
  }
}
