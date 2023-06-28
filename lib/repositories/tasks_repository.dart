
import 'package:task_manager/repositories/repository.dart';

class TasksRepository extends BaseFirebaseFireStoreRepository{
  TasksRepository(): super("tasks");
}