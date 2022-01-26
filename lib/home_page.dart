import 'dart:async';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  // double gravity = -4.9;
  // double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  int score = 0;
  int bestScore = 0;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 2;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];
  @override
  void initState() {
    gameHasStarted = false;
    birdY = 0;
    time = 0;
    initialPos = birdY;
    barrierXone = 1;
    barrierXtwo = barrierXone + 2;
    score = 0;
    super.initState();
  }

  void onInit() {
    setState(() {
      gameHasStarted = false;
      birdY = 0;
      time = 0;
      initialPos = birdY;
      barrierXone = 1;
      barrierXtwo = barrierXone + 2;
      score = 0;
    });
  }
  // void startGame() {
  //   gameHasStarted = true;
  //   Timer.periodic(Duration(milliseconds: 10), (timer) {
  //     height = gravity * time * time + velocity * time;
  //     setState(() {
  //       birdY = initialPos - height;
  //     });

  //     if (birdIsDead()) {
  //       timer.cancel();
  //       _showDialog();
  //     }
  //     time += 0.1;
  //   });
  // }

  // void resetGame() {
  //   Navigator.pop(context);
  //   setState(() {
  //     birdY = 0;
  //     gameHasStarted = false;
  //     time = 0;
  //     initialPos = birdY;
  //   });
  // }

  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            "G A M E  O V E R",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Score:   ${score.toString()}",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (score > bestScore) {
                  bestScore = score;
                }
                onInit();
                setState(() {
                  gameHasStarted = false;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Play Again",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  // bool checkBarrierLost() {
  //   if (barrierXone > 0.2 && barrierXone < -0.2) {
  //     if (birdY < 0.3 || birdY > 0.7) {
  //       return true;
  //     }
  //   }
  //   if (barrierXtwo > 0.2 && barrierXtwo < -0.2) {
  //     if (birdY < 0.3 || birdY > 0.7) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdY = initialPos - height;
        barrierXone -= 0.05;
        barrierXtwo -= 0.05;
      });
      setState(() {
        if (barrierXone < -2) {
          barrierXone += 3.5;
          score++;
        } else {
          barrierXone -= 0.05;
        }
      });
      setState(() {
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          score++;
        } else {
          barrierXtwo -= 0.05;
        }
      });
      if (birdY < -1 || birdY > 1) {
        timer.cancel();
        // gameHasStarted = false;
        _showDialog();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdY),
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: Bird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted
                          ? Text("")
                          : Text(
                              "T A P  T O  P L A Y",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.5),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, -1.7),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, 1.5),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, -1.7),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 250.0,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          bestScore.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
