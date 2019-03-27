import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating/flutter_rating.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return CupertinoApp(title: 'App', home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarManager.setHidden(true,
        animation: StatusBarAnimation.SLIDE);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          leading: Icon(CupertinoIcons.search),
          middle: Text('Sat, June 15th'),
          trailing: SizedBox(
                  height: 18.0,
                  width: 18.0,
                  child: new CupertinoButton(
                      padding: new EdgeInsets.all(0.0),
                      color: Colors.blueGrey,
                      child: new Icon(CupertinoIcons.person, size: 18.0),
                      onPressed: () => {},
                  )
                )),
      child: ListView(
        children: <Widget>[
          Post(),
        ],
      ),
    );
  }
}

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PostImages(),
        ProfileCard(),
      ],
    );
  }
}

class PostImages extends StatefulWidget {
  @override
  _PostImagesState createState() => new _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  int photoIndex = 0;

  List<String> photos = ['assets/princess2.JPG', 'assets/princess.gif'];

  @override
  Widget build(BuildContext context) {
    return (Column(children: <Widget>[
      CarouselSlider(
        enableInfiniteScroll: false,
        initialPage: 0,
        viewportFraction: 1.0,
        height: MediaQuery.of(context).size.height,
        items: photos.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(i), fit: BoxFit.cover)),
                ),
              );
            },
          );
        }).toList(),
      ),
    ]));
  }
}

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => new _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 500.0),
        child: Column(children: <Widget>[
          Opacity(
              opacity: .75,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/profile_pic.jpg'),
                          radius: 25.0,
                        ),
                        title: Text(
                          'Princess\'s 2nd Birthday Celebration ',
                        ),
                        subtitle: Text("3:00pm to 7:00pm")),
                  ],
                ),
              )),
          StarCount(),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Icon(
                  CupertinoIcons.mail,
                  size: 40.0,
                ),
                textColor: CupertinoColors.activeBlue,
                onPressed: () => {},
              ),
              FlatButton(
                child: Icon(
                  CupertinoIcons.person_add,
                  size: 40.0,
                ),
                textColor: CupertinoColors.activeGreen,
                onPressed: () => {},
              )
            ],
            alignment: MainAxisAlignment.spaceBetween,
          )
        ]));
  }
}

class StarCount extends StatefulWidget {
  @override
  _StarCountState createState() => new _StarCountState();
}

class _StarCountState extends State<StarCount> {
  double rating = 3.5;
  int starCount = 5;

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new Padding(
        padding: new EdgeInsets.only(
          top: 20.0,
        ),
        child: new StarRating(
          size: 25.0,
          rating: rating,
          color: Colors.orange,
          borderColor: Colors.grey,
          starCount: starCount,
          onRatingChanged: (rating) => setState(
                () {
                  this.rating = rating;
                },
              ),
        ),
      ),
    ]);
  }
}
