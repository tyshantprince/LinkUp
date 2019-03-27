import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          middle: Text('Tuesday'),
          trailing: Icon(CupertinoIcons.person_solid)),
      child: ListView(
        children: <Widget>[
          Post(),
          Text("Hey"),
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

  List<String> photos = ['assets/profile_pic.jpg', 'assets/wallpaper.jpg'];

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
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 6.0),

                decoration: BoxDecoration(color: Colors.transparent),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      image: DecorationImage(
                          image: AssetImage(i),
                          fit: BoxFit.cover)),
                ),
              );
            },
          );
        }).toList(),
      ),
    ]));
  }
}
