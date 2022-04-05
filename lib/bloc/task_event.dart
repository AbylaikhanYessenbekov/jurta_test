
abstract class TaskEvent {}

class TaskAddEvent extends TaskEvent {
  String? name;
  DateTime? date;
  bool? isToday;
  TaskAddEvent({this.name, this.date, this.isToday});
}

class TaskGetEvent extends TaskEvent {

}