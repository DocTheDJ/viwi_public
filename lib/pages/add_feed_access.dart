// import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:viwi/components/inserting_step.dart';
import 'package:viwi/components/qr_test.dart';
import 'package:viwi/pages/add_feed_name.dart';
import 'package:viwi/utils/unassigned.dart';
// import 'package:viwi/globals.dart' as globals;

class AddFeedAccessPage extends StatefulWidget {
  const AddFeedAccessPage({super.key, this.colorScheme, required this.onFinish});
  final Color? colorScheme;
  final Function onFinish;
  @override
  State<AddFeedAccessPage> createState() => _AddFeedAccessState();
}

class _AddFeedAccessState extends State<AddFeedAccessPage> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  bool activateLoading = false;
  String? errorMsg;
  bool continueSetup = false;

  void _setContol(String value) {
    setState(() {
      _controller.text = value;
    });
  }

  void _setController() {
    setState(() {
      activateLoading = true;
      errorMsg = null;
      // _controller.text = value;
    });
    _startIsolate();
  }

  void _startIsolate() async {
    final value = _controller.text;
    if (value == '') {
      return;
    }
    final passPort = ReceivePort();
    var info = await getInfo();
    final d = await Isolate.spawn(tokenActivation, [value, passPort.sendPort, info, true], onExit: passPort.sendPort, paused: true);
    d.addOnExitListener(passPort.sendPort);
    passPort.listen((message) {
      if (message != null) {
        if (message == '1') {
          setState(() {
            activateLoading = false;
            continueSetup = true;
          });
        } else {
          setState(() {
            activateLoading = false;
            errorMsg = message;
          });
        }
      } else {
        setState(() {
          activateLoading = false;
        });
        d.removeOnExitListener(passPort.sendPort);
      }
    });
    d.resume(d.pauseCapability!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('Přístupový token'),
        backgroundColor: widget.colorScheme,
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 7),
                InsertFeedHeader(size: size, current: 1),
                SizedBox(height: size.height / 15),
                Container(
                    decoration: listBoxDecorations(context),
                    padding: EdgeInsets.only(left: size.width / 20, right: size.width / 20),
                    width: size.width / 1.5,
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Token', border: InputBorder.none),
                      onEditingComplete: _setController,
                    )),
                activateLoading
                    ? _Loading(size: size)
                    : errorMsg == null
                        ? const SizedBox.shrink()
                        : _Error(size: size, msg: errorMsg!),
                SizedBox(height: size.height / 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(
                            // globals.colorScheme.activeBackground
                            Theme.of(context).colorScheme.primary)),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRViewExample(
                                      onFinish: (value) {
                                        _setContol(value);
                                        _setController();
                                      },
                                    ))),
                        child: Text('Přečíst QR kód',
                            style: TextStyle(
                                // color: globals.colorScheme.activeChild
                                color: Theme.of(context).colorScheme.primaryContainer))),
                    SizedBox(width: size.width / 15),
                    continueSetup
                        ? ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(
                                // globals.colorScheme.activeBackground
                                Theme.of(context).colorScheme.primary)),
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddFeedNamePage(
                                                access: _controller.text,
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
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.size});

  final Size size;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: size.height / 40),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.size, required this.msg});

  final String msg;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: size.height / 40),
        Text(
          msg,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
