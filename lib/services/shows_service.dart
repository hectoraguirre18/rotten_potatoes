import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rotten_potatoes/model/show.dart';

class ShowsService {
  
  static final String _baseUrl = 'http://192.168.1.123:8080/rotten-potatoes-server/v1';

  ShowsService._();
  static ShowsService _instance;
  static ShowsService get instance {
    if(_instance == null)
      _instance = ShowsService._();
    return _instance;
  }

  Future<List<Show>> getShows() async {
    try {
    final response = await http.get('$_baseUrl/shows');
    List shows = jsonDecode(response.body);
    return shows.map<Show>((map) => Show.fromMap(map)).toList();
    } catch (e) {
      print('[ShowsService][getShows] $e');
      return <Show>[];
    }
  }

  Future<void> saveShow(Show show) async {
    try {
      final response = await http.post(
        '$_baseUrl/shows',
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(show.toMap())
      );
      print(response);
    } catch (e) {
      print('[ShowsService][saveShow] $e');
    }
  }
}