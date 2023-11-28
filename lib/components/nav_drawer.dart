import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viwi/BL/drawer_screen_provider.dart';
import 'package:viwi/BL/overview_provider.dart';
import 'package:viwi/components/confirmation_dialog.dart';
import 'package:viwi/pages/add_feed_access.dart';
import 'package:viwi/utils/unassigned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerScreenProvider>(
        builder: (_, provider, __) => Drawer(
              // backgroundColor: globals.colorScheme.globalBackground,
              // surfaceTintColor: globals.colorScheme.globalBackground,
              backgroundColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: size.height / 6,
                      width: size.width,
                      child: DrawerHeader(
                          child: SvgPicture.asset(
                        'assets/images/fullappname.svg',
                      ))),
                  ListView(padding: listDrawerPadding(size, bottom: size.height / 33), shrinkWrap: true, children: [
                    _DrawerListItem(
                      size: size,
                      data: 'Kompletní přehled',
                      onTap: () {
                        Navigator.pop(context);
                        provider.changeToScreen(ScreenEnums.overview, null);
                        // context.read<DrawerScreenProvider>().changeCurrentScreen(ScreenEnums.overview);
                      },
                      selected: provider.activeFeed == null,
                      icon: Icons.description_outlined,
                    )
                  ]),
                  Container(
                      padding: EdgeInsets.only(bottom: size.height / 100),
                      child: Text(
                        'Aktivní eshopy',
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 16),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: size.height / 20),
                    height: size.height / 2,
                    child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                              height: size.height / 65,
                            ),
                        padding: listDrawerPadding(size, bottom: 5.0),
                        shrinkWrap: true,
                        itemCount: provider.length,
                        itemBuilder: (context, index) {
                          return _DrawerListItem(
                            size: size,
                            selected: provider.activePosition == index,
                            data: provider.getWanted(index).name,
                            onTap: () => startCheckingDialog(context, provider.getWanted(index), index),
                            onLongPress: () => confirmationDialog(context, provider.getWanted(index)),
                          );
                        }),
                  ),
                  ListView(
                    padding: EdgeInsets.only(left: size.width / 6, right: size.width / 6),
                    shrinkWrap: true,
                    children: [
                      _LessUsedItem(
                        size: size,
                        data: 'PŘIDAT ESHOP',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddFeedAccessPage(
                                      onFinish: () {
                                        provider.refreshfeeds();
                                        context.read<OverviewProvider>().refresh();
                                      },
                                    ))),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }
}

class _DrawerListItem extends StatelessWidget {
  const _DrawerListItem({required this.size, required this.data, required this.onTap, required this.selected, this.icon, this.onLongPress});

  final Size size;
  final String data;
  final Function onTap;
  final Function? onLongPress;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        onLongPress: () => onLongPress!(),
        child: Container(
            decoration: listBoxDecoVariable(context, const BorderRadius.all(Radius.circular(17)), selected: selected),
            padding: EdgeInsets.only(top: size.height / 80, bottom: size.height / 80),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              icon == null
                  ? const SizedBox.shrink()
                  : Container(
                      margin: EdgeInsets.only(right: size.width / 80),
                      child: Icon(
                        icon,
                        color: selected ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.secondary,
                      )),
              Text(data,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: selected ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.secondary,
                  ))
            ])));
  }
}

class _LessUsedItem extends StatelessWidget {
  const _LessUsedItem({required this.size, required this.data, required this.onTap});

  final Size size;
  final String data;
  final Function onTap;
  // final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: const BorderRadius.all(Radius.circular(17)),
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0.0, 1.0), blurRadius: 6.0)]),
            padding: EdgeInsets.only(top: size.height / 80, bottom: size.height / 80),
            alignment: Alignment.center,
            child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                data,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.tertiary),
              )
            ])));
  }
}
