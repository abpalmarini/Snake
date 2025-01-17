import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:snakeai/components/ui/high_score_display.dart';
import 'screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
//components
import 'components/ui/background.dart';
import 'components/ui/board.dart';
import 'components/ui/play_button.dart';
import 'components/ui/game_over.dart';
import 'components/ui/score_display.dart';
import 'components/buttons/left_button.dart';
import 'components/buttons/right_button.dart';
import 'components/buttons/up_button.dart';
import 'components/buttons/down_button.dart';
import 'components/game/head.dart';
import 'components/game/body.dart';
import 'components/game/apple.dart';
//logic
import 'directions.dart';
import 'dart:math';
//ai
import 'ai/ai_button.dart';
import 'ai/simple_ai.dart';
import 'ai/better_ai.dart';
import 'ai/genetic_algorithm/individual_snake.dart';
import 'ai/genetic_algorithm/generation_spawner.dart';
import 'ai/genetic_algorithm/genetic_info_display.dart';
import 'ai/genetic_algorithm/genetic_button.dart';

class SnakeGame extends Game {
  final SharedPreferences storage;
  //screen
  final Size initialDimensions;
  Size screenSize;
  double tileSize;
  double gridSize;
  Screens currentScreen;

  //components - ui
  Background background;
  PlayButton playButton;
  Board board;
  LeftButton leftButton;
  RightButton rightButton;
  UpButton upButton;
  DownButton downButton;
  GameOverTitle gameOverTitle;
  ScoreDisplay scoreDisplay;
  HighScoreDisplay highScoreDisplay;

  //components - game
  Head head;
  List<Body> bodyParts = [];
  Apple apple;

  //logic
  Directions direction;
  double speed;
  Random random = Random();
  List<Point> allCoordinates = [];
  List<Point> occupiedCoordinates = [];
  List<Point> emptyCoordinates = [];
  int score;

  //AI
  bool aiActivated = false;
  bool geneticActivated = false;
  Apple previousApple;
  AIButton aiButton;
  SimpleAI simpleAI;
  BetterAI betterAI;
  GeneticInfoDisplay geneticInfoDisplay;
  GeneticButton geneticButton;
  GenerationSpawner generationSpawner;
  final int generationSize = 100;
  List<IndividualSnake> generation = [];
  int currentSnake = 0;
  int currentGeneration = 1;

  SnakeGame(this.initialDimensions, this.storage) {
    resize(initialDimensions);
    setAllCoordinates();
    currentScreen = Screens.home;
    speed = gridSize * 8;
    background = Background(this);
    playButton = PlayButton(this);
    gameOverTitle = GameOverTitle(this);
    leftButton = LeftButton(this);
    rightButton = RightButton(this);
    upButton = UpButton(this);
    downButton = DownButton(this);

    //AI
    aiButton = AIButton(this);
    simpleAI = SimpleAI(this);
    betterAI = BetterAI(this);
    geneticInfoDisplay = GeneticInfoDisplay(this);
    geneticButton = GeneticButton(this);
    generationSpawner = GenerationSpawner(this);
    for (int i = 0; i < generationSize; i++) {
      generation.add(IndividualSnake(this, true));
    }
  }

  void startGame() {
    bodyParts.clear();
    direction = Directions.UP;
    emptyCoordinates = allCoordinates.toList();
    score = 0;
    board = Board(this);
    head = Head(this);
    spawnNewApple();
  }

  void setAllCoordinates() {
    for (int i = 4; i < 32; i++) {
      for (int j = 4; j < 32; j++) {
        allCoordinates.add(Point((gridSize * i), (gridSize * j)));
      }
    }
  }

  updateCoordinates() {
    occupiedCoordinates.clear();
    for (Body bodyPart in bodyParts) {
      occupiedCoordinates.add(Point(bodyPart.targetLocation.dx.round(),
          bodyPart.targetLocation.dy.round()));
    }
    emptyCoordinates = allCoordinates.toList();
    emptyCoordinates.removeWhere((item) =>
        occupiedCoordinates.contains(Point(item.x.round(), item.y.round())));
  }

  void checkIfAppleEaten() {
    if (head.targetLocation.dx.round() == apple.rect.left.round() &&
        head.targetLocation.dy.round() == apple.rect.top.round()) {
      score++;
      spawnNewApple();
      spawnBody();
      if (geneticActivated) {
        generation[currentSnake].score += 10; //@Genetics
      }
    }
  }

  void spawnNewApple() {
    int numberOfEmptyCoords = emptyCoordinates.length;
    Point randomCoord = emptyCoordinates[random.nextInt(numberOfEmptyCoords)];

    previousApple = apple;
    apple = Apple(this, randomCoord.x, randomCoord.y);
  }

  void spawnBody() {
    int indexInBodyParts = bodyParts.length;
    double x;
    double y;
    if (bodyParts.length == 0) {
      x = head.previousTarget.dx;
      y = head.previousTarget.dy;
    } else {
      x = bodyParts[indexInBodyParts - 1].previousTarget.dx;
      y = bodyParts[indexInBodyParts - 1].previousTarget.dy;
    }
    bodyParts.add(Body(this, x: x, y: y, indexInBodyParts: indexInBodyParts));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
    gridSize = tileSize / 4;
  }

  void onTapDown(TapDownDetails details) {
    if ((currentScreen == Screens.home || currentScreen == Screens.gameOver) &&
        geneticButton.rect.contains(details.globalPosition)) {
      currentScreen = Screens.playing;
      startGame();
      geneticActivated = true;
      return;
    } else if ((currentScreen == Screens.home ||
            currentScreen == Screens.gameOver) &&
        aiButton.rect.contains(details.globalPosition)) {
      currentScreen = Screens.playing;
      startGame();
      aiActivated = true;
      return;
    } else if ((currentScreen == Screens.home ||
            currentScreen == Screens.gameOver) &&
        playButton.rect.contains(details.globalPosition)) {
      currentScreen = Screens.playing;
      startGame();
      return;
    } else if (currentScreen == Screens.playing) {
      if (leftButton.rect.contains(details.globalPosition)) {
        leftButton.onTapDown();
        return;
      }
      if (rightButton.rect.contains(details.globalPosition)) {
        rightButton.onTapDown();
        return;
      }
      if (upButton.rect.contains(details.globalPosition)) {
        upButton.onTapDown();
        return;
      }
      if (downButton.rect.contains(details.globalPosition)) {
        downButton.onTapDown();
        return;
      }
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);
    if (currentScreen == Screens.home) {
      playButton.render(canvas);
      aiButton.render(canvas);
      geneticButton.render(canvas);
    } else if (currentScreen == Screens.playing) {
      board.render(canvas);
      leftButton.render(canvas);
      rightButton.render(canvas);
      upButton.render(canvas);
      downButton.render(canvas);

      for (Body body in bodyParts) {
        body.render(canvas);
      }
      apple.render(canvas);
      head.render(canvas);
      if (geneticActivated) {
        //@Genetics
        geneticInfoDisplay.render(canvas);
      }
    } else if (currentScreen == Screens.gameOver) {
      playButton.render(canvas);
      gameOverTitle.render(canvas);
      scoreDisplay = ScoreDisplay(this, score);
      scoreDisplay.render(canvas);
      highScoreDisplay =
          HighScoreDisplay(this, storage.getInt('highScore') ?? 0);
      highScoreDisplay.render(canvas);
      aiButton.render(canvas);
      geneticButton.render(canvas);
    }
  }

  void update(double timeDelta) {
    if (currentScreen == Screens.playing) {
      head.update(timeDelta);
      for (Body body in bodyParts) {
        body.update(timeDelta);
      }
      updateCoordinates();
      checkIfAppleEaten();
    }
    if (aiActivated) {
      //simpleAI.update(timeDelta);
      betterAI.update(timeDelta);
    } else if (geneticActivated) {
      geneticInfoDisplay.update(timeDelta);
    }
  }
}
