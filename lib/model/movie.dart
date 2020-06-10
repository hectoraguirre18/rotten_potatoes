import 'dart:convert';

class Movie {
  int id;
  String name;
  String description;

  Movie({this.id, this.name, this.description});

  Movie.fromMap(map) {
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