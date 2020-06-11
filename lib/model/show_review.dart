import 'dart:convert';

class ShowReview {
  int id;
  String content;
  int showId;
  int parentShowReview;
  int userId;
  String userName;
  List<ShowReview> comments;

  ShowReview({this.id, this.content, this.showId, this.parentShowReview, this.userId, this.userName, this.comments});

  

  ShowReview.fromMap(map) {
    id                = map['id'];
    content           = map['content'];
    showId           = map['showId'];
    parentShowReview = map['parentShowReview'];
    userId            = map['userId'];
    userName          = map['userName'];

    comments = map['comments']?.map<ShowReview>(
      (e) => ShowReview.fromMap(e)
    )?.toList();
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'content': content,
    'showId': showId,
    'parentShowReview': parentShowReview,
    'userId': userId,
    'userName': userName
  };

  bool isChildOf(ShowReview other) => other.id == this.parentShowReview;

  String toString() => JsonEncoder.withIndent('  ').convert(toMap());
}