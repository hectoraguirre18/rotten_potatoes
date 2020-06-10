import 'package:flutter/material.dart';
import 'package:rotten_potatoes/screens/movies_page.dart';
import 'package:rotten_potatoes/screens/shows_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              header(),
              TabBar(
                tabs: <Widget>[
                  Tab(
                    // icon: Icon(Icons.movie),
                    text: 'Movies',
                  ),
                  Tab(
                    // icon: Icon(Icons.tv),
                    text: 'Tv Shows',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    MoviesPage(),
                    ShowsPage(),
                  ],
                ),
              ),
            ],
          ),
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