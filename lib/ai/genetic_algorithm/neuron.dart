import 'dart:math';

class Neuron { 
  List<int> inputs; 
  List<double> weights;
  double activation;
  int output;


  setInputs(List<int> inputs){
    this.inputs = inputs;
  }
 
  setWeights(List<double> weights){
   this.weights = weights;
  }

  calculateActivation(){
    activation = 0;
    for(int i = 0; i < inputs.length; i++){
      activation += inputs[i] * weights[i];
    }
    activation += -1 * weights[weights.length - 1];
  }

  int getOutput(List<int> inputs){
    setInputs(inputs);
    calculateActivation();
    if(sigmoidFunction(activation) >= 0.5){
      output = 1;
      return 1;
    } else {
      output = 0;
      return 0;
    }
  }

  double getFinalOutput(List<int> inputs){
    setInputs(inputs);
    calculateActivation();
    return sigmoidFunction(activation);
  }

  double sigmoidFunction(double activation){
    return 1 / (1 + pow(e, - activation));  
  }
}
