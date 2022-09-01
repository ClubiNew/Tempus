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
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              setDate(date.subtract(const Duration(days: 1)));
            },
          ),
          Text(
            getDateString(date),
            textAlign: TextAlign.center,
          ),
          TextButton(
            child: const Icon(Icons.arrow_forward),
            onPressed: () {
              setDate(date.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }
}

class FloatingDateSelect extends StatelessWidget {
  const FloatingDateSelect({
    required this.onDateChanged,
    required this.child,
    this.elevation = 3,
    this.width,
    Key? key,
  }) : super(key: key);

  final void Function(DateTime date) onDateChanged;
  final Widget child;
  final double? width;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: width ?? MediaQuery.of(context).size.width * 0.9,
                constraints:
                    width == null ? const BoxConstraints(maxWidth: 500) : null,
                margin: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: elevation,
                  clipBehavior: Clip.antiAlias,
                  child: DateSelect(
                    onDateChanged: onDateChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
