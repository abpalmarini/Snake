import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/snake_game.dart';

class GeneticButton {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  GeneticButton(this.game) {
    rect = Rect.fromLTWH(
      game.screenSize.width - game.tileSize - 25,
      game.screenSize.height - (game.tileSize * 0.5) - 7 ,
      game.tileSize + 18,
      game.tileSize * 0.5,  
    );
    sprite = Sprite('dna.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
