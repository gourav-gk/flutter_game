import 'package:flutter/material.dart';
import 'package:game/gamewon.dart';

class TicHome extends StatefulWidget {
  @override
  State<TicHome> createState() => _TicHome();
}

class _TicHome extends State<TicHome> {
  List marks = ['', '', '', '', '', '', '', '', ''];
  int xScore = 0;
  int oScore = 0;
  bool isCurrentO = false;
  bool isGameWon = false;
  String currentTurn = 'X';
  bool isDraw = false;
  var textStyle = TextStyle(color: Colors.white, fontSize: 30);
  void tapAction(int index) {
    if (isGameWon) {
      reset();
    } else {
      setState(() {
        if (marks[index] == '') {
          if (isCurrentO) {
            marks[index] = 'O';
          } else {
            marks[index] = 'X';
          }
        }
        checkWin();
        isCurrentO = !isCurrentO;
        turn();
      });
    }
  }

  void turn() {
    if (isCurrentO) {
      currentTurn = 'O';
    } else {
      currentTurn = 'X';
    }
  }

  void reset() {
    for (int i = 0; i < 9; i++) {
      marks[i] = '';
    }
    isGameWon = false;
    isCurrentO = false;
    currentTurn = 'X';
    isDraw = false;
    setState(() {});
  }

  void checkWin() {
    winCase();
    if (!marks.contains('')) {
      isDraw = true;
    }
    if (isDraw) {
      reset();
    }
    if (isGameWon) {
      if (isCurrentO) {
        oScore++;
      } else {
        xScore++;
      }
    }
  }

  void winCase() {
    if (marks[0] == marks[1] && marks[0] == marks[2] && marks[0] != '') {
      isGameWon = true;
    } else if (marks[3] == marks[4] && marks[3] == marks[5] && marks[3] != '') {
      isGameWon = true;
    } else if (marks[6] == marks[7] && marks[6] == marks[8] && marks[6] != '') {
      isGameWon = true;
    } else if (marks[0] == marks[3] && marks[0] == marks[6] && marks[0] != '') {
      isGameWon = true;
    } else if (marks[1] == marks[4] && marks[1] == marks[7] && marks[1] != '') {
      isGameWon = true;
    } else if (marks[2] == marks[5] && marks[2] == marks[8] && marks[2] != '') {
      isGameWon = true;
    } else if (marks[0] == marks[4] && marks[0] == marks[8] && marks[0] != '') {
      isGameWon = true;
    } else if (marks[2] == marks[4] && marks[2] == marks[6] && marks[2] != '') {
      isGameWon = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Score Board',
                      style: textStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 10.0, right: 15.0),
                          child: Text(
                            'X - $xScore',
                            style: textStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 15.0, right: 10.0),
                          child: Text(
                            'O - $oScore',
                            style: textStyle,
                          ),
                        )
                      ],
                    ),
                  ],
                )),
                Expanded(
                  flex: 3,
                  child: GridView.builder(
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            tapAction(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[600]),
                            child: Center(
                              child: Text(
                                marks[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 50),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    'Current Player - $currentTurn',
                    style: textStyle,
                  ),
                )),
              ],
            ),
            GameWon(isGameWon, reset),
          ],
        ));
  }
}
