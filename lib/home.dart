import 'package:flutter/material.dart';
import 'package:game/gameboard.dart';
import 'package:game/homepage.dart';
import 'package:game/pacmanhome.dart';
import 'package:game/snakehome.dart';
import 'package:game/tichome.dart';

class GameList {
  final BuildContext context;
  late List games;

  GameList(this.context) {
    games = [
      ['Bricks', 'Brick Breaker', gameBricks, 'assets/images/brick_icon.png'],
      ['Tetris', 'Tetris', gameTetris, 'assets/images/tetris_icon.png'],
      ['TicTacToe', 'TicTacToe', gameTicTacToe, 'assets/images/tic_icon.png'],
      ['Pacman', 'Pacman', gamePacman, 'assets/images/pacman_icon.png'],
      ['Snake', 'Snake Game', gameSnake, 'assets/images/snake_icon.png']
    ];
  }

  gameSnake() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SnakeHome()));
  }

  gamePacman() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PacmanHome()));
  }

  gameTicTacToe() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TicHome()));
  }

  gameBricks() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  gameTetris() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GameBoard()));
  }
}

class Home extends StatelessWidget {
  final name;
  Home({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    final GameList gameList = GameList(context);
    return Scaffold(
      appBar: AppBar(title: Text('Hello $name')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image(image: AssetImage(gameList.games[index][3])),
            title: Text(gameList.games[index][0]),
            subtitle: Text(gameList.games[index][1]),
            trailing: IconButton(
              icon: Icon(Icons.play_circle_outlined),
              onPressed: () {
                gameList.games[index][2]();
              },
            ),
          );
        },
        itemCount: gameList.games.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 20,
            thickness: 1,
          );
        },
      ),
    );
  }
}
