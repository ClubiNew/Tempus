import 'package:flutter/material.dart';
import 'package:tempus/models/goals.dart';
import 'package:tempus/shared/shared.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final String date;

  final void Function() onChange;
  final void Function() onDelete;

  const GoalCard({
    required this.goal,
    required this.date,
    required this.onChange,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: widget.goal.objective,
      actions: [
        EditPopup(
          onDelete: widget.onDelete,
          onRename: (String text) {
            widget.goal.objective = text;
            widget.onChange();
          },
        ),
      ],
      child: Slider(
        value: widget.goal.progress[widget.date] ?? 0.0,
        onChanged: (double newValue) {
          setState(() => widget.goal.progress[widget.date] = newValue);
        },
        onChangeEnd: (double newValue) {
          widget.onChange();
        },
      ),
    );
  }
}
