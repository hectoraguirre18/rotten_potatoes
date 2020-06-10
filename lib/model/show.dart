import 'dart:convert';

class Show {
  int id;
  String name;
  String description;

  Show({this.id, this.name, this.description});

  Show.fromMap(map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
  };

  String toString() => JsonEncoder.withIndent('  ').convert(toMap());
}