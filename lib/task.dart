class Task {
  String? name;
  DateTime? date;
  bool? isToday;

  Task({this.name, this.date, this.isToday});

}

class TaskList {
  static List<Task> taskList = [];

}