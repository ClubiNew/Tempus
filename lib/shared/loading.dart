import 'package:flutter/material.dart';

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
