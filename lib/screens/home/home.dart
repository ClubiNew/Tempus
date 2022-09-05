import 'package:flutter/material.dart';
import 'package:tempus/shared/shared.dart';

import 'progress.dart';
import 'user.dart';
import 'note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: focusNode.unfocus,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Home',
        ),
        body: CardList(
          children: [
            const UserCard(),
            const ProgressCard(),
            NoteCard(
              focusNode: focusNode,
            ),
          ],
        ),
        bottomNavigationBar: const Hero(
          tag: 'navbar',
          child: NavBar(
            currentIndex: 2,
          ),
        ),
      ),
    );
  }
}
