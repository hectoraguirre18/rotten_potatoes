import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/user.dart';

class AuthService {
  AuthService._();
  static AuthService _instance;
  static get instance {
    if(_instance == null)
      _instance = AuthService._();
    return _instance;
  }

  Future<bool> isLoggedIn() async {
    return false;
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
                  onPressed: () {
                    if(formKey.currentState.validate()) {
                      print('SIGN IN');
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
                  return null;
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RaisedButton(
                  child: Text('SIGN UP'),
                  onPressed: () {
                    if(formKey.currentState.validate()) {
                      print('SIGN UP');
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