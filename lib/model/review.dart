class Review {
  String id;
  String userId;
  String username;
  String content;
  List<Review> comments;

  Review({this.id, this.userId, this.username, this.content, this.comments});

  bool get hasComments => comments?.isNotEmpty ?? false;
}

List<Review> randomComments() => [
  Review(
    username: 'LessCoolThanYou',
    content: 'Such an ‘80s thing to say.',
    comments: [
      Review(
        username: 'W3non',
        content: 'Nowadays everyone uses harsh words, but this is the real way to roast someone.',
        comments: [
          Review(
            username: 'LaterGatorPlayer',
            content: 'Oh please, don’t cream your pants.',
          ),
          Review(
            username: 'TheMagicalMatt',
            content: '\"Yeah it\'s me you leather jacket wearing mullet head ass bitch\"',
          ),
        ]
      ),
    ]
  ),
];