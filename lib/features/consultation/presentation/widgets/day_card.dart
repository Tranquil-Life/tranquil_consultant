import 'package:flutter/material.dart';

class DayCard extends StatelessWidget {
  const DayCard(
  this.day,
  {Key? key, this.onChosen, required this.selected })
      : super(key: key);

  final Function()? onChosen;
  final bool selected;
  final String day;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
