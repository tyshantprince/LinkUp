import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: Icon(CupertinoIcons.search),
        middle: Text('Sat, June 15th'),
        trailing: SizedBox(
            height: 25.0,
            width: 25.0,
            child: new CupertinoButton(
              padding: new EdgeInsets.all(0.0),
              child: Hero(
                  tag: 'anime',
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_pic.jpg'),
                    radius: 25.0,
                  )),
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    )
                  },
            )));
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        middle: SizedBox(
          height: 25.0,
          width: 70.0,
          child: Center(child: Text('1BossTy')),
        ),
        trailing: SizedBox(
            height: 25.0,
            width: 25.0,
            child: new CupertinoButton(
              padding: new EdgeInsets.all(0.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  CupertinoIcons.settings,
                  color: Colors.blueGrey,
                ),
                radius: 25.0,
              ),
              onPressed: () => {},
            )),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[ProfileAvatar(), PreviousPosts()],
      ),
    );
  }
}

class PreviousPosts extends StatefulWidget {
  @override
  _PreviousPostsState createState() => new _PreviousPostsState();
}

class _PreviousPostsState extends State<PreviousPosts> {
  int photoIndex = 0;

  List<String> photos = ['assets/princess2.JPG', 'assets/princess.gif'];

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white30,
      child: new GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(2.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <String>["assets/princess2.JPG", "assets/kellycopy.jpg"]
              .map((String url) {
            return new GridTile(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(url), fit: BoxFit.cover)),
            ));
          }).toList()),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
              height: 100.0,
              width: 100.0,
              child: new CupertinoButton(
                padding: new EdgeInsets.all(0.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/kellycopy.jpg'),
                  radius: 100.0,
                ),
                onPressed: () => {},
              ))
        ],
      )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[Text('12'), Text('posts')],
          ),
          Column(
            children: <Widget>[Text('709'), Text('followers')],
          ),
          Column(
            children: <Widget>[Text('504'), Text('following')],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Outwest, Chicago | Illinois State',
            style: TextStyle(),
          )
        ],
      )
    ]);
  }
}
