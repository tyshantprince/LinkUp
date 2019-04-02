import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseUser myUser;

  bool isLoggedIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _loginWithFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logInWithReadPermissions(['email']);

    debugPrint(result.status.toString());

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      FirebaseUser user = await _auth.signInWithCredential(credential);
      return user;
    }
    return null;
  }

  void _login() {
    _loginWithFacebook().then((response) {
      if (response != null) {
        myUser = response;
        isLoggedIn = true;
        debugPrint(myUser.toString());
        setState(() {});
      }
    });
  }

  @override
  build(BuildContext context) {
    return CupertinoApp(
        title: 'App',
        home: isLoggedIn
            ? HomeScreen()
            : CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  backgroundColor: Colors.transparent,
                ),
                child: Center(
                  child: FacebookSignInButton(
                    onPressed: _login,
                  ),
                ),
              ));
  }
}

class SignIn extends InheritedWidget {
  SignIn({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Post of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Post);
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
          leading: Icon(CupertinoIcons.photo_camera_solid), // Search Button
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
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/loading.gif'),
                          alignment: Alignment(0, -0.5))),
                  child: FadeInImage.memoryNetwork(
                    image: i,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    alignment: Alignment.center,
                    fadeInDuration: Duration(milliseconds: 200),
                  ),
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
