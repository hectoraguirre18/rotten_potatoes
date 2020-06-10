import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/show.dart';
import 'package:rotten_potatoes/model/review.dart';

class ShowDetailsScreen extends StatefulWidget {

  final Show show;

  ShowDetailsScreen(this.show) : assert(show != null);

  @override
  State<StatefulWidget> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {

  List<Review> reviews;

  @override
  void initState(){
    super.initState();
    setState(() {
      reviews = randomComments()..addAll(randomComments());
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
                                widget.show.description ?? 'No description',
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
                          'This show doesn\'t have reviews yet.'
                        ),
                      ),
                    SizedBox(height: 12)
                  ],
                ),
              ),
            ),
            commentBar(),
          ],
        ),
      ),
    );
  }

  Widget commentBar() => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      boxShadow: [
        BoxShadow(
          blurRadius: 4
        )
      ]
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Add a comment',
              contentPadding: const EdgeInsets.all(0)
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: Icon(Icons.send),
            onTap: (){
              print('ADD COMMENT');
            },
          ),
        )
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
                widget.show.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                ),
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
                Text(
                  review.username,
                  style: TextStyle(
                    fontSize: 10
                  ),
                ),
                Text(review.content)
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