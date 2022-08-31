import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

String getDateString(DateTime date) {
  return DateFormat.yMd().format(date);
}

class DateSelect extends StatefulWidget {
  const DateSelect({required this.onDateChanged, Key? key}) : super(key: key);
  final void Function(DateTime date) onDateChanged;

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  DateTime date = DateTime.now();

  setDate(DateTime date) {
    setState(() => this.date = date);
    widget.onDateChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setDate(date.subtract(const Duration(days: 1)));
            },
          ),
          Text(
            getDateString(date),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setDate(date.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }
}
