import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
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
  int duration = 1200;
  int styleIndex = 0;

  List<ScreenStyle> styles = [
    ScreenStyle("sky", "background_1.jpg", Color(0xFFFA5D79)),
    ScreenStyle("forest", "background_2.jpg", Color(0xFFE7B73D)),
    ScreenStyle("sea", "background_3.jpg", Color(0xFF226DEF))
  ];

  final CountDownController _countDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    //provede se při spuštění appky - jde o to aby tam nebyly ty 00:00:00
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _countDownController.start();
      _countDownController.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: height,
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
            bottom: height * 0.9,
            right: width * 0.05,
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.volume_down_sharp,
                color: Colors.black,
                size: width * 0.1,
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.58,
            left: width * 0.25,
            right: width * 0.25,
            child: CircularCountDownTimer(
              controller: _countDownController,
              strokeWidth: width * 0.04,
              isReverse: true,
              autoStart: false,
              duration: duration,
              ringColor: Colors.white.withOpacity(0.2),
              fillColor: styles[styleIndex].buttonColor,
              width: width * 0.25,
              height: height * 0.25,
              textStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: width * 0.1,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: height * 0.61,
            left: width * 0.25,
            right: width * 0.25,
            child: InkWell(
              onTap: () {
                duration = duration + 300;
                _countDownController.restart(duration: duration);
                _countDownController.pause();
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: width * 0.1,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: height * 0.1,
            child: Row(
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
                    size: width * 0.3,
                  ),
                ),
                PlayButton(
                  controller: _countDownController,
                  width: width * 0.25,
                  color: styles[styleIndex].buttonColor,
                  key: UniqueKey(),
                ),
                RestartButton(
                  onTap: () {
                    _countDownController.restart(duration: 1200);
                    _countDownController.pause();
                    duration = 1200;
                    setState(() {});
                  },
                  height: height * 0.1,
                  width: width * 0.25,
                  color: styles[styleIndex].buttonColor,
                ),
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
                    size: width * 0.3,
                  ),
                )
              ],
            ),
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

class PlayButton extends StatefulWidget {
  final CountDownController controller;
  final Color color;
  final double width;
  const PlayButton(
      {required this.controller,
      required this.color,
      required this.width,
      Key? key})
      : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: isRunning
            ? () {
                widget.controller.pause();
                setState(() {
                  isRunning = false;
                });
              }
            : () {
                widget.controller.resume();
                setState(() {
                  isRunning = true;
                });
              },
        child: Icon(
          isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill,
          size: widget.width * 0.8,
          color: widget.color,
        ));
  }
}

class RestartButton extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final double height;
  final double width;
  const RestartButton(
      {required this.onTap,
      required this.color,
      required this.height,
      required this.width,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Icon(
          Icons.stop_circle,
          size: width * 0.8,
          color: color,
        ));
  }
}
