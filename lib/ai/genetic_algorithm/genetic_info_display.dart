import 'dart:ui';
import 'package:snakeai/snake_game.dart';
import 'package:flutter/painting.dart';

class GeneticInfoDisplay {
  final SnakeGame game;
  TextPainter currentSnakeDisplay;
  Offset currentSnakeDPos;
  TextPainter generationDisplay;
  Offset generationDPos;
  TextStyle textStyle;

  GeneticInfoDisplay(this.game) {
    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 25,
    );

    currentSnakeDisplay = TextPainter(
      text: TextSpan(text: 'Current Snake: ${game.currentSnake}/${game.generationSize}', style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    currentSnakeDisplay.layout();

    currentSnakeDPos = Offset(
      0,
      game.tileSize * 8.5,
    );

    generationDisplay = TextPainter(
      text: TextSpan(text: 'Generation: ${game.currentGeneration}', style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    generationDisplay.layout();

    generationDPos = Offset(
      0,
      game.tileSize * 9 , 
    );
  }

  void render(Canvas canvas) {
    currentSnakeDisplay.paint(canvas, currentSnakeDPos);
    generationDisplay.paint(canvas, generationDPos);
  }

  void update(double timeDelta){
    currentSnakeDisplay = TextPainter(
      text: TextSpan(text: 'Current Snake: ${game.currentSnake}/${game.generationSize}', style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    currentSnakeDisplay.layout();
    
    generationDisplay = TextPainter(
      text: TextSpan(text: 'Generation: ${game.currentGeneration}', style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    generationDisplay.layout();
  }
}
