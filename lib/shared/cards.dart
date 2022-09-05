import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const PaddedCard({
    this.padding = const EdgeInsets.all(16.0),
    required this.child,
    Key? key,
  }) : super(key: key);

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

class TitledCard extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final List<Widget>? actions;
  final Widget child;

  const TitledCard({
    this.title = "",
    this.padding = const EdgeInsets.all(16.0),
    this.actions,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return PaddedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions ?? [],
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Setting> settings;
  final String title;

  const SettingsCard({
    required this.title,
    required this.settings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: settings,
      ),
    );
  }
}

class Setting extends StatelessWidget {
  final String title;
  final Widget child;

  const Setting({
    required this.title,
    required this.child,
    Key? key,
  }) : super(key: key);

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

class CardList extends StatelessWidget {
  final List<Widget> children;

  const CardList({
    required this.children,
    Key? key,
  }) : super(key: key);

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
