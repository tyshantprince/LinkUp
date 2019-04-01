import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:intl/intl.dart';
import 'dart:developer';

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
    // Hides Toolbar
    FlutterStatusbarManager.setHidden(true,
        animation: StatusBarAnimation.SLIDE);

// Initial Home Page Template
    return CupertinoPageScaffold(
        //Navigation Bar
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          trailing: Icon(CupertinoIcons.photo_camera_solid), // Search Button
          middle: Text('Sat, June 15th'),
        ), // Current Date
        child: StreamBuilder(
          stream: Firestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Loading...");
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, snapshot.data.documents[index]);
              },
            );
          },
        ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
        child: Post(
            document: document,
            child: Stack(
              children: <Widget>[
                PostImages(),
                ProfileCard(),
              ],
            )));
  }
}

class Post extends InheritedWidget {
  final DocumentSnapshot document;

  Post({this.document, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Post of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Post);
}

class PostImages extends StatefulWidget {
  @override
  _PostImagesState createState() => new _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  int photoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final document = Post.of(context).document;
    List<String> photos = [];
    log("Document: ${document["media"]}");
    for (var i in document['media']) {
      photos.add(i);
    }

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
                          image: NetworkImage(i), fit: BoxFit.cover)),
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
    final document = Post.of(context).document;
    final start_date = DateTime.fromMillisecondsSinceEpoch(
        document["start_time"].seconds * 1000);
    final formatted_start_date = new DateFormat.yMMMMEEEEd().format(start_date);
    final formatted_start_time = new DateFormat.jm().format(start_date);

    final end_date = DateTime.fromMillisecondsSinceEpoch(
        document["end_time"].seconds * 1000);
    final formatted_end_date = new DateFormat.yMMMMEEEEd().format(end_date);
    final formatted_end_time = new DateFormat.jm().format(end_date);

    return Container(
        margin: const EdgeInsets.only(top: 500.0),
        child: Column(children: <Widget>[
          Opacity(
              opacity: .75,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_pic.jpg'),
                        radius: 25.0,
                      ),
                      title: Text(document["title"]),
                      subtitle: Text(formatted_start_date +
                          "\n" +
                          formatted_start_time +
                          " to " +
                          formatted_end_time),
                    )
                  ],
                ),
              )),
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
