import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  final movies = [];

  @override
  void initState(){
    super.initState();
    readMovies();
  }

  void readMovies() async {
    final url = 'https://api.themoviedb.org/3/movie/top_rated?api_key={apiKey}&language=en-US&page=1';
    final response = await http.get(url);
    final results = json.decode(response.body)['results'];
    setState(() {
      results?.forEach((movie) => movies.add(movie));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: movieList(),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget movieList() => GridView.count(
    crossAxisCount: 3,
    childAspectRatio: 185/277,
    shrinkWrap: true,
    children: List.generate(
      movies?.length ?? 0,
      (index) {
        final movie = movies.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w185/${movie['poster_path']}',
                  fit: BoxFit.cover,
                )
              )
            ],
          ),
        );
      }
    )
  );

  Widget header() => PreferredSize(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.menu
          ),
          Image.asset(
            'assets/images/logo.png',
            height: kToolbarHeight*0.8,
          ),
          Icon(
            Icons.search
          ),
        ],
      ),
    ),
    preferredSize: Size.fromHeight(kToolbarHeight)
  );
}