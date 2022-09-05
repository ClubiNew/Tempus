import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';
import 'package:tempus/services/pages.dart';
import 'package:tempus/shared/shared.dart';

import 'note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final PageService pageService = PageService(PageCollections.notes);
  late Stream<OrderedPage> pageStream;

  DateTime date = DateTime.now();
  FocusNode? focusNode;

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
        return GestureDetector(
          onTap: () => focusNode?.unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Notes',
              actions: <Widget>[
                if (snapshot.connectionState != ConnectionState.waiting)
                  IconButton(
                    tooltip: "Add section",
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      page!.entries.add(OrderedPageEntry());
                      pageService.savePage(page, date);
                    },
                  ),
                if (snapshot.connectionState != ConnectionState.waiting)
                  IconButton(
                    tooltip: "Copy previous sections",
                    icon: const Icon(Icons.history),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                          "Would you like to copy yesterday's sections?",
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop();

                              DateTime yesterday =
                                  date.subtract(const Duration(days: 1));

                              pageService.getPage(yesterday).first.then(
                                (previousPage) {
                                  for (var entry in previousPage.entries) {
                                    page!.entries.add(
                                        OrderedPageEntry(title: entry.title));
                                  }
                                  pageService.savePage(page!, date);
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
                  itemType: "entries",
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
                    header: const SizedBox(height: 12.0),
                    // add footer space to account for the date select
                    footer: const SizedBox(height: 70.0),
                    children: page?.entries
                            .asMap()
                            .entries
                            .map<Widget>((entry) {
                          return NotesEntry(
                            key: Key(entry.value.id),
                            entry: entry.value,
                            index: entry.key,
                            onFocus: (focusNode) => this.focusNode = focusNode,
                            onChange: () => pageService.savePage(page, date),
                            onDelete: () {
                              page.entries.removeAt(entry.key);
                              pageService.savePage(page, date);
                            },
                          );
                        }).toList() ??
                        [],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const Hero(
              tag: 'navbar',
              child: NavBar(currentIndex: 3),
            ),
          ),
        );
      },
    );
  }
}
