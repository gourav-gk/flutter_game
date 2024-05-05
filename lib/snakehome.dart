import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/gameover.dart';
import 'package:game/gamestart.dart';

class SnakeHome extends StatefulWidget {
  @override
  State<SnakeHome> createState() => _SnakeHome();
}

class _SnakeHome extends State<SnakeHome> {
  int rows = 20;
  int columns = 30;
  int initialSnakeLength = 3;

  List<int> snake = [3, 2, 1];
  int direction = 2; // 0: up, 1: right, 2: down, 3: left
  int food = 223;
  bool hasGameStarted = false;
  bool isGameOver = false;
  int score = 0;

  void startGame() {
    if (!hasGameStarted) {
      hasGameStarted = true;
      Timer.periodic(Duration(milliseconds: 300), (timer) {
        setState(() {
          moveSnake();
          checkCollision();
          checkFood();
          if (isGameOver) {
            timer.cancel();
          }
        });
      });
    }
  }

  void spawnFood() {
    food = Random().nextInt(rows * columns);
  }

  void moveSnake() {
    setState(() {
      int head = snake.first;
      switch (direction) {
        case 0:
          if (head < rows) {
            snake.insert(0, head - rows + (rows * columns));
          } else {
            snake.insert(0, head - rows);
          }
          break;
        case 1:
          if ((head + 1) % rows == 0) {
            snake.insert(0, head + 1 - 20);
          } else {
            snake.insert(0, head + 1);
          }
          break;
        case 2:
          if (head > rows * columns) {
            snake.insert(0, head - (rows * columns));
          } else {
            snake.insert(0, head + rows);
          }
          break;
        case 3:
          if (head % rows == 0) {
            snake.insert(0, head - 1 + 20);
          } else {
            snake.insert(0, head - 1);
          }
          break;
      }
      if (snake.length > initialSnakeLength) {
        snake.removeLast();
      }
    });
  }

  void checkCollision() {
    int head = snake.first;
    int count = snake.where((item) => item == head).length;
    if (count > 1) {
      isGameOver = true;
    }
  }

  void checkFood() {
    int head = snake.first;

    if (head == food) {
      score++;
      spawnFood();
      setState(() {
        snake.add(snake.last);
      });
    }
  }

  void gameReset() {
    score = 0;
    snake = [3, 2, 1];
    direction = 2;
    isGameOver = false;
    hasGameStarted = false;
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0 && direction != 0) {
                      direction = 2;
                    } else if (details.delta.dy < 0 && direction != 2) {
                      direction = 0;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 && direction != 3) {
                      direction = 1;
                    } else if (details.delta.dx < 0 && direction != 1) {
                      direction = 3;
                    }
                  },
                  child: Container(
                    color: Colors.grey[300],
                    child: GridView.builder(
                      itemCount: rows * columns,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rows,
                      ),
                      itemBuilder: (context, index) {
                        if (snake.contains(index)) {
                          return Container(
                            color: Colors.green,
                          );
                        } else if (index == food) {
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                          );
                        } else {
                          return Container(
                            color: Colors.grey[300],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Score : $score',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  ElevatedButton.icon(
                      onPressed: startGame,
                      icon: Icon(Icons.play_circle),
                      label: Text('play'))
                ],
              ))
            ],
          ),
          GameStart(hasGameStarted),
          GameOver(isGameOver, gameReset)
        ],
      ),
    );
  }
}
