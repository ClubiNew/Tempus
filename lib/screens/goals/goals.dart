import 'package:flutter/material.dart';
import 'package:tempus/models/goals.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/shared.dart';

import 'goal_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final GoalService goalService = GoalService();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Goals',
        actions: <Widget>[
          IconButton(
            tooltip: "Add goal",
            icon: const Icon(Icons.add),
            onPressed: () => goalService.createGoal(Goal(
              "New goal",
              {},
              DateTime.now(),
            )),
          ),
        ],
      ),
      body: FloatingDateSelect(
        startDate: date,
        onDateChanged: (date) => setState(() => this.date = date),
        child: StreamBuilder<Map<String, Goal>>(
          stream: goalService.getGoals(),
          builder: (context, snapshot) {
            List<MapEntry<String, Goal>> goals =
                snapshot.data?.entries.toList() ?? [];

            goals.sort(
              (a, b) => a.value.createdAt.compareTo(b.value.createdAt),
            );

            return PageLoader(
              snapshot: snapshot,
              itemType: 'goals',
              child: CardList(
                children: goals.map((entry) {
                  return GoalCard(
                    key: Key(entry.key),
                    goal: entry.value,
                    date: getFirestoreDate(date),
                    onChange: () =>
                        goalService.updateGoal(entry.key, entry.value),
                    onDelete: () => goalService.deleteGoal(entry.key),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(currentIndex: 1),
      ),
    );
  }
}
