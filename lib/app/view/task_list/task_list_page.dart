import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/task.dart';
import '../components/h1.dart';
import '../components/shape.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final taskList = <Task>[];

  /* @override
  Future<void> initState() async {
    final prefs = await SharedPreferences.getInstance();
    super.initState();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          Expanded(
              child: _TaskList(taskList, OnTaskDoneChange: (task) {
            task.done = !task.done;
            setState(() {});
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewTaskModal(context),
        child: const Icon(Icons.add, size: 51),
      ),
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _NewTaskModal(
        onTaskCreated: (Task task) {
          setState(() async {
            taskList.add(task);
            final prefs = await SharedPreferences.getInstance();
            prefs.setStringList(
                'tasks', taskList.map((e) => jsonEncode(e.toJson())).toList());
            
            
            final taskStrings = prefs.getStringList('tasks');
            final newTaskList =
            taskStrings?.map((e) => Task.fromJson(jsonDecode(e))).toList();
          });
        },
      ),
    );
  }
}

class _NewTaskModal extends StatelessWidget {
  _NewTaskModal({super.key, required this.onTaskCreated});

  final _controler = TextEditingController();
  final void Function(Task task) onTaskCreated;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 33,
        vertical: 23,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: keyboardHeight),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            H1('Nueva Tarea'),
            const SizedBox(
              height: 26,
            ),
            TextField(
              controller: _controler,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: 'Descripcion de la tarea',
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            ElevatedButton(
              onPressed: () {
                if (_controler.text.isNotEmpty) {
                  final task = Task(_controler.text);
                  onTaskCreated(task);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList(
    this.taskList, {
    super.key,
    required this.OnTaskDoneChange,
  });

  final List<Task> taskList;
  final void Function(Task task) OnTaskDoneChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1('Tareas'),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) => TaskItem(
                taskList[index],
                onTap: () => OnTaskDoneChange(taskList[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: taskList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(children: [Shape()]),
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
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem(this.task, {super.key, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
          child: Row(
            children: [
              Icon(
                task.done
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Text(task.title),
            ],
          ),
        ),
      ),
    );
  }
}
