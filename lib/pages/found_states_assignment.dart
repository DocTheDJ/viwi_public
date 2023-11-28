import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viwi/BL/found_states_provider.dart';
import 'package:viwi/components/inserting_step.dart';
import 'package:viwi/tables/feed/feed.dart';
import 'package:viwi/tables/state/state.dart';
import 'package:viwi/globals.dart' as globals;
// import 'package:collection/collection.dart';
import 'package:viwi/utils/unassigned.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FoundStatesPage extends StatelessWidget {
  const FoundStatesPage({super.key, required this.onFinish, this.colorScheme});

  final Function onFinish;
  final Color? colorScheme;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<FoundStatesProvider>().startImport(context);
    return Consumer<FoundStatesProvider>(
        builder: (_, provider, __) => Scaffold(
            appBar: AppBar(
              title: const Text('Nalezené stavy'),
              backgroundColor: colorScheme,
            ),
            body: Center(
                child: provider.loading
                    ? ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: size.width / 10, right: size.width / 10),
                        children: [
                          Text('${(provider.progress * 100).toStringAsFixed(3)} %'),
                          LinearProgressIndicator(
                            value: provider.progress,
                            color: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          Text(provider.message),
                        ],
                      )
                    // ListView(shrinkWrap: true, padding: EdgeInsets.only(left: size.width / 10, right: size.width / 10), children: [
                    //     Text('${provider.progress.toStringAsFixed(3)} %'),
                    //     LinearProgressIndicator(
                    //       value: provider.progress,
                    //       color: Theme.of(context).colorScheme.primary,
                    //       backgroundColor: Theme.of(context).colorScheme.secondary,
                    //     )
                    //   ])
                    : ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height / 7),
                              InsertFeedHeader(size: size, current: 5),
                              SizedBox(height: size.height / 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StatesListPage(
                                                    feed: provider.feed,
                                                    colorScheme: colorScheme,
                                                  ))),
                                      child: Text(
                                        'Stavy',
                                        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
                                      )),
                                  SizedBox(width: size.width / 15),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)),
                                      onPressed: () {
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                        onFinish();
                                      },
                                      child: Text('Pokračovat', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)))
                                ],
                              ),
                              Text(provider.message),
                            ],
                          )
                        ],
                      ))));
  }
}

class StatesListPage extends StatefulWidget {
  const StatesListPage({super.key, required this.feed, this.colorScheme});

  final Feed feed;
  final Color? colorScheme;

  @override
  State<StatesListPage> createState() => _StatesListState();
}

class _StatesListState extends State<StatesListPage> {
  List<StateDB> states = [];

  void _getStates() async {
    setState(() {
      states = globals.realm.query<StateDB>(r'feed.id = $0', [widget.feed.id]).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getStates();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stavy'),
        backgroundColor: widget.colorScheme,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         globals.realm.write(() => globals.realm.addAll(states, update: true));
        //         Navigator.pop(context);
        //       },
        //       icon: const Icon(Icons.save))
        // ],
      ),
      body: Center(
        child: ListView.builder(
          padding: listDrawerPadding(size),
          shrinkWrap: true,
          itemCount: states.length,
          itemBuilder: (context, index) => GestureDetector(
              onTap: () => getColor(states[index]),
              child: Card(
                  color: Color(states[index].colorState),
                  child: Container(padding: const EdgeInsets.all(10), alignment: Alignment.center, child: Text(states[index].name)))),
        ),
      ),
    );
  }

  void getColor(StateDB target) {
    Color pickerColor = Color(target.colorState);
    void changeColor(Color newColor) {
      setState(() => pickerColor = newColor);
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Vyber barvu'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
              ),
              actions: [
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Zrusit')),
                ElevatedButton(
                    onPressed: () {
                      globals.realm.write(() => setState(() => target.colorState = pickerColor.value));
                      // setState(() => target.colorState = pickerColor.value);
                      Navigator.pop(context);
                    },
                    child: const Text('Ulozit'))
              ],
            ));
  }
}
