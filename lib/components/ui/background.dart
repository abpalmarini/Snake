import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class Background {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  //Background image is 1125 x 2436
  //1125 / 9 = 125 pixels per tile
  //2436 / 125 = 19.488 tiles vertically
  Background(this.game) {
    rect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 19.488),
      game.screenSize.width,
      game.tileSize * 19.488,
    );
    sprite = Sprite('background.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
