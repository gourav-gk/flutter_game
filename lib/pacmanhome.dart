import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/gameover.dart';
import 'package:game/gamestart.dart';
import 'package:game/gamewon.dart';
import 'package:game/ghost.dart';
import 'package:game/pixel.dart';
import 'package:game/path.dart';
import 'package:game/pacplayer.dart';

class PacmanHome extends StatefulWidget {
  @override
  State<PacmanHome> createState() => _PacmanHome();
}

class _PacmanHome extends State<PacmanHome> {
  List<int> bricks = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    21,
    22,
    24,
    26,
    28,
    30,
    32,
    33,
    35,
    37,
    38,
    39,
    41,
    43,
    44,
    46,
    52,
    54,
    55,
    57,
    59,
    61,
    63,
    65,
    66,
    70,
    72,
    76,
    77,
    78,
    79,
    80,
    81,
    83,
    84,
    85,
    86,
    87,
    99,
    100,
    101,
    102,
    103,
    105,
    106,
    107,
    108,
    109,
    110,
    114,
    116,
    120,
    121,
    123,
    125,
    127,
    129,
    131,
    132,
    134,
    140,
    142,
    143,
    145,
    147,
    148,
    149,
    151,
    153,
    154,
    156,
    158,
    160,
    162,
    164,
    165,
    175,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186
  ];
  List<int> food = [];
  int player = 166;
  int ghost = 12;
  String direction = "right";
  int numRow = 11;
  int numSquare = 11 * 17;
  final pi = 3.14;
  int score = 0;
  bool mouthClosed = false;
  bool isGameOver = false;
  bool isGameStart = false;
  bool isGameWon = false;

  void startGame() {
    if (!isGameStart) {
      isGameStart = true;
      setFood();
      ghostRandomMove();

      Timer.periodic(const Duration(milliseconds: 150), (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (food.contains(player)) {
          food.remove(player);
          score++;
        }
        switch (direction) {
          case 'right':
            moveRight();
            break;
          case 'left':
            moveLeft();
            break;
          case 'up':
            moveUp();
            break;
          case 'down':
            moveDown();
            break;
        }
        if (checkGameWon()) {
          timer.cancel();
          isGameWon = true;
        }
        if (checkGameOver()) {
          timer.cancel();
          isGameOver = true;
        }
      });
    }
  }

  bool checkGameWon() {
    if (food.isEmpty) {
      return true;
    }
    return false;
  }

  bool checkGameOver() {
    if (player == ghost) {
      return true;
    }
    return false;
  }

  void ghostRandomMove() {
    List<String> ghostDirection = ['right', 'left', 'up', 'down'];
    int randomIndex;
    String randomDirection = 'right';
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      randomIndex = Random().nextInt(ghostDirection.length);
      randomDirection = ghostDirection[randomIndex];
      //});
      //Timer.periodic(Duration(microseconds: 150), (timer) {
      switch (randomDirection) {
        case 'right':
          if (!bricks.contains(ghost + 1)) {
            setState(() {
              ghost++;
            });
          }
          break;
        case 'left':
          if (!bricks.contains(ghost - 1)) {
            setState(() {
              ghost--;
            });
          }
          break;
        case 'up':
          if (!bricks.contains(ghost - numRow)) {
            setState(() {
              ghost = ghost - numRow;
            });
          }
          break;
        case 'down':
          if (!bricks.contains(ghost + numRow)) {
            setState(() {
              ghost = ghost + numRow;
            });
          }
          break;
      }
    });
  }

  void resetGame() {
    player = 166;
    ghost = 12;
    score = 0;
    isGameStart = false;
    isGameOver = false;
    isGameWon = false;
    food.clear();
    startGame();
  }

  void setFood() {
    for (int i = 0; i < numSquare; i++) {
      if (!bricks.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveRight() {
    if (!bricks.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveLeft() {
    if (!bricks.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveUp() {
    if (!bricks.contains(player - numRow)) {
      setState(() {
        player = player - numRow;
      });
    }
  }

  void moveDown() {
    if (!bricks.contains(player + numRow)) {
      setState(() {
        player = player + numRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0) {
                        direction = "down";
                      } else if (details.delta.dy < 0) {
                        direction = "up";
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0) {
                        direction = "right";
                      } else if (details.delta.dx < 0) {
                        direction = "left";
                      }
                    },
                    child: Container(
                        child: GridView.builder(
                            itemCount: numRow * 17,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: numRow),
                            itemBuilder: ((context, index) {
                              if (mouthClosed && player == index) {
                                return Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle),
                                  ),
                                );
                              } else if (player == index) {
                                switch (direction) {
                                  case 'right':
                                    return PacPlayer();
                                  case 'left':
                                    return Transform.rotate(
                                      angle: pi,
                                      child: PacPlayer(),
                                    );
                                  case 'up':
                                    return Transform.rotate(
                                      angle: 3 * pi / 2,
                                      child: PacPlayer(),
                                    );
                                  case 'down':
                                    return Transform.rotate(
                                      angle: pi / 2,
                                      child: PacPlayer(),
                                    );
                                  default:
                                    return PacPlayer();
                                }
                              } else if (bricks.contains(index)) {
                                return Pixel(color: Colors.brown);
                              } else if (ghost == index) {
                                return Ghost();
                              } else if (food.contains(index)) {
                                return Path(color: Colors.yellow);
                              } else {
                                return Pixel(
                                  color: Colors.black,
                                );
                              }
                            }))),
                  )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('SCORE : $score',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  GestureDetector(
                      onTap: startGame,
                      child: const Text(
                        'PLAY',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ))
                ],
              ))
            ],
          ),
          GameStart(isGameStart),
          GameOver(isGameOver, resetGame),
          GameWon(isGameWon, resetGame)
        ],
      ),
    );
  }
}
