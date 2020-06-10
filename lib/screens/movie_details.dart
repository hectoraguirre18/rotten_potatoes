import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/movie.dart';
import 'package:rotten_potatoes/model/review.dart';
import 'package:rotten_potatoes/model/user.dart';
import 'package:rotten_potatoes/services/auth_service.dart';

class MovieDetailsScreen extends StatefulWidget {

  final Movie movie;

  MovieDetailsScreen(this.movie) : assert(movie != null);

  @override
  State<StatefulWidget> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  User user;
  List<Review> reviews;
  Review parentReview;
  final controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    AuthService.instance.getUser().then((u){
      setState(() => user = u);
      print(u);
    });
    setState(() {
      reviews = randomComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: header(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *0.25,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                widget.movie.description ?? 'No description',
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 8,
                      endIndent: 8,
                      thickness: 2,
                      height: 32,
                    ),
                    Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    reviews?.isNotEmpty ?? false
                      ? reviewList()
                      : Padding(
                        padding: const EdgeInsets.only(top: 64),
                        child: Text(
                          'This movie doesn\'t have reviews yet.'
                        ),
                      ),
                    SizedBox(height: 12)
                  ],
                ),
              ),
            ),
            user != null ? commentBar() : emptyBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget emptyBottomBar() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      boxShadow: [
        BoxShadow(
          blurRadius: 4
        )
      ]
    ),
    child: Center(
      child: Text('Sign in to add a review!')
    )
  );

  Widget commentBar() => Container(
    decoration: BoxDecoration(
      color: Colors.grey[50],
      boxShadow: [
        BoxShadow(
          blurRadius: 4
        )
      ]
    ),
    child: Column(
      children: [
        parentReview != null
          ? Column(
            children: [
              Container(
                color: Colors.grey[200],
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Responding to ${parentReview.username}\'s comment: ${parentReview.content}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() => parentReview = null);
                      },
                      child: Icon(Icons.clear, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 0,
                endIndent: 0,
                height: 1,
              )
            ],
          )
          : SizedBox(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Add a comment',
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Icon(Icons.send),
                  onTap: (){
                    final review = Review(
                      id: DateTime.now().toString(),
                      content: controller.value.text,
                      userId: user.id.toString(),
                      username: user.name,
                      comments: [],
                    );
                    setState((){
                      if(parentReview != null) {
                        if(parentReview.comments == null)
                          parentReview.comments = [];
                        parentReview.comments.add(review);
                        parentReview = null;
                      } else {
                        reviews.add(review);
                      }
                    });
                    controller.clear();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
  
  Widget header() => PreferredSize(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Icon(
              Icons.arrow_back
            ),
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                widget.movie.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
    ),
    preferredSize: Size.fromHeight(kToolbarHeight)
  );

  Widget reviewList() => ListView.builder(
    itemBuilder: (context, index) => reviewItemList(reviews.elementAt(index)),
    itemCount: reviews.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
  );

  Widget reviewItemList(Review review) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
    child: IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          VerticalDivider(
            color: Colors.grey,
            indent: 2,
            endIndent: 2,
            thickness: 2,
            width: 16
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() => parentReview = review);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: double.infinity),
                      Text(
                        review.username,
                        style: TextStyle(
                          fontSize: 10
                        ),
                      ),
                      Text(review.content)
                    ],
                  ),
                ),
              ]..addAll(List.generate(
                review.comments?.length ?? 0,
                (index) => reviewItemList(review.comments.elementAt(index))
              ))
            ),
          )
        ],
      ),
    ),
  );
}