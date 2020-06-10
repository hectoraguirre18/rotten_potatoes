import 'dart:convert';

class User {
  int id;
  String name;
  String password;

  User({this.id, this.name, this.password});

  User.fromMap(map) {
    id = map['id'];
    name = map['name'];
    password = map['password'];
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'password': password,
  };

  String toString() => JsonEncoder.withIndent('  ').convert(toMap());
}