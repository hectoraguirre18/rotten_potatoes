import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/movie.dart';
import 'package:rotten_potatoes/screens/movie_details.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {

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
      movies.add(Movie(name: 'Star Wars Episode IV A New Hope'));
      movies.add(Movie(name: 'Avengers: Infinity War'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: movieList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => openDialog(context),
      ),
    );
  }

  Widget movieList() => ListView.separated(
    itemBuilder: (context, index) => ListTile(
      leading: Icon(Icons.movie),
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

  Future openDialog(context) async {

    final formKey = GlobalKey<FormState>();

    final Movie movie = Movie();

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Add a new movie"),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    return 'Please enter a movie name';
                  movie.name = value;
                  return null;
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    movie.description = value;
                  return null;
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RaisedButton(
                  child: Text('ADD MOVIE'),
                  onPressed: () {
                    if(formKey.currentState.validate()) {
                      print('ADD MOVIE');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}