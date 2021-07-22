import 'package:flappybird/barrier.dart';
import 'package:flappybird/bird.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double s = 0;
  int highScore = 0;
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double gravity = -4.9;
  double time = 0;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  bool gameHasStarted = false;
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });
      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }
      moveMap();
      s = s + 0.1;
      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  void resetGame() {
    if (s > highScore) {
      highScore = s.toInt();
    }
    s = 0;
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (buildContext) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(25),
            backgroundColor: Colors.brown,
            title: Center(
              child: Column(
                  children: [
                Text(
                  'G A M E  O V E R',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20,),
                Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'S C O R E   ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      s.toInt().toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ]),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Stack(
                      children: [
                        MyBird(
                          birdY: birdY,
                          birdWidth: birdWidth,
                          birdHeight: birdHeight,
                        ),
                        Container(
                          alignment: Alignment(0, -0.5),
                          child: gameHasStarted
                              ? Text('')
                              : Text(
                                  'T A P  T O  P L A Y',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        MyBarrier(
                          isThisBottomBarrier: false,
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          barrierX: barrierX[0],
                        ),
                        MyBarrier(
                          isThisBottomBarrier: true,
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          barrierX: barrierX[0],
                        ),
                        MyBarrier(
                          isThisBottomBarrier: false,
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          barrierX: barrierX[1],
                        ),
                        MyBarrier(
                          isThisBottomBarrier: true,
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          barrierX: barrierX[1],
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                child: Container(
              color: Colors.brown,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s.toInt().toString(),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'S C O R E',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          highScore.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'B E S T',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
