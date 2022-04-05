import '../task.dart';

abstract class TaskState {}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  List<Task>? taskList;
  TaskLoadedState({this.taskList});
}

class TaskErrorState extends TaskState {}