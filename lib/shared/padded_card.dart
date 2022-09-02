import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  const PaddedCard({
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    Key? key,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32.0,
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      child: Card(
        elevation: 2,
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
