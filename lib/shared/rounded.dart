import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final void Function() onPressed;
  final String tooltip;
  final Icon icon;

  const RoundedIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: tooltip,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16.0),
          ),
          child: icon,
        ),
      ),
    );
  }
}
