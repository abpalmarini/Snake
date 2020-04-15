import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class Board {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  Board(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 0.5,
      game.tileSize * 0.5,
      game.tileSize * 8,
      game.tileSize * 8,
    );

    sprite = Sprite('board.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
