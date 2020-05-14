import 'package:flutter/widgets.dart';
import 'package:taskmanagerclient/screens/loginpage.dart';
import 'package:taskmanagerclient/screens/tasklistpage.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => LoginPage(),
  "/tasks": (BuildContext context) => TaskListPage()
};