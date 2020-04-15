import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';
import 'package:snakeai/directions.dart';

class RightButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;
  bool tapped = false;
  int frameCount = 0;

  RightButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 5,
      (game.screenSize.height * 0.75) + game.tileSize * 0.5,
      game.tileSize * 2,
      game.tileSize * 1,
    );
    sprite = Sprite('right.png');
  }

  void render(Canvas canvas) {
    if (!tapped) {
      sprite.renderRect(canvas, rect);
    } else {
      sprite.renderRect(canvas, rect);
      frameCount++;
      if (frameCount == 8) {
        sprite = Sprite('right.png');
        frameCount = 0;
        tapped = false;
      }
    }
  }

  void onTapDown() {
    tapped = true;
    sprite = Sprite('right_.png');
    if (game.direction != Directions.LEFT) {
      game.direction = Directions.RIGHT;
    }
  }
}
