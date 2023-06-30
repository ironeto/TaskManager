import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:http/http.dart';
import '../repositories/tasks_repository.dart';

class TasksService {
  final TasksRepository _tasksRepository;

  TasksService({TasksRepository? tasksRepository})
      : _tasksRepository = tasksRepository ?? TasksRepository();

  Future<List<TaskModel>> list() async {
    try {
      final List<TaskModel> list = [];
      final response = await _tasksRepository.list();
      final docs = response.docs;
      for (var doc in docs) {
        list.add(TaskModel.fromJson(doc.id, doc.data()));
      }
      return list;
    } catch (err) {
      throw Exception("Problemas ao consultar lista de tarefas.");
    }
  }

  Future insert(TaskModel task) async {
    try {
      final response = await _tasksRepository.insert(task.id, task.toJson());
    } catch (err) {
      throw Exception("Problemas ao inserir a tarefa.");
    }
  }

  Future update(TaskModel task) async {
    try {
      await _tasksRepository.update(task.id, task.toJson());
    } catch (err) {
      throw Exception("Problemas ao alterar a tarefa.");
    }
  }

  Future delete(TaskModel task) async {
    try {
      await _tasksRepository.delete(task.id);
    } catch (err) {
      throw Exception("Problemas ao excluir task.");
    }
  }
}
