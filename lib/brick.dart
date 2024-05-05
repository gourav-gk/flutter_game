import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  final brickX;
  final brickY;
  final brickWidth;
  final brickHeight;
  final bool isBrickBroken;

  Brick(this.brickX, this.brickY, this.brickWidth, this.brickHeight,
      this.isBrickBroken);
  @override
  Widget build(BuildContext context) {
    return isBrickBroken
        ? Container()
        : Container(
            alignment:
                Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: MediaQuery.of(context).size.width * brickWidth / 2,
                height: MediaQuery.of(context).size.height * brickHeight / 2,
                color: Colors.deepPurple,
              ),
            ),
          );
  }
}
