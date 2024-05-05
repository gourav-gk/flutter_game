import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final bool isGameOver;
  final function;
  GameOver(this.isGameOver, this.function);
  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment(0, -0.2),
                child: Text(
                  'G A M E  O V E R',
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
              ),
              Container(
                child: ElevatedButton(
                  child: Text('Play Again'),
                  onPressed: function,
                ),
              )
            ],
          )
        : Container();
  }
}
