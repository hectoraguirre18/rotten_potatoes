import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/movie.dart';
import 'package:rotten_potatoes/screens/movie_details.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  List<Movie> movies;

  @override
  void initState(){
    super.initState();
    readMovies();
  }

  void readMovies() async {
    setState(() {
      movies = [];
      movies.add(Movie(name: 'Frozen', description: 'When the newly crowned Queen Elsa accidentally uses her power to turn things into ice to curse her home in infinite winter, her sister Anna teams up with a mountain man, his playful reindeer, and a snowman to change the weather condition.'));
      movies.add(Movie(name: 'Frozen Long Description', description: 'Fearless optimist Anna teams up with rugged mountain man Kristoff and his loyal reindeer Sven and sets off on an epic journey to find her sister Elsa, whose icy powers have trapped the kingdom of Arendelle in eternal winter. Encountering Everest-like conditions, mystical trolls and a hilarious snowman named Olaf, Anna and Kristoff battle the elements in a race to save the kingdom. From the outside Elsa looks poised, regal and reserved, but in reality she lives in fear as she wrestles with a mighty secret: she was born with the power to create ice and snow. Its a beautiful ability, but also extremely dangerous. Haunted by the moment her magic nearly killed her younger sister Anna, Elsa has isolated herself, spending every waking minute trying to suppress her growing powers. Her mounting emotions trigger the magic, accidentally setting off an eternal winter that she cant stop. She fears shes becoming a monster and that no one, not even her sister, can help her.'));
      movies.add(Movie(name: 'Fast and Furious'));
      movies.add(Movie(name: 'Home Alone'));
      movies.add(Movie(name: 'The Princess Diaries'));
    });
    // setState(() {
    //   results?.forEach((movie) => movies.add(movie));
    // });
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

  Widget movieList() => ListView.separated(
    itemBuilder: (context, index) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: AutoSizeText(
        movies.elementAt(index).name,
        maxLines: 1,
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => MovieDetailsScreen(movies.elementAt(index))
        ));
      },
    ),
    separatorBuilder: (_, __) => Divider(),
    itemCount: movies?.length ?? 0
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