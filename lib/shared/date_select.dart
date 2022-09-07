import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class DateSelect extends StatefulWidget {
  final void Function(DateTime date) onDateChanged;
  final DateTime? startDate;

  const DateSelect({
    required this.onDateChanged,
    this.startDate,
    Key? key,
  }) : super(key: key);

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.startDate ?? DateTime.now();
  }

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
            DateFormat.yMMMMd().format(date),
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
  final double elevation;
  final double? width;

  final DateTime? startDate;
  final void Function(DateTime date) onDateChanged;

  final Widget child;

  const FloatingDateSelect({
    this.elevation = 3,
    this.width,
    this.startDate,
    required this.onDateChanged,
    required this.child,
    Key? key,
  }) : super(key: key);

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
                    startDate: startDate,
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
