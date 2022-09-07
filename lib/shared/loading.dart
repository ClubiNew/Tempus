import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempus',
      builder: (context, child) {
        return const Scaffold(
          body: LoadingSpinner(),
        );
      },
    );
  }
}

class NoItems extends StatelessWidget {
  final String itemType;

  const NoItems({
    required this.itemType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.surfing, size: 50),
          ),
          Text(
            'No $itemType yet!',
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Click the"),
                Icon(Icons.add),
                Text("icon to add some."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageLoader extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final String itemType;
  final Widget child;

  const PageLoader({
    required this.snapshot,
    required this.itemType,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestBuilder<dynamic>(
      snapshot: snapshot,
      builder: (context, snapshot) {
        if (snapshot.data?.entries?.isEmpty != false) {
          return NoItems(
            itemType: itemType,
          );
        } else {
          return child;
        }
      },
    );
  }
}

class RequestBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;
  final AsyncSnapshot<T> snapshot;
  final bool mountSpinner;

  const RequestBuilder({
    required this.builder,
    required this.snapshot,
    this.mountSpinner = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(
        child: Text(
          '${snapshot.error}',
          textDirection: TextDirection.ltr,
        ),
      );
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      if (mountSpinner) {
        return const LoadingScreen();
      } else {
        return const LoadingSpinner();
      }
    } else {
      return builder(context, snapshot);
    }
  }
}
