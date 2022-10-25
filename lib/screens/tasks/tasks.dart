import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';
import 'package:tempus/services/pages.dart';
import 'package:tempus/shared/shared.dart';

import 'task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final PageService pageService = PageService(PageCollections.tasks);
  late Stream<OrderedPage> pageStream;
  DateTime date = DateTime.now();
  bool showDeleteButton = false;

  @override
  void initState() {
    super.initState();
    pageStream = pageService.getPage(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderedPage>(
      stream: pageStream,
      builder: (context, snapshot) {
        final OrderedPage? page = snapshot.data;
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Tasks',
            actions: <Widget>[
              if (snapshot.connectionState != ConnectionState.waiting)
                IconButton(
                  tooltip: "Add task",
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    page!.entries.add(OrderedPageEntry());
                    pageService.savePage(page, date);
                  },
                ),
              if (snapshot.connectionState != ConnectionState.waiting)
                IconButton(
                  tooltip: "Add incomplete tasks",
                  icon: const Icon(Icons.history),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text(
                        "Would you like to add yesterday's incomplete tasks?",
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Add to Top'),
                          onPressed: () {
                            Navigator.of(context).pop();

                            DateTime yesterday =
                                date.subtract(const Duration(days: 1));

                            pageService.getPage(yesterday).first.then(
                              (previousPage) {
                                page!.entries.insertAll(
                                  0,
                                  previousPage.entries.where(
                                    (entry) => entry.active,
                                  ),
                                );

                                pageService.savePage(page, date);
                              },
                            );
                          },
                        ),
                        TextButton(
                          child: const Text('Add to Bottom'),
                          onPressed: () {
                            Navigator.of(context).pop();

                            DateTime yesterday =
                                date.subtract(const Duration(days: 1));

                            pageService.getPage(yesterday).first.then(
                              (previousPage) {
                                page!.entries.addAll(
                                  previousPage.entries.where(
                                    (entry) => entry.active,
                                  ),
                                );

                                pageService.savePage(page, date);
                              },
                            );
                          },
                        ),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              if (snapshot.connectionState != ConnectionState.waiting)
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  tooltip: "Sort by completion",
                  onPressed: () {
                    page!.entries.sort(
                      (a, b) => (a.active ? 0 : 1) - (b.active ? 0 : 1),
                    );
                    pageService.savePage(page, date);
                  },
                ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: showDeleteButton
                    ? "Hide delete buttons"
                    : "Show delete buttons",
                onPressed: () => setState(
                  () => showDeleteButton = !showDeleteButton,
                ),
              ),
            ],
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FloatingDateSelect(
              onDateChanged: (date) => setState(() {
                this.date = date;
                pageStream = pageService.getPage(date);
              }),
              child: PageLoader(
                snapshot: snapshot,
                itemType: "tasks",
                child: ReorderableListView(
                  buildDefaultDragHandles: false,
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex--;
                    }
                    final OrderedPageEntry entry =
                        page!.entries.removeAt(oldIndex);
                    page.entries.insert(newIndex, entry);
                    pageService.savePage(page, date);
                  },
                  // add footer space to account for the date select
                  footer: const SizedBox(height: 70),
                  children: page?.entries.asMap().entries.map(
                        (entry) {
                          return Task(
                            key: Key(entry.value.id),
                            index: entry.key,
                            entry: entry.value,
                            showDeleteButton: showDeleteButton,
                            onUpdate: () => pageService.savePage(page, date),
                            onDelete: () {
                              page.entries.removeAt(entry.key);
                              pageService.savePage(page, date);
                            },
                          );
                        },
                      ).toList() ??
                      [],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const Hero(
            tag: 'navbar',
            child: NavBar(currentIndex: 0),
          ),
        );
      },
    );
  }
}
