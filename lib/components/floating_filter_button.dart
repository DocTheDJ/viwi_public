import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.filterSize, required this.onPressed, required this.icon, required this.name, this.childColor, this.buttonColor});
  final double filterSize;
  final Function onPressed;
  final IconData icon;
  final String? name;
  final Color? childColor;
  final Color? buttonColor;
  static const buttonText = TextStyle(fontSize: 10);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: filterSize,
      width: filterSize,
      margin: const EdgeInsets.all(10),
      child: FloatingActionButton(
        foregroundColor: childColor,
        backgroundColor: buttonColor,
        heroTag: name,
        onPressed: () => onPressed(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            name == null
                ? const SizedBox.shrink()
                : Text(
                    name!,
                    style: buttonText,
                  )
          ],
        ),
      ),
    );
  }
}

class NewFilterButton extends StatelessWidget {
  const NewFilterButton({super.key, required this.onPressed, this.name, required this.height, required this.backgroundColor, required this.childColor});

  final Function onPressed;
  final String? name;
  static const buttonText = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  final double height;
  final Color backgroundColor;
  final Color childColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) => childColor),
          backgroundColor: MaterialStateProperty.resolveWith((states) => backgroundColor),
          surfaceTintColor: MaterialStateProperty.resolveWith((states) => backgroundColor)),
      child: name == null
          ? const SizedBox.shrink()
          : Text(
              name!,
              style: buttonText,
            ),
    );
  }
}
