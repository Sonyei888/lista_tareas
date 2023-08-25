import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/task.dart';
import '../components/h1.dart';
import '../components/shape.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Row(children: const [Shape()]),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Image.asset(
                      'assets/tasks-list-image.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    const H1('Completa tus tareas', color: Colors.white),
                    const SizedBox(height: 24),
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 35),
            child: H1('Tareas'),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView.separated(
              itemBuilder: (_, index) => TaskItem(taskList[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: taskList.length,
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 50),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem(this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
        child: Row(
          children: [
            Icon(
              Icons.check_box_outline_blank,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(task.title),
          ],
        ),
      ),
    );
  }
}

final taskList = <Task>[
  Task('Sacar el perro'),
  Task('Hacer la compra'),
  Task('Electiva institucional'),
];
