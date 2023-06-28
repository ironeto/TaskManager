
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/task_list_item.dart';

import '../models/task_model.dart';
import '../services/Tasks_service.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> _generateListTasks(List<TaskModel> tasks) {
      return tasks.map((tasks) => TaskListItem(tasks)).toList();
    }

    return FutureBuilder<List<TaskModel>>(
      future: TasksService().list(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Erro ao consultar tasks: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          final list = snapshot.data;
          if (list != null && list.isNotEmpty) {
            return Expanded(
              child: ListView(
                children: _generateListTasks(list),
              ),
            );
          } else {
            return const Center(
              child: Text("Nenhum produto cadastrado."),
            );
          }
        } else {
          return const Center(
            child: Text("Nenhum produto cadastrado."),
          );
        }
      },
    );
  }
}
