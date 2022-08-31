import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tempus/services/firestore/tasks.dart';
import 'package:tempus/shared/loading.dart';
import 'package:tempus/services/firestore/models.dart';
import 'package:tempus/shared/nav_bar.dart';

enum AddOption { one, incomplete }

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TasksService tasksService = TasksService();
  final Stream<List<Task>> _tasksStream =
      TasksService().getTasks(DateTime.now());
  int taskCount = 0;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: <Widget>[
          PopupMenuButton<AddOption>(
            icon: const Icon(FontAwesomeIcons.plus),
            tooltip: "Add tasks",
            onSelected: (AddOption option) {
              switch (option) {
                case AddOption.one:
                  tasksService.addTask(DateTime.now(), taskCount);
                  break;
                case AddOption.incomplete:
                  print("TODO: Add incomplete tasks from yesterday");
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<AddOption>>[
              const PopupMenuItem<AddOption>(
                value: AddOption.one,
                child: Text('Add new task'),
              ),
              const PopupMenuItem<AddOption>(
                value: AddOption.incomplete,
                child: Text('Add incomplete'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: _tasksStream,
        builder: (context, snapshot) => RequestBuilder<List<Task>>(
          snapshot: snapshot,
          builder: (context, snapshot) {
            List<Task> tasks = snapshot.data!;
            tasks.sort((a, b) => a.order.compareTo(b.order));
            taskCount = tasks.length;

            return ReorderableListView(
              buildDefaultDragHandles: false,
              onReorder: (int oldIndex, int newIndex) {
                Task selectedTask =
                    tasks.firstWhere((task) => task.order == oldIndex);
                List<Task> updatedTasks = [selectedTask];

                if (oldIndex < newIndex) {
                  newIndex -= 1; // new index is one too high moving down
                  tasks.forEach((task) {
                    if (task.order > oldIndex && task.order <= newIndex) {
                      task.order -= 1;
                      updatedTasks.add(task);
                    }
                  });
                } else {
                  tasks.forEach((task) {
                    if (task.order < oldIndex && task.order >= newIndex) {
                      task.order += 1;
                      updatedTasks.add(task);
                    }
                  });
                }

                selectedTask.order = newIndex;
                tasks.sort((a, b) => a.order.compareTo(b.order));
                tasksService.updateMany(updatedTasks);
              },
              children: tasks
                  .map(
                    (Task task) => Container(
                      key: Key(task.id),
                      padding: const EdgeInsets.all(12.0),
                      color: task.order.isOdd ? oddItemColor : evenItemColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: task.completed,
                                  onChanged: (value) {
                                    task.completed = value == true;
                                    tasksService.updateTask(task);
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    task.detail,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ReorderableDragStartListener(
                              index: task.order,
                              child: const Icon(FontAwesomeIcons.gripLines),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(currentIndex: 0),
      ),
    );
  }
}
