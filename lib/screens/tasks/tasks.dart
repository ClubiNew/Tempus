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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: tasksStream,
              builder: (context, snapshot) => RequestBuilder<List<Task>>(
                snapshot: snapshot,
                builder: (context, snapshot) {
                  List<Task> tasks = snapshot.data ?? [];
                  tasks.sort((a, b) => a.order.compareTo(b.order));
                  taskCount = tasks.length;

                  if (tasks.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.surfing, size: 50),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("No tasks today!"),
                        ),
                      ],
                    );
                  }

                  return ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: (int oldIndex, int newIndex) =>
                        tasksService.moveTask(tasks, oldIndex, newIndex),
                    children: tasks
                        .map(
                          (Task task) => TaskItem(
                            key: Key(task.id),
                            task: task,
                            showDeleteButton: showDeleteButtons,
                            onUpdate: () => tasksService.updateTask(task),
                            onDelete: () =>
                                tasksService.deleteTask(tasks, task),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),
          DateSelect(
            onDateChanged: (date) => setState(() {
              selectedDate = date;
              tasksStream = tasksService.getTasks(date);
            }),
          ),
        ],
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(currentIndex: 0),
      ),
    );
  }
}
