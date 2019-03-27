import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

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

  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Column(
            children:<Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                        image: AssetImage(photos[photoIndex]),
                        fit: BoxFit.cover)),
                height: 400.0,
                width: 300.0,
              ),
              Center(
                child: SelectedPhoto(
                    numberOfDots: photos.length, photoIndex: photoIndex),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Next'),
                    onPressed: _nextImage,
                    elevation: 5.0,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10.0),
                  RaisedButton(
                    child: Text('Prev'),
                    onPressed: _previousImage,
                    elevation: 5.0,
                    color: Colors.blue,
                  )
                ],
              )
            ]
          ),
        ],
      ),
    );
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

    Widget _inactivePhoto() {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4.0)
          ),
        ),
      )
    );
  }

  Widget _activePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 0.0,
                blurRadius: 2.0
              )
            ]
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for(int i = 0; i< numberOfDots; ++i) {
      dots.add(
        i == photoIndex ? _activePhoto(): _inactivePhoto()
      );
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }


}
