import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tempus/services/firestore/tasks.dart';
import 'package:tempus/shared/loading.dart';

import '../../services/firestore/models.dart';
import '../../shared/nav_bar.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TasksService tasksService = TasksService();
  Stream<QuerySnapshot> _tasksStream = TasksService().getTasks(DateTime.now());
  int taskCount = 0;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.add),
            iconEnabledColor: colorScheme.onBackground,
            underline: Container(),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Add new task')),
              DropdownMenuItem(value: 2, child: Text('Add incomplete')),
            ],
            onChanged: (int? newValue) {
              switch (newValue) {
                case 1:
                  tasksService.addTask(DateTime.now(), taskCount);
                  break;
                case 2:
                  print(2);
                  break;
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _tasksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var docs = snapshot.data!.docs;
            taskCount = docs.length;

            List<Task> tasks = docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              Task task = Task.fromJson(data);
              task.id = doc.id;
              return task;
            }).toList();

            tasks.sort((a, b) => a.order.compareTo(b.order));

            return ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                print("oldIndex: $oldIndex, newIndex: $newIndex");
              },
              children: tasks.map((Task task) {
                return ListTile(
                  key: Key(task.id),
                  tileColor: task.order.isOdd ? oddItemColor : evenItemColor,
                  title: Text(task.id),
                );
              }).toList(),
            );
          }
        },
      ),
      bottomNavigationBar: const Hero(
        tag: 'navbar',
        child: NavBar(currentIndex: 0),
      ),
    );
  }
}
