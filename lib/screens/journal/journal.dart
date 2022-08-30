import 'package:flutter/material.dart';
import 'package:tempus/shared/nav_bar.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Journal",
          textScaleFactor: 2,
        ),
      ),
      bottomNavigationBar: Hero(
        tag: 'navbar',
        child: NavBar(
          currentIndex: 3,
        ),
      ),
    );
  }
}
