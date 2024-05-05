import 'package:flutter/material.dart';

class GameWon extends StatelessWidget {
  final bool isGameWon;
  final function;
  GameWon(this.isGameWon, this.function);
  @override
  Widget build(BuildContext context) {
    return isGameWon
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment(0, -0.2),
                child: Text('YOU WON'),
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
