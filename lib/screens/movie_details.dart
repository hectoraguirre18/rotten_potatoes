import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/movie.dart';

class MovieDetailsScreen extends StatefulWidget {

  final Movie movie;

  MovieDetailsScreen(this.movie) : assert(movie != null);

  @override
  State<StatefulWidget> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    print(widget.movie);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            header(),
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
            )
          ],
        ),
      ),
    );
  }
  
  Widget header() => PreferredSize(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.arrow_back
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
}