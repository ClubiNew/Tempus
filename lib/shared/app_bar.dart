import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool allowNavigation;
  final List<Widget>? actions;

  const CustomAppBar({
    required this.title,
    this.allowNavigation = false,
    this.actions,
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: allowNavigation,
      centerTitle: false,
      actions: actions ?? [],
    );
  }
}
