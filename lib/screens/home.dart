import 'package:flutter/material.dart';
import 'package:rotten_potatoes/screens/movies_page.dart';
import 'package:rotten_potatoes/screens/shows_page.dart';
import 'package:rotten_potatoes/services/auth_service.dart';

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
                    text: 'Movies',
                  ),
                  Tab(
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
          SizedBox(width: 24),
          Image.asset(
            'assets/images/logo.png',
            height: kToolbarHeight*0.8,
          ),
          InkWell(
            child: Icon(
              Icons.account_circle
            ),
            onTap: onClickAccount,
          ),
        ],
      ),
    ),
    preferredSize: Size.fromHeight(kToolbarHeight)
  );

  void onClickAccount() {
    Widget cancelButton = FlatButton(
      child: Text('Cancel'),
      onPressed:  () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text('You\'re not signed in :('),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            child: Text('SIGN IN'),
            onPressed: (){
              Navigator.pop(context);
              AuthService.instance.openSignInDialog(context);
            }
          ),
          RaisedButton(
            child: Text('CREATE ACCOUNT'),
            onPressed: (){
              Navigator.pop(context);
              AuthService.instance.openSignUpDialog(context);
            }
          ),
        ],
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