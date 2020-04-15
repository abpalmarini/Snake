import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:snakeai/snake_game.dart';

class Apple {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;

  Apple(this.game, double x, double y) {
    rect = Rect.fromLTWH(x, y, game.gridSize, game.gridSize);
    sprite = Sprite('apple.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }
}
