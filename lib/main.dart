import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  int _start = 0;
  int styleIndex = 0;

  List<ScreenStyle> styles = [
    ScreenStyle("sky", "background_1.jpg", Color(0xFFFA5D79)),
    ScreenStyle("forest", "background_2.jpg", Color(0xFFE7B73D)),
    ScreenStyle("sea", "background_3.jpg", Color(0xFF226DEF))
  ];

  CountDownController controller = CountDownController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.start();
      controller.pause();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(
                  "assets/${styles[styleIndex].backgroundImage}",
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 60,
              left: 100,
              right: 100,
              child: RaisedButton(
                color: styles[styleIndex].buttonColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  controller.start();
                },
                child: Text(
                  "start",
                  style: TextStyle(fontSize: 28.0, color: Colors.white),
                ),
              )),
          Positioned(
            bottom: 445,
            left: 100,
            right: 100,
            child: CircularCountDownTimer(
              controller: controller,
              strokeWidth: 10.0,
              isReverse: true,
              autoStart: false,
              duration: 1200,
              ringColor: Colors.white.withOpacity(0.2),
              fillColor: styles[styleIndex].buttonColor,
              width: 200,
              height: 200,
              textStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (styleIndex == 0) {
                      styleIndex = styles.length - 1;
                    } else {
                      styleIndex--;
                    }
                  });
                },
                child: Icon(
                  Icons.arrow_left_rounded,
                  color: styles[styleIndex].buttonColor,
                  size: 95.0,
                ),
              ),
              SizedBox(width: 20, height: 120),
              Text(
                styles[styleIndex].title,
                style: TextStyle(fontSize: 30.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    if (styleIndex == styles.length - 1) {
                      styleIndex = 0;
                      return;
                    }
                    styleIndex++;
                  });
                },
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: styles[styleIndex].buttonColor,
                  size: 95.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScreenStyle {
  final String title;
  final String backgroundImage;
  final Color buttonColor;
  ScreenStyle(this.title, this.backgroundImage, this.buttonColor);
}
