import 'package:flutter/material.dart';
import 'package:tempus/models/models.dart';
import 'package:tempus/services/services.dart';
import 'package:tempus/shared/cards.dart';
import 'package:tempus/shared/loading.dart';
import 'package:tempus/shared/progress_bar.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({Key? key}) : super(key: key);

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  final PageService pageService = PageService(PageCollections.tasks);
  final GoalService goalService = GoalService();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TitledCard(
      title: "Today's progress",
      child: Column(
        children: [
          FutureBuilder<OrderedPage>(
            future: pageService.getPage(DateTime.now()).first,
            builder: (context, snapshot) => RequestBuilder<OrderedPage>(
              snapshot: snapshot,
              builder: (context, snapshot) {
                OrderedPage page = snapshot.data!;
                int completedTasks =
                    page.entries.where((entry) => !entry.active).length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(
                      value: page.entries.isNotEmpty
                          ? completedTasks / page.entries.length
                          : 0.0,
                    ),
                    Text(
                      "$completedTasks/${page.entries.length} tasks completed",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                );
              },
            ),
          ),
          FutureBuilder<Map<String, Goal>>(
            future: goalService.getGoals().first,
            builder: (context, snapshot) => RequestBuilder<Map<String, Goal>>(
              snapshot: snapshot,
              builder: (context, snapshot) {
                String dateString = getFirestoreDate(DateTime.now());
                Iterable<Goal> goals = snapshot.data!.values;

                double progressSum = goals.fold(
                  0,
                  (previousValue, element) {
                    double goalProgress = element.progress[dateString] ?? 0.0;
                    return previousValue + goalProgress;
                  },
                );

                double totalProgress =
                    goals.isEmpty ? 0.0 : progressSum / goals.length;
                int totalPercentage = (totalProgress * 100).round();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(
                      value: totalProgress,
                    ),
                    Text(
                      "$totalPercentage% of goals completed",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
