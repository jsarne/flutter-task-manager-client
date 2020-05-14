import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagerclient/models/tasklistmodel.dart';
import 'package:taskmanagerclient/services/tasklistapi.dart' as tasklistapi;
import 'dart:developer';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(80.0),
          child: _loginForm()
        )
      )
    );
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome', style: Theme.of(context).textTheme.headline3),
                  _usernameField(),
                  _passwordField(),
                  SizedBox(height: 24),
                  _loginButton()
                ]
            )
        )
    );
  }

  Widget _usernameField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Username'),
      validator: (value) => value.isEmpty ? 'Username is required' : null,
      onChanged: (value) => _email = value
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Password'),
      validator: (value) => value.isEmpty ? 'Password is required' : null,
      obscureText: true,
      onChanged: (value) => _password = value
    );
  }

  Widget _loginButton() {
    return RaisedButton(
      child: Text('ENTER'),
      onPressed: _validateAndLogin
    );
  }

  _validateAndLogin() async {
    if (_formKey.currentState.validate()) {
      log('calling login with: $_email and $_password');
      String token = await tasklistapi.login(_email, _password);
      if (token.isNotEmpty) {
        Provider.of<TaskListModel>(context, listen: false).populateTaskList();
        Navigator.pushReplacementNamed(context, '/tasks');
      }
    } else {
      log('form validation error');
    }
  }
}