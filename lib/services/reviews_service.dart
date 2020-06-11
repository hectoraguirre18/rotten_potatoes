import 'dart:convert';

import 'package:rotten_potatoes/model/movie.dart';
import 'package:http/http.dart' as http;
import 'package:rotten_potatoes/model/movie_review.dart';

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
      // reviews.retainWhere((e) => e.parentMovieReview != null);
      

      // reviews.forEach((parent) {
      //   parent.comments = [];
      //   reviews.forEach((child) {
      //     if(child.isChildOf(parent)){
      //       reviews.remove(child);
      //       parent.comments.add(child);
      //     }
      //   });
      // });

      // print(reviews);

      return parents;

    } catch (e) {
      print('[ReviewsService][getReviewsForMovie] $e');
      return <MovieReview>[];
    }
  }

  Future<void> saveMovieReview(MovieReview review) async {
    try {
      print(review.toMap());
      print(jsonEncode(review.toMap()));
      await http.post(
        '$_baseUrl/reviews/movies',
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(review.toMap())
      );
    } catch (e) {
      print('[ReviewsService][saveMovieReview] $e');
    }
  }
}