import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_tareas/app/repository/task_repository.dart';
import 'package:lista_tareas/app/view/task_list/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/task.dart';
import '../components/h1.dart';
import '../components/shape.dart';
import 'package:provider/provider.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..fetchTasks(),
      child: Scaffold(
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Expanded(child: _TaskList()),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showNewTaskModal(context),
            child: const Icon(Icons.add, size: 51),
          ),
        ),
      ),
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<TaskProvider>(),
          child: _NewTaskModal(),
        ),
    );

  }
}

class _NewTaskModal extends StatelessWidget {
  _NewTaskModal({super.key});

  final _controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

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
                  context.read<TaskProvider>().addNewTask(task);
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
  const _TaskList({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1('Tareas'),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (_, provider, __){
                if(provider.taskList.isEmpty) {
                  return const Center(
                    child: Text('No hay tareas'),
                  );
                }
                return ListView.separated(
                  itemBuilder: (_, index) =>
                      TaskItem(
                        provider.taskList[index],
                        onTap: () => provider.OnTaskDoneChange(provider.taskList[index]),
                      ),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: provider.taskList.length,
                );
              }
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
      color: Theme
          .of(context)
          .colorScheme
          .primary,
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
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
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
