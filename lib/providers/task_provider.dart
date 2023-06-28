import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_manager/services/tasks_service.dart';
import 'package:shared_pk/IGenericOverviewCard.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TasksProvider extends ChangeNotifier implements IGenericOverviewCard {
  final TasksService taskService = TasksService();
  List<TaskModel> itens = [];
  Future<List<TaskModel>> list() async {
    if (itens.isEmpty) {
      itens = await taskService.list();
    }
    return itens;
  }

  Future addEffort(TaskModel task, int effort) async {
      if(effort == 0)
        task.effortHours++;
      else
        task.effortHours = effort;

      await taskService.update(task);
      notifyListeners();
  }

  Future save(TaskModel task, String name, int effortHours, double latitude, double longitude, String imageName) async {
    task.name = name;
    task.latitude = latitude;
    task.longitude = longitude;
    task.effortHours = effortHours;
    task.date = DateTime.now();
    task.imageName = imageName;
    
    await taskService.update(task);
    notifyListeners();
  }

  Future setLocation(TaskModel task, double latitude, double longitude) async {
    task.latitude = latitude;
    task.longitude = longitude;
    await taskService.update(task);
    notifyListeners();
  }

  Future removeEffort(TaskModel task) async {
    if (task.effortHours > 1) {
      task.effortHours--;
      await taskService.update(task);
      notifyListeners();
    }
  }

  Future deleteTask(TaskModel task) async{
    await taskService.delete(task);
    notifyListeners();
  }


  Future addTask(String name, int effortHours, double latitude, double longitude, String imageName) async{
    final newTask = TaskModel(generateUUID(),
      name,
      effortHours,
      latitude,
      longitude,
      DateTime.now(),
      imageName
    );
    await taskService.insert(newTask);
    notifyListeners();
  }

  String generateUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }


  @override
  int countItems() {
    return itens.fold(0, (acc, p) => acc + p.effortHours);
  }
}