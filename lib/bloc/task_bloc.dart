import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jurta_test/bloc/task_event.dart';
import 'package:jurta_test/bloc/task_state.dart';

import '../task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitialState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    // if(event is TaskGetEvent) {
    //   yield TaskLoadedState();
    // }
    if (event is TaskAddEvent) {
      Task task = Task(
        name: event.name,
        date: event.date,
        isToday: event.isToday,
      );
      TaskList.taskList.add(task);
      yield TaskLoadedState(
        taskList: TaskList.taskList,
      );
    }
  }
}
