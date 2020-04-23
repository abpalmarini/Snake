import 'package:snakeai/directions.dart';
import 'package:snakeai/snake_game.dart';
import 'package:snakeai/components/game/body.dart';
import 'dart:ui';

/*----------------------
    RECORD = 67 apples
  ----------------------*/

/* 
Similar to SimpleAI, except it now checks for a body part one grid ahead to see
if it is empty and if not it will move in an orthogonal direction.

When choosing to go an orthogonal direction, it checks to go to the side that 
is furthest away from the previous apple loaction first as the surrounding area
has a higher probability of being empty.

Also added an inEscape property where when it has to make a move off course to 
survive it will then enter escape mode and it will keep going in that diretion 
as far as possible (until it has to move again due to a body or border) to 
create maximum distance before leaving escape mode and going back to normal.
*/
class BetterAI {
	//directions in radians rounded to nearest int
	static const int up = -2;
	static const int right = 0;
	static const int down = 2;
	static const int left = 3;

  final SnakeGame game;
  int borderLeftTop;
  int borderRightBottom;
	bool inEscape = false;
	int previousApple;

	BetterAI(this.game) {
		borderLeftTop = (game.gridSize * 3).round();
		borderRightBottom = (game.gridSize * 32).round();
  }

	void move(){
		Offset toTarget = game.head.targetLocation - game.head.previousTarget ;
		int direction = toTarget.direction.round();
    int snakeX = game.head.targetLocation.dx.round();
    int snakeY = game.head.targetLocation.dy.round();
    int appleX = game.apple.rect.left.round();
    int appleY = game.apple.rect.top.round();

		if(inEscape){
			switch(direction){
				case up:
					if(clearFromBodyParts(up) && clearFromBorder(up)){
						game.direction = Directions.UP;
						return;
					}
					break;
				case down:
					if(clearFromBodyParts(down) && clearFromBorder(down)){
						game.direction = Directions.DOWN;
						return;
					}
					break;
				case right:
					if(clearFromBodyParts(right) && clearFromBorder(right)){
						game.direction = Directions.RIGHT;
						return;
					}
					break;
				case left:
					if(clearFromBodyParts(left) && clearFromBorder(left)){
						game.direction = Directions.LEFT;
						return;
					}
					break;
			}	
			inEscape = false;
		}

		if (snakeY > appleY) {
			snakeBelowApple();
			return;
    } 

		if (snakeY < appleY) {
			snakeAboveApple();
			return;
    } 

		if (snakeX > appleX) {
			snakeRightOfApple();
			return;
    } 

		if (snakeX < appleX) {
			snakeLeftOfApple();
			return;
    }

	}

	void snakeLeftOfApple(){
			//checking for correct move first
			if(clearFromBodyParts(right) && clearFromBorder(right)){
				game.direction = Directions.RIGHT;
				return;
			}
			//checking to look up or down first
			if(whichYOrthogonalToTake() == up){
				//checking up first
			  if(clearFromBodyParts(up) && clearFromBorder(up)){
				game.direction = Directions.UP;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(down) && clearFromBorder(down)){
				game.direction = Directions.DOWN;
				inEscape = true;
				return;
			  }
			} else {
				//checking down first
			  if(clearFromBodyParts(down) && clearFromBorder(down)){
				game.direction = Directions.DOWN;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(up) && clearFromBorder(up)){
				game.direction = Directions.UP;
				inEscape = true;
				return;
			  }
			}
	}

	void snakeRightOfApple(){
			//checking for correct move first
			if(clearFromBodyParts(left) && clearFromBorder(left)){
				game.direction = Directions.LEFT;
				return;
			}
			//checking to look up or down first
			if(whichYOrthogonalToTake() == up){
				//checking up first
			  if(clearFromBodyParts(up) && clearFromBorder(up)){
				game.direction = Directions.UP;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(down) && clearFromBorder(down)){
				game.direction = Directions.DOWN;
				inEscape = true;
				return;
			  }
			} else {
				//checking down first
			  if(clearFromBodyParts(down) && clearFromBorder(down)){
				game.direction = Directions.DOWN;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(up) && clearFromBorder(up)){
				game.direction = Directions.UP;
				inEscape = true;
				return;
			  }
			}
	}

	void snakeAboveApple(){
			//checking for correct move first
			if(clearFromBodyParts(down) && clearFromBorder(down)){
				game.direction = Directions.DOWN;
				return;
			}
			//checking to look left or right first
			if(whichXOrthogonalToTake() == right){
				//checking right first
			  if(clearFromBodyParts(right) && clearFromBorder(right)){
				game.direction = Directions.RIGHT;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(left) && clearFromBorder(left)){
				game.direction = Directions.LEFT;
				inEscape = true;
				return;
			  }
			} else {
				//checking left first
			  if(clearFromBodyParts(left) && clearFromBorder(left)){
				game.direction = Directions.LEFT;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(right) && clearFromBorder(right)){
				game.direction = Directions.RIGHT;
				inEscape = true;
				return;
			  }
			}
	}

	void snakeBelowApple(){
			//checking for correct move first
			if(clearFromBodyParts(up) && clearFromBorder(up)){
				game.direction = Directions.UP;
				return;
			}
			//checking to look left or right first
			if(whichXOrthogonalToTake() == right){
				//chekcing right first
			  if(clearFromBodyParts(right) && clearFromBorder(right)){
				game.direction = Directions.RIGHT;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(left) && clearFromBorder(left)){
				game.direction = Directions.LEFT;
				inEscape = true;
				return;
			  }
			} else {
				//checking left first
			  if(clearFromBodyParts(left) && clearFromBorder(left)){
				game.direction = Directions.LEFT;
				inEscape = true;
				return;
			  } else if(clearFromBodyParts(right) && clearFromBorder(right)){
				game.direction = Directions.RIGHT;
				inEscape = true;
				return;
			  }
			}
	}

	int whichXOrthogonalToTake(){
		previousApple = game.previousApple.rect.left.round();
    int snakeX = game.head.targetLocation.dx.round();

		if((snakeX - previousApple) < 0){
		// means previous apple was to the right of
		// the snake so it should check to go left first
			return left;
		} else {
			return right;
		}
	}

	int whichYOrthogonalToTake(){
		previousApple = game.previousApple.rect.top.round();
    int snakeY = game.head.targetLocation.dy.round();

		if((snakeY - previousApple) < 0){
		// means previous apple was below the snake 
		// so it should check to go up first
			return up;
		} else {
			return down;
		}
	}

	bool clearFromBodyParts(int direction){
    double snakeX = game.head.targetLocation.dx;
    double snakeY = game.head.targetLocation.dy;
		bool clear = true;

		switch (direction) {
		case up:
			clear = loopBodyParts(snakeX.round(), (snakeY - game.gridSize).round());
			break;
		case right:
			clear = loopBodyParts((snakeX + game.gridSize).round(), snakeY.round());
			break;
		case down:
			clear = loopBodyParts(snakeX.round(), (snakeY + game.gridSize).round());
			break;
		case left:
			clear = loopBodyParts((snakeX - game.gridSize).round(), snakeY.round());
			break;
		}

		return clear;
	}

	bool loopBodyParts(int snakeX, int snakeY){
		for(Body body in game.bodyParts){
			int bodyX = body.targetLocation.dx.round();
			int bodyY = body.targetLocation.dy.round();
			if(snakeX == bodyX && snakeY == bodyY){
				
				return false;
			}
		}
		return true;
	}

	bool clearFromBorder(int direction){
    double snakeX = game.head.targetLocation.dx;
    double snakeY = game.head.targetLocation.dy;
		bool clear = true;

		switch (direction) {
		case up:
			clear = (snakeY - (game.gridSize)).round() != borderLeftTop;
			break;
		case right:
			clear = (snakeX + game.gridSize).round() != borderRightBottom;
			break;
		case down:
			clear = (snakeY + game.gridSize).round() != borderRightBottom;
			break;
		case left:
			clear = (snakeX - game.gridSize).round() != borderLeftTop;
			break;
		}
		return clear;
	}

  void update(double timeDelta) {
		move();
	}
	
}
