import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:viwi/globals.dart' as globals;

class InsertFeedHeader extends StatelessWidget {
  const InsertFeedHeader({super.key, required this.size, required this.current});
  final Size size;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/fullappname.svg',
          width: size.width / 2,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(height: size.height / 15),
        ShowSteps(steps: 5, current: current, size: size)
      ],
    );
  }
}

class ShowSteps extends StatelessWidget {
  const ShowSteps({super.key, required this.steps, required this.current, required this.size});

  final int steps;
  final int current;
  final Size size;

  List<Widget> getChildren() {
    List<Widget> output = [];
    for (int i = 1; i <= steps; i++) {
      output.add(_InsertStep(data: i.toString(), current: i == current));
      output.add(_LinkSteps(size: size));
    }
    output.removeLast();
    return output;
  }

  @override
  Widget build(BuildContext context) {
    final s = getChildren();
    return IntrinsicHeight(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: s));
  }
}

class _InsertStep extends StatelessWidget {
  const _InsertStep({required this.data, required this.current});

  final String data;
  final bool current;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: current
              ?
              // globals.colorScheme.activeBackground
              Theme.of(context).colorScheme.primary
              : Colors.black12.withOpacity(0.05),
          shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        data,
        style: TextStyle(
            color: current
                ?
                // globals.colorScheme.activeChild : globals.colorScheme.inactiveChild
                Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class _LinkSteps extends StatelessWidget {
  const _LinkSteps({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size.width / 10,
        child: Divider(
          color: Colors.black26,
          thickness: 1,
          height: size.height / 100,
          indent: 5,
          endIndent: 5,
        ));
  }
}
