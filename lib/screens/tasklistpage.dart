import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagerclient/models/tasklistmodel.dart';
import 'package:taskmanagerclient/services/tasklistapi.dart' as tasklistapi;

class TaskListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: <Widget>[_logoutIcon(context)]
      ),
      body: Consumer<TaskListModel>(
        builder: (context, taskList, child) => _renderTasks(taskList)
      )
    );
  }

  Widget _logoutIcon(context) {
    return Consumer<TaskListModel>(
      builder: (context, taskList, child) {
        return IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Logout',
          onPressed: () {
            taskList.clearTaskList();
            tasklistapi.logout();
            Navigator.pushReplacementNamed(context, '/');
          }
        );
      }
    );
  }

  Widget _renderTasks(TaskListModel taskList) {
    return ListView.builder(
      itemCount: taskList.tasks.length,
      itemBuilder: (context, index) => _renderTask(context, taskList.tasks[index])
    );
  }

  Widget _renderTask(BuildContext context, TaskModel task) {
    return ListTile(
      title: Text(task.description),
      trailing: Icon(
        task.completed ? Icons.check_box : Icons.check_box_outline_blank,
        color: task.completed ? Colors.blueGrey : null
      ),
      onTap: () => Provider.of<TaskListModel>(context, listen: false).toggleComplete(task)
    );
  }
}