import 'package:flutter/material.dart';
import 'package:tempus/services/firestore/tasks.dart';
import 'package:tempus/shared/shared.dart';
import 'package:tempus/services/firestore/models.dart';

import 'task_item.dart';

enum MenuOption { newTask, transferIncomplete, toggleDelete }

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TasksService tasksService = TasksService();
  late Stream<List<Task>> tasksStream;
  late int taskCount;

  DateTime selectedDate = DateTime.now();
  bool showDeleteButtons = false;

  @override
  void initState() {
    super.initState();
    tasksStream = tasksService.getTasks(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<MenuOption>(
            onSelected: (MenuOption option) {
              switch (option) {
                case MenuOption.newTask:
                  tasksService.addTask(selectedDate, taskCount);
                  break;
                case MenuOption.transferIncomplete:
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Would you like to add yesterday's incomplete tasks?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("No"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            tasksService.transferIncomplete(
                                selectedDate, taskCount);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                  break;
                case MenuOption.toggleDelete:
                  setState(() {
                    showDeleteButtons = !showDeleteButtons;
                  });
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<MenuOption>>[
              const PopupMenuItem<MenuOption>(
                value: MenuOption.newTask,
                child: Text('Add new task'),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.transferIncomplete,
                child: Text('Add incomplete tasks'),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.toggleDelete,
                child: Text('Toggle removal icons'),
              ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FloatingDateSelect(
          onDateChanged: (date) => setState(() {
            selectedDate = date;
            tasksStream = tasksService.getTasks(date);
          }),
          child: StreamBuilder<List<Task>>(
            stream: tasksStream,
            builder: (context, snapshot) => RequestBuilder<List<Task>>(
              snapshot: snapshot,
              builder: (context, snapshot) {
                List<Task> tasks = snapshot.data ?? [];
                tasks.sort((a, b) => a.order.compareTo(b.order));
                taskCount = tasks.length;

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.surfing, size: 50),
                        ),
                        Text(
                          'No tasks yet!',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("Click the"),
                              Icon(Icons.more_vert),
                              Text("icon to add some."),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ReorderableListView(
                  buildDefaultDragHandles: false,
                  onReorder: (int oldIndex, int newIndex) =>
                      tasksService.moveTask(tasks, oldIndex, newIndex),
                  // add footer space to account for the date select
                  footer: const SizedBox(height: 70),
                  children: tasks
                      .map(
                        (Task task) => TaskItem(
                          key: Key(task.id),
                          task: task,
                          showDeleteButton: showDeleteButtons,
                          onUpdate: () => tasksService.updateTask(task),
                          onDelete: () => tasksService.deleteTask(tasks, task),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(currentIndex: 0),
      ),
    );
  }
}
