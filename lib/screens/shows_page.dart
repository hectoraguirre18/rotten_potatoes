import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rotten_potatoes/model/show.dart';
import 'package:rotten_potatoes/screens/show_details.dart';

class ShowsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {

  List<Show> shows;

  @override
  void initState(){
    super.initState();
    readShows();
  }

  void readShows() async {
    setState(() {
      shows = [];
      shows.add(Show(name: 'Stranger Things'));
      shows.add(Show(name: 'The Office'));
      shows.add(Show(name: 'How I Met Your Mother'));
      shows.add(Show(name: 'Friends'));
      shows.add(Show(name: 'That \'70s Show'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: showList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => openDialog(context),
      ),
    );
  }

  Widget showList() => ListView.separated(
    itemBuilder: (context, index) => ListTile(
      leading: Icon(Icons.tv),
      title: AutoSizeText(
        shows.elementAt(index).name,
        maxLines: 1,
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ShowDetailsScreen(shows.elementAt(index))
        ));
      },
    ),
    separatorBuilder: (_, __) => Divider(),
    itemCount: shows?.length ?? 0
  );

  Future openDialog(context) async {

    final formKey = GlobalKey<FormState>();

    final Show show = Show();

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Add a new show"),
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
                    return 'Please enter a show name';
                  show.name = value;
                  return null;
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    show.description = value;
                  return null;
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RaisedButton(
                  child: Text('ADD SHOW'),
                  onPressed: () {
                    if(formKey.currentState.validate()) {
                      print('ADD SHOW');
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