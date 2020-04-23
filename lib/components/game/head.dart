import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:snakeai/screens.dart';
import 'package:snakeai/snake_game.dart';
import 'package:snakeai/directions.dart';
import 'dart:math';

class Head {
  final SnakeGame game;
  Rect rect;
  Sprite sprite;
  Offset targetLocation;
  Offset previousTarget;

  Head(this.game) {
    rect = Rect.fromLTWH(
      game.gridSize * 16, //half way across the board
      game.gridSize * 16, //half way across the board
      game.gridSize,
      game.gridSize,
    );
    sprite = Sprite('head_up.png');
    previousTarget = Offset(rect.left, rect.top);
    setTargetLocation();
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect.inflate(3));
  }

  void update(double timeDelta) {
    double singleFrameDistance = game.speed * timeDelta;
    Offset toTarget = targetLocation - Offset(rect.left, rect.top);

    if (singleFrameDistance < toTarget.distance) {
      Offset singleFrameShift =
          Offset.fromDirection(toTarget.direction, singleFrameDistance);
      rect = rect.shift(singleFrameShift);
    } else {
      rect = rect.shift(toTarget);
      previousTarget = targetLocation;
      setTargetLocation();
      if(game.geneticActivated){
        game.generation[game.currentSnake].update(timeDelta); //@Genetic
      }
    }

    checkIfDead();
  }

  void runGeneticAlgorithm(){ //@Genetic
    game.generation[game.currentSnake].printDetails(); 
    if(game.currentSnake == (game.generationSize - 1)){
      //run new generation spawner
      game.currentSnake = 0;
      game.currentGeneration++;
      game.generationSpawner.spawnNewGeneration();
      game.startGame();
      } else {
      game.currentSnake++;
      game.startGame();   
    }
  }

  void checkIfDead() {
    //boundaries
    if (targetLocation.dx.round() == (game.gridSize * 3).round() ||
        targetLocation.dx.round() == (game.gridSize * 32).round() ||
        targetLocation.dy.round() == (game.gridSize * 3).round() ||
        targetLocation.dy.round() == (game.gridSize * 32).round()) {
      setHighScore();
      if(game.geneticActivated){ //@Genetic
        runGeneticAlgorithm();
      } else {               
       game.currentScreen = Screens.gameOver;
       game.aiActivated = false;
      }
    }

    //collision
    if (game.occupiedCoordinates.contains(
        Point(targetLocation.dx.round(), targetLocation.dy.round()))) {
      setHighScore();
      if(game.geneticActivated){ //@Genetic
        runGeneticAlgorithm();
      } else {
       game.currentScreen = Screens.gameOver;
       game.aiActivated = false;
      }
    }
  }

  void setHighScore() {
    if (game.score > (game.storage.getInt('highScore') ?? 0)) {
      game.storage.setInt('highScore', game.score);
    }
  }

  void setTargetLocation() {
    switch (game.direction) {
      case Directions.UP:
        targetLocation =
            Offset(rect.left, rect.top) + Offset(0, -game.gridSize);
        sprite = Sprite('head_up.png');
        break;
      case Directions.RIGHT:
        targetLocation = Offset(rect.left, rect.top) + Offset(game.gridSize, 0);
        sprite = Sprite('head_right.png');
        break;
      case Directions.DOWN:
        targetLocation = Offset(rect.left, rect.top) + Offset(0, game.gridSize);
        sprite = Sprite('head_down.png');
        break;
      case Directions.LEFT:
        targetLocation =
            Offset(rect.left, rect.top) + Offset(-game.gridSize, 0);
        sprite = Sprite('head_left.png');
        break;
    }
  }
}
