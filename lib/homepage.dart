import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/ball.dart';
import 'package:game/brick.dart';
import 'package:game/coverscreen.dart';
import 'package:game/gameover.dart';
import 'package:game/gamewon.dart';
import 'package:game/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  var ballYdirection = Direction.down;
  var ballXdirection = Direction.left;
  double ballx = 0;
  double bally = 0;
  double ballXincrement = 0.01;
  double ballYincrement = 0.01;
  double playerx = -0.2;
  double playerWidth = 0.4;
  bool isGameOver = false;
  bool isGameWon = false;

  static double brickWidth = 0.3;
  static double brickHeight = 0.05;
  static double brickX = -1 + wallGap;
  static double brickGap = 0.01;
  static double brickVGap = 0.03;
  static int col = 6;
  static int row = 3;
  static double wallGap = 0.5 * (2 - (col * brickWidth) + (col - 1) * brickGap);
  static double brickY = -0.9;

  bool hasGameStarted = false;

  List bricks = [];

  void generateBricks() {
    for (int i = 0; i < row; i++) {
      double brickYPosition = brickY + i * (brickHeight + brickVGap);
      for (int j = 0; j < col; j++) {
        double brickXPosition = brickX + j * (brickWidth + brickGap);
        bricks.add([brickXPosition, brickYPosition, false]);
      }
    }
  }

  void resetGame() {
    setState(() {
      ballx = 0;
      bally = 0;
      playerx = -0.2;
      isGameOver = false;
      hasGameStarted = false;
      isGameWon = false;
      generateBricks();
    });
  }

  bool checkGameWon() {
    int brokenBrickCount = 0;
    for (int j = 0; j < bricks.length; j++) {
      if (bricks[j][2] == true) {
        brokenBrickCount++;
      }
    }
    if (brokenBrickCount == bricks.length) {
      return true;
    }
    return false;
  }

  void startGame() {
    if (hasGameStarted == false) {
      generateBricks();
      hasGameStarted = true;
      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        updateDirection();
        moveBall();
        if (isPlayerDead()) {
          timer.cancel();
          isGameOver = true;
        }
        checkBrick();
        if (checkGameWon()) {
          timer.cancel();
          isGameWon = true;
        }
      });
    }
  }

  void checkBrick() {
    for (int i = 0; i < bricks.length; i++) {
      if (bally <= bricks[i][1] + brickHeight &&
          ballx >= bricks[i][0] &&
          ballx <= bricks[i][0] + brickWidth &&
          bricks[i][2] == false) {
        setState(() {
          bricks[i][2] = true;

          double leftSideDist = (bricks[i][0] - ballx).abs();
          double rightSideDist = (bricks[i][0] + brickWidth - ballx).abs();
          double topSideDist = (bricks[i][1] - bally).abs();
          double bottomSideDist = (bricks[i][1] + brickHeight - ballx).abs();

          String min =
              findmin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          //update direction of brick

          // if ball hits bottom of brick
          switch (min) {
            case 'left':
              ballXdirection = Direction.left;
              break;
            case 'right':
              ballXdirection = Direction.right;
              break;
            case 'top':
              ballYdirection = Direction.down;
              break;
            case 'bottom':
              ballYdirection = Direction.up;
              break;
          }
        });
      }
    }
  }

  String findmin(double l, double r, double u, double d) {
    List<double> mylist = [r, u, d];
    double currentMin = l;
    int index = 0;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i] < currentMin) {
        currentMin = mylist[i];
        index = i + 1;
      }
    }
    if (index == 0) {
      return "left";
    } else if (index == 1) {
      return "rigt";
    } else if (index == 2) {
      return "top";
    } else {
      return "botttom";
    }
  }

  bool isPlayerDead() {
    if (bally > 1) {
      return true;
    }

    return false;
  }

  void updateDirection() {
    setState(() {
      if (bally > 0.9 && ballx >= playerx && ballx <= playerx + playerWidth) {
        ballYdirection = Direction.up;
      } else if (bally < -1) {
        ballYdirection = Direction.down;
      } else if (ballx >= 1) {
        ballXdirection = Direction.left;
      } else if (ballx <= -1) {
        ballXdirection = Direction.right;
      }
    });
  }

  void moveBall() {
    setState(() {
      // vertical directon
      if (ballYdirection == Direction.down) {
        bally += ballYincrement;
      } else if (ballYdirection == Direction.up) {
        bally -= ballYincrement;
      }

      // horizontal directon
      if (ballXdirection == Direction.left) {
        ballx -= ballXincrement;
      } else if (ballXdirection == Direction.right) {
        ballx += ballXincrement;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerx - 0.02 < -1)) {
        playerx -= 0.02;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerx + playerWidth >= 1)) {
        playerx += 0.02;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget gameWidget;

    if (Platform.isAndroid || Platform.isIOS) {
      gameWidget = GestureDetector(
        onTap: startGame,
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            moveRight();
          } else if (details.primaryDelta! < 0) {
            moveLeft();
          }
        },
        child: buildGameContent(),
      );
    } else if (kIsWeb) {
      gameWidget = RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              moveLeft();
            } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              moveRight();
            }
          },
          child: GestureDetector(
            onTap: startGame,
            child: buildGameContent(),
          ));
    } else {
      gameWidget = RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              moveLeft();
            } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              moveRight();
            }
          },
          child: GestureDetector(
            onTap: startGame,
            child: buildGameContent(),
          ));
    }
    return gameWidget;
  }

  Widget buildGameContent() {
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Center(
          child: Stack(
            children: [
              // play
              CoverScreen(hasGameStarted: hasGameStarted),

              // Game over
              GameOver(isGameOver, resetGame),

              // Game won

              GameWon(isGameWon, resetGame),

              // ball
              Ball(ballx: ballx, bally: bally),

              // player
              MyPlayer(
                playerx: playerx,
                playerWidth: playerWidth,
              ),

              // brick

              for (int i = 0; i < bricks.length; i++)
                Brick(bricks[i][0], bricks[i][1], brickWidth, brickHeight,
                    bricks[i][2]),
            ],
          ),
        ));
  }
}
