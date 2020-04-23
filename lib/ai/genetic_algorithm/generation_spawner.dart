import 'dart:math';
import 'individual_snake.dart';
import 'neuron.dart';
import 'package:snakeai/snake_game.dart';

class GenerationSpawner{
  final SnakeGame game;
  Random random = Random();

  IndividualSnake snake1;
  IndividualSnake snake2;
  List<List<double>> babyHiddenWeights = [];
  List<List<double>> babyOutputWeights = [];
  List<IndividualSnake> newGeneration = [];

  GenerationSpawner(this.game);

  void findTopSnakes(){
    game.generation.sort((a,b) => a.score.compareTo(b.score)); 
    snake1 = game.generation[game.generation.length - 1];
    snake2 = game.generation[game.generation.length - 2];
  }

  
  void breedTopSnakes(){ 
    //hiddenWeights
    int amountH = (snake1.hiddenWeights.length / 3).round() * 2; // 2 thirds top snake
    for(int i = 0; i < amountH; i++){
      babyHiddenWeights.add(snake1.hiddenWeights[i]);
    }
    for(int i = amountH; i < snake2.hiddenWeights.length; i++){
      babyHiddenWeights.add(snake2.hiddenWeights[i]);
    }
    
    //outputWeights
    int amountO = (snake1.outputWeights.length / 2).round();
    for(int i = 0; i < amountO; i++){
      babyOutputWeights.add(snake1.outputWeights[i]);
    }
    for(int i = amountO; i < snake2.outputWeights.length; i++){
      babyOutputWeights.add(snake2.outputWeights[i]);
    }
  }

  List<List<double>> mutateWeights(List<List<double>> weights){
    List<List<double>> mutatedWeights = []; 
    mutatedWeights.addAll(weights);
    for(int i = 0; i < mutatedWeights.length; i++){
      for(int j = 0; j < mutatedWeights[i].length; j++){
        double r = random.nextDouble();
        if(r <= 0.2){ // 20% chance of mutation                     
          double mutation  = (random.nextDouble() * 2) - 1;
          mutatedWeights[i][j] = mutation;
        }
      }
    }
    return mutatedWeights;
  }

  void createNewGeneration(){
    for(int i = 0; i < game.generationSize; i++){
      List<List<double>> mhlw = mutateWeights(babyHiddenWeights);
      List<List<double>> molw = mutateWeights(babyOutputWeights);
      newGeneration.add(IndividualSnake(game, false, hlw: mhlw, olw: molw));
    }
  }
  
  void spawnNewGeneration(){
    babyHiddenWeights.clear();
    babyOutputWeights.clear();
    newGeneration.clear();

    findTopSnakes();
    breedTopSnakes();
    createNewGeneration();
    game.generation.clear();
    game.generation.addAll(newGeneration);
  }
}
