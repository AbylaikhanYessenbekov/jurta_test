import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jurta_test/bloc/task_event.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage(title: 'Task Manager'), debugShowCheckedModeBanner: false,);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        backgroundColor: Colors.black,
      ),
      body: const Tasks(),
    );
  }
}

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    String? name;
    DateTime? selectedTime = DateTime.now();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final TaskBloc _bloc = TaskBloc();

    final TextEditingController _nameController = TextEditingController();

    bool isToday = true;
    bool? isCompleted = false;

    String? formatDate(DateTime? dateTime) {
      String? formattedDate = "${dateTime?.hour.toString()}:"
          "${dateTime?.minute.toString()}";

      return formattedDate;
    }

    return BlocBuilder<TaskBloc, TaskState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is TaskLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TaskLoadedState) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.725,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.taskList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Checkbox(
                                value: isCompleted,
                                onChanged: (value) {
                                  isCompleted = value;
                                },
                              ),
                              title: Text(
                                state.taskList![index].name!,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                formatDate(state.taskList![index].date)!,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoPageScaffold(
                        navigationBar: const CupertinoNavigationBar(
                          previousPageTitle: 'Close',
                          middle: Text('Task'),
                        ),
                        child: SafeArea(
                          child: SizedBox(
                            height: height,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  //Add a task
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add a task",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                Padding(
                                  //NameField
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: width * 0.8,
                                    child: Center(
                                      child: CupertinoTextField(
                                        placeholder: 'Name',
                                        controller: _nameController,
                                        onTap: () {
                                          name = _nameController.text;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  //DateTimePicker
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: height * 0.15,
                                      child: Center(
                                        child: CupertinoDatePicker(
                                          use24hFormat: true,
                                          mode:
                                          CupertinoDatePickerMode.time,
                                          onDateTimeChanged:
                                              (DateTime value) {
                                            selectedTime = value;
                                          },
                                          initialDateTime: DateTime.now(),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    child: ListTile(
                                      title: const Text('Today'),
                                      trailing: CupertinoSwitch(
                                        value: isToday,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isToday = value;
                                          });
                                        },
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isToday = !isToday;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  // Button
                                  padding: const EdgeInsets.all(8.0),
                                  child: CupertinoButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      _bloc.add(TaskAddEvent(
                                        name: _nameController.text,
                                        date: selectedTime,
                                        isToday: isToday,
                                      ));
                                      _nameController.text = '';
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Done"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, size: 30,),
              // color: Colors.black,
            ),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoPageScaffold(
                      navigationBar: const CupertinoNavigationBar(
                        previousPageTitle: 'Close',
                        middle: Text('Task'),
                      ),
                      child: SafeArea(
                        child: SizedBox(
                          height: height,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                //Add a task
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Add a task",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Padding(
                                //NameField
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: width * 0.8,
                                  child: Center(
                                    child: CupertinoTextField(
                                      placeholder: 'Name',
                                      controller: _nameController,
                                      onTap: () {
                                        name = _nameController.text;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                //DateTimePicker
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: height * 0.13,
                                    child: Center(
                                      child: CupertinoDatePicker(
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.time,
                                        onDateTimeChanged: (DateTime value) {
                                          selectedTime = value;
                                        },
                                        // initialDateTime: DateTime.now(),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: MergeSemantics(
                                    child: ListTile(
                                      title: const Text('Today'),
                                      trailing: CupertinoSwitch(
                                        value: isToday,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isToday = value;
                                          });
                                        },
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isToday = !isToday;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                // Button
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    _bloc.add(TaskAddEvent(
                                      name: _nameController.text,
                                      date: selectedTime,
                                      isToday: isToday,
                                    ));
                                    _nameController.text = '';
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Done"),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('If you disable today, it will be '
                                    'considered as tomorrow'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, size: 30,),
          ),
        );
      },
    );
  }
}
