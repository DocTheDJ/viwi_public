import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viwi/BL/add_feed_all_provider.dart';

class AddFeedOfAll extends StatelessWidget {
  const AddFeedOfAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFeedAllProvider>(
      builder: (_, provider, __) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Text('PŘIDAT ESHOP'),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Center(),
      ),
    );
  }
}
