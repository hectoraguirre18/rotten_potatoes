import 'dart:convert';

import 'package:rotten_potatoes/model/movie.dart';
import 'package:http/http.dart' as http;
import 'package:rotten_potatoes/model/movie_review.dart';
import 'package:rotten_potatoes/model/show_review.dart';

class ReviewsService {
  
  static final String _baseUrl = 'http://192.168.1.123:8080/rotten-potatoes-server/v1';

  ReviewsService._();
  static ReviewsService _instance;
  static ReviewsService get instance {
    if(_instance == null)
      _instance = ReviewsService._();
    return _instance;
  }
  

  Future<List<MovieReview>> getReviewsForMovie(int movieId) async {
    try {
      final response = await http.get('$_baseUrl/reviews/movies/$movieId');
      List<MovieReview> reviews = jsonDecode(response.body).map<MovieReview>(
        (map) => MovieReview.fromMap(map)
      ).toList();

      List<MovieReview> parents = reviews.where((e) => e.parentMovieReview == null).toList();


      List<MovieReview> children = reviews.where((e) => e.parentMovieReview != null).toList();
      children.forEach((c){
        MovieReview parent = reviews.firstWhere((p) => p.id == c.parentMovieReview);
        if(parent.comments == null)
          parent.comments = [];
        parent.comments.add(c);
      });

      return parents;

    } catch (e) {
      print('[ReviewsService][getReviewsForMovie] $e');
      return <MovieReview>[];
    }
  }

  Future<void> saveMovieReview(MovieReview review) async {
    print('adding review, child of ${review.parentMovieReview}');
    try {
      print(review.toMap());
      print(jsonEncode(review.toMap()));
      final response = await http.post(
        '$_baseUrl/reviews/movies',
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(review.toMap())
      );
      final result = jsonDecode(response.body);
      review.id = result['id'];
    } catch (e) {
      print('[ReviewsService][saveMovieReview] $e');
    }
  }
  

  Future<List<ShowReview>> getReviewsForShow(int showId) async {
    try {
      final response = await http.get('$_baseUrl/reviews/shows/$showId');
      List<ShowReview> reviews = jsonDecode(response.body).map<ShowReview>(
        (map) => ShowReview.fromMap(map)
      ).toList();

      List<ShowReview> parents = reviews.where((e) => e.parentShowReview == null).toList();


      List<ShowReview> children = reviews.where((e) => e.parentShowReview != null).toList();
      children.forEach((c){
        ShowReview parent = reviews.firstWhere((p) => p.id == c.parentShowReview);
        if(parent.comments == null)
          parent.comments = [];
        parent.comments.add(c);
      });

      return parents;

    } catch (e) {
      print('[ReviewsService][getReviewsForShow] $e');
      return <ShowReview>[];
    }
  }

  Future<void> saveShowReview(ShowReview review) async {
    print('adding review, child of ${review.parentShowReview}');
    try {
      print(review.toMap());
      print(jsonEncode(review.toMap()));
      final response = await http.post(
        '$_baseUrl/reviews/shows',
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(review.toMap())
      );
      print('got response');
      print(response.body);
      final result = jsonDecode(response.body);
      print(result['id']);
      review.id = result['id'];
    } catch (e) {
      print('[ReviewsService][saveShowReview] $e');
    }
  }
}