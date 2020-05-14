import 'dart:collection';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:taskmanagerclient/services/tasklistapi.dart' as tasklistapi;

class TaskListModel with ChangeNotifier {
  List<TaskModel> _taskList = [];

  populateTaskList() async {
    log('populating task list...');
    List<dynamic> tasks = await tasklistapi.getTasks();
    tasks.forEach((item) {
      TaskModel task = new TaskModel(id: item['_id'], completed: item['completed'], description: item['description']);
      _taskList.add(task);
    });
    log('task list (size ${_taskList.length}) = ' + _taskList.toString());
    notifyListeners();
  }

  clearTaskList() {
    log('clearing task list...');
    _taskList = [];
    notifyListeners();
  }

  toggleComplete(TaskModel task) {
    log('in toggleComplete for $task');
    task.completed = !task.completed;
    tasklistapi.updateTask(task);
    notifyListeners();
  }

  UnmodifiableListView<TaskModel> get tasks => UnmodifiableListView(_taskList);
}

class TaskModel {
  final String id;
  bool completed;
  String description;

  TaskModel({this.id, this.completed, this.description});

  @override
  String toString() {
    return 'Task ($id): $description is ${completed ? 'finished' : 'not finished'}';
  }
}