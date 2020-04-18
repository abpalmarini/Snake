import 'package:snakeai/directions.dart';
import 'package:snakeai/snake_game.dart';
import 'dart:ui';

class SimpleAI {
  final SnakeGame game;
  int borderLeftTop;
  int borderRightBottom;

  SimpleAI(this.game) {
    borderLeftTop = (game.gridSize * 3).round();
    borderRightBottom = (game.gridSize * 32).round();
  }

  void move() {
    int snakeX = game.head.targetLocation.dx.round();
    int snakeY = game.head.targetLocation.dy.round();
    int appleX = game.apple.rect.left.round();
    int appleY = game.apple.rect.top.round();


    if (snakeY > appleY && game.direction != Directions.DOWN) {
      game.direction = Directions.UP;
    } else if (snakeY < appleY && game.direction != Directions.UP) {
      game.direction = Directions.DOWN;
    } else if (snakeX > appleX && game.direction != Directions.RIGHT) {
      game.direction = Directions.LEFT;
    } else if (snakeX < appleX && game.direction != Directions.LEFT) {
      game.direction = Directions.RIGHT;
    }
		
  }

  void update(double timeDelta) {
		move();
  }
}
