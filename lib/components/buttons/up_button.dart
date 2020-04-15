import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';
import 'package:snakeai/directions.dart';

class UpButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;
  bool tapped = false;
  int frameCount = 0;

  UpButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 4,
      (game.screenSize.height * 0.75) - (game.tileSize * 1.5),
      game.tileSize * 1,
      game.tileSize * 2,
    );
    sprite = Sprite('up.png');
  }

  void render(Canvas canvas) {
    if (!tapped) {
      sprite.renderRect(canvas, rect);
    } else {
      sprite.renderRect(canvas, rect);
      frameCount++;
      if (frameCount == 8) {
        sprite = Sprite('up.png');
        frameCount = 0;
        tapped = false;
      }
    }
  }

  void onTapDown() {
    tapped = true;
    sprite = Sprite('up_.png');
    if (game.direction != Directions.DOWN) {
      game.direction = Directions.UP;
    }
  }
}
