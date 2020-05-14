import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagerclient/models/tasklistmodel.dart';
import 'package:taskmanagerclient/routes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskListModel(),
      child: TaskManagerClientApp()
    )
  );
}

class TaskManagerClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager Client',
      initialRoute: '/',
      routes: routes,
      theme: ThemeData.dark()
      //theme: appTheme()
    );
  }
}
