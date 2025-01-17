import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class AIButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  AIButton(this.game) {
    rect = Rect.fromLTWH(
      7,
      game.screenSize.height - game.tileSize - 7, 
      game.tileSize,
      game.tileSize,
    );
    sprite = Sprite('bot.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
