import 'dart:convert';

class MovieReview {
  int id;
  String content;
  int movieId;
  int parentMovieReview;
  int userId;
  String userName;
  List<MovieReview> comments;

  MovieReview({this.id, this.content, this.movieId, this.parentMovieReview, this.userId, this.userName, this.comments});

  

  MovieReview.fromMap(map) {
    id                = map['id'];
    content           = map['content'];
    movieId           = map['movieId'];
    parentMovieReview = map['parentMovieReview'];
    userId            = map['userId'];
    userName          = map['userName'];

    comments = map['comments']?.map<MovieReview>(
      (e) => MovieReview.fromMap(e)
    )?.toList();
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'content': content,
    'movieId': movieId,
    'parentMovieReview': parentMovieReview,
    'userId': userId,
    'userName': userName
  };

  bool isChildOf(MovieReview other) => other.id == this.parentMovieReview;

  String toString() => JsonEncoder.withIndent('  ').convert(toMap());
}