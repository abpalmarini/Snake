import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/directions.dart';
import 'package:snakeai/snake_game.dart';

class DownButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;
  bool tapped = false;
  int frameCount = 0;

  DownButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 4,
      (game.screenSize.height * 0.75) + (game.tileSize * 1.5),
      game.tileSize * 1,
      game.tileSize * 2,
    );
    sprite = Sprite('down.png');
  }

  void render(Canvas canvas) {
    if (!tapped) {
      sprite.renderRect(canvas, rect);
    } else {
      sprite.renderRect(canvas, rect);
      frameCount++;
      if (frameCount == 8) {
        sprite = Sprite('down.png');
        frameCount = 0;
        tapped = false;
      }
    }
  }

  void onTapDown() {
    tapped = true;
    sprite = Sprite('down_.png');
    if (game.direction != Directions.UP) {
      game.direction = Directions.DOWN;
    }
  }
}
