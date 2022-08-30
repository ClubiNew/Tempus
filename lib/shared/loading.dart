import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tempus",
      builder: (context, child) {
        return const Scaffold(
          body: LoadingSpinner(),
        );
      },
    );
  }
}

class RequestBuilder<T> extends StatelessWidget {
  const RequestBuilder({
    required this.builder,
    required this.snapshot,
    this.mountSpinner = false,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;
  final AsyncSnapshot<T> snapshot;
  final bool mountSpinner;

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
