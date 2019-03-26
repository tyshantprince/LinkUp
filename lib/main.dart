import 'package:flutter/cupertino.dart';
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
      child: Container(
        child: Column(
          children: <Widget>[
            TopNav(),
          ],
        ),
      ),
    );
  }
}

class TopNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: CupertinoButton(
          child: Align(
            alignment: Alignment.topLeft,
            
            child: Icon(
              CupertinoIcons.calendar_today,
            ),
          ),
        ),
        ),
        Expanded(child: CupertinoButton(
          child: Align(
            alignment: Alignment.topRight,
            child: Icon(
              CupertinoIcons.person_solid,
            ),
          ),
        ),
        ),
      ]
    );
  }
}
