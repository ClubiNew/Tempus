import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  const CardList({required this.children, Key? key}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 12.0),
      ].followedBy(children).followedBy([
        const SizedBox(height: 12.0),
      ]).toList(),
    );
  }
}

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

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.title,
    required this.settings,
    Key? key,
  }) : super(key: key);

  final List<Setting> settings;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return PaddedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
        ]
            .followedBy(
              settings,
            )
            .toList(),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({
    required this.title,
    required this.child,
    Key? key,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.subtitle1,
            ),
            child,
          ],
        )
      ],
    );
  }
}
