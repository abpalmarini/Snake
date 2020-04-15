import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';
import 'package:snakeai/directions.dart';

class LeftButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;
  bool tapped = false;
  int frameCount = 0;

  LeftButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 2,
      (game.screenSize.height * 0.75) + game.tileSize * 0.5,
      game.tileSize * 2,
      game.tileSize * 1,
    );
    sprite = Sprite('left.png');
  }

  void render(Canvas canvas) {
    if (!tapped) {
      sprite.renderRect(canvas, rect);
    } else {
      sprite.renderRect(canvas, rect);
      frameCount++;
      if (frameCount == 8) {
        sprite = Sprite('left.png');
        frameCount = 0;
        tapped = false;
      }
    }
  }

  void onTapDown() {
    tapped = true;
    sprite = Sprite('left_.png');
    if (game.direction != Directions.RIGHT) {
      game.direction = Directions.LEFT;
    }
  }
}
