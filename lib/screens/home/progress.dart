import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TitledCard(
      title: "Today's progress",
      child: FutureBuilder<OrderedPage>(
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
    );
  }
}
