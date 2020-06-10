import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/movie.dart';
import 'package:rotten_potatoes/screens/movie_details.dart';
import 'package:rotten_potatoes/services/movies_service.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> with AutomaticKeepAliveClientMixin {

  List<Movie> movies;

  @override
  void initState(){
    super.initState();
    readMovies();
  }

  Future<void> readMovies() async {
    final movies = await MoviesService.instance.getMovies();
    setState(() => this.movies = movies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: readMovies,
          child: movieList()
        ),
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
                  labelText: 'Description (Optional)',
                ),
                validator: (value) {
                  if(value.isNotEmpty)
                    movie.description = value;
                  return null;
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RaisedButton(
                  child: Text('ADD MOVIE'),
                  onPressed: () async {
                    if(formKey.currentState.validate()) {
                      await MoviesService.instance.saveMovie(movie);
                      Navigator.pop(context);
                      await readMovies();
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

  @override
  bool get wantKeepAlive => true;
}