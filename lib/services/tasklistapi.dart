import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagerclient/models/tasklistmodel.dart';

final String _authTokenKey = '__farmcaster_token__';

Future<String> login(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log('$username $password ${prefs.getString(_authTokenKey)}');
  http.Response resp = await http.post(
      _buildUri('/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: _buildLoginJSON(username, password));
  log('/login response: ${resp.body}');
  Map<String, dynamic> responseBody = await json.decode(resp.body);
  String token = responseBody['token'];
  prefs.setString(_authTokenKey, token);
  return token;
}

void logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(_authTokenKey);
  prefs.remove(_authTokenKey);
  await http.post(
      _buildUri('/users/logout'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      }
  );
}

Future<List<dynamic>> getTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(_authTokenKey);
  log("in getTasks, token = $token");
  http.Response resp = await http.get(
      _buildUri('/tasks'),
      headers: <String, String>{
        'Authorization': 'Bearer $token'
      });
  log('GET /tasks response: ${resp.body}');
  List<dynamic> taskList = await json.decode(resp.body);
  return taskList;
}

void updateTask(TaskModel task) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(_authTokenKey);
  log('in updateTask for ${task.id}');
  http.Response resp = await http.patch(
    _buildUri('/tasks/${task.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: _buildTaskJSON(task)
  );
  log('PATCH /tasks/:id response: ${resp.body}');
}

String _buildLoginJSON(String username, String password) {
  return json.encode(<String, String>{
    'email': username,
    'password': password
  });
}

String _buildTaskJSON(TaskModel task) {
  return json.encode(<String, dynamic>{
    'description': task.description,
    'completed': task.completed
  });
}

Uri _buildUri(String path) {
  // this is the only Uri constructor that seems to honor port number
  // also, emulator maps 10.0.2.2 to 127.0.0.1 (not localhost) so run your local server accordingly
  //return new Uri(scheme: 'http', host: '10.0.2.2', port: 3000, path: path);

  // task manager on heroku
  return new Uri.https('sarne-node-task-manager-api.herokuapp.com', path);
}

