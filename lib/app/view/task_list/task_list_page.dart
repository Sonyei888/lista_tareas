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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Header(), Expanded(child: _TaskList())],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewTaskModal(context),
        child: const Icon(Icons.add, size: 50),
      ),
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const _NewTaskModal());
  }
}

class _NewTaskModal extends StatelessWidget {
  const _NewTaskModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 33,
        vertical: 23,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          H1('Nueva Tarea'),
          const SizedBox(
            height: 26,
          ),
          TextField(
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
            onPressed: () {},
            child: Text('Guardar'),
          )
        ],
      ),
    );
  }
}

class _TaskList extends StatefulWidget {
  const _TaskList({
    super.key,
  });

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  final taskList = <Task>[
    Task('Sacar el perro'),
    Task('Hacer la compra'),
    Task('Electiva institucional'),
  ];

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
                onTap: () {
                  taskList[index].done = !taskList[index].done;
                  setState(() {});
                },
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
