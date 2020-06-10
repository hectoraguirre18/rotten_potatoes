import 'dart:convert';

import 'package:rotten_potatoes/model/movie.dart';
import 'package:http/http.dart' as http;

class MoviesService {
  
  static final String _baseUrl = 'http://192.168.1.123:8080/rotten-potatoes-server/v1';

  MoviesService._();
  static MoviesService _instance;
  static MoviesService get instance {
    if(_instance == null)
      _instance = MoviesService._();
    return _instance;
  }

  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get('$_baseUrl/movies');
      List movies = jsonDecode(response.body);
      return movies.map<Movie>((map) => Movie.fromMap(map)).toList();
    } catch (e) {
      print('[MoviesService][getMovies] $e');
      return <Movie>[];
    }
  }

  Future<void> saveMovie(Movie movie) async {
    try {
      final response = await http.post(
        '$_baseUrl/movies',
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(movie.toMap())
      );
      print(response);
    } catch (e) {
      print('[MoviesService][getMovies] $e');
    }
  }
}