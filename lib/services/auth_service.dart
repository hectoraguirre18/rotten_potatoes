import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotten_potatoes/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  static final String _baseUrl = 'http://192.168.1.123:8080/rotten-potatoes-server/v1';

  AuthService._();
  static AuthService _instance;
  static AuthService get instance {
    if(_instance == null)
      _instance = AuthService._();
    return _instance;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User(
      id: prefs.getInt('userId'),
      name: prefs.getString('userName'),
    );
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
  }

  Future<bool> attemptSignIn(User user) async {
    try {
      final response = await http.get(
        '$_baseUrl/users?name=${user.name}&password=${user.password}',
      );
      if(response.statusCode == 200){
        print(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', int.parse(response.body));
        await prefs.setString('userName', user.name);
        return true;
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Invalid credentials');
        return false;
      }
    } catch (e) {
      print('[AuthService][attemptSignIn] $e');
      return false;
    }
  }

  Future<bool> attemptSignUp(User user) async {
    try {
      final response = await http.post(
        '$_baseUrl/users',
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(user.toMap())
      );
      if(response.statusCode >= 200 && response.statusCode < 300){
        User responseUser = User.fromMap(jsonDecode(response.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', responseUser.id);
        await prefs.setString('userName', responseUser.name);
        return true;
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Failed to Create Account');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('[AuthService][attemptSignIn] $e');
      return false;
    }
  }

  Future openSignInDialog(context) async {

    final formKey = GlobalKey<FormState>();

    final User user = User();

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Log In to your Account"),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    return 'Please enter a username';
                  user.name = value;
                  return null;
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    return 'Please enter a password';
                  user.password = value;
                  return null;
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RaisedButton(
                  child: Text('SIGN IN'),
                  onPressed: () async {
                    if(formKey.currentState.validate()) {
                      if(await attemptSignIn(user))
                        Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future openSignUpDialog(context) async {

    final formKey = GlobalKey<FormState>();

    final User user = User();

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create Account"),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    return 'Please enter a username';
                  user.name = value;
                  return null;
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    return 'Please enter a password';
                  user.password = value;
                  return null;
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RaisedButton(
                  child: Text('SIGN UP'),
                  onPressed: () async {
                    if(formKey.currentState.validate()) {
                      if(await attemptSignUp(user))
                        Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}