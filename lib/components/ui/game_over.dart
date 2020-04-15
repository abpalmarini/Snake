import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class GameOverTitle {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  GameOverTitle(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 1,
      game.tileSize * 1,
      game.tileSize * 7,
      game.tileSize * 2,
    );
    sprite = Sprite('game_over.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
