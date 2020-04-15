import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class PlayButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  PlayButton(this.game) {
    rect = Rect.fromLTWH(
      (game.screenSize.width / 2) - game.tileSize * 1.5,
      game.tileSize * 3,
      game.tileSize * 3,
      game.tileSize * 3,
    );
    sprite = Sprite('play.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
