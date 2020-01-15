import java.util.*;

//x and y together capture the coordinates (squares really) of the snake as it
//has squares added to the front (when it advances) and removed from the rear 
//when it does not hit the apple).
ArrayList<Integer> x = new ArrayList <Integer>();
ArrayList<Integer> y = new ArrayList <Integer>();

//Note that height and width are variables provided by the Processing environment
//so we don't want to override them in our code, hence w and h for variable names.
int w = 30;              //Width of the board
int h = 30;              //Height of the board
int bs = 20;             //block size
/* dx and dy are direction vectors.  The dir variable indexs into dx and dy
 to control the direction the snake takes for the next advance. A value of 0
 for dir means that dx is 0 and dy is 1, which sends the snake south.  1 sends
 the snake north, 2 sends it east and 3 sends it west.  Remember that the 
 coordinates increase as we move away from origin in the upper left corner of the 
 screen.*/
int [] dx = {0, 0, 1, -1};
int [] dy = {1, -1, 0, 0};
int dir = 2;             //The next direction to take
//Coordinates of the apple.  The snake gets longer each time it "eats" the apple.
int applex = 12;
int appley = 10;
boolean gameover = false;      //flag to show whether game is done or not.
int [] colors = {#266C1B, #E89E25, #2D3FDE, #C10A35, #EBF018};
final int initialFrameRate = 30;

// ********* ADJUSTMENT for task 2 *********
//Draw the mine
//Create 2 ArrayList of x and y coordinates of the mine
ArrayList<Integer> minex = new ArrayList <Integer>();
ArrayList<Integer> miney = new ArrayList <Integer>();
int randomMineX; //Easier to check duplicated
int randomMineY;

int tempAppleX; //Easier to check duplicated
int tempAppleY;

boolean appleEaten = false;
// ********* END OF ADJUSTMENT *********

// ********* ADJUSTMENT for task 4 *********
ArrayList<Integer> deathX = new ArrayList<Integer>();
ArrayList<Integer> deathY = new ArrayList<Integer>();

int tempDir = 5;
int randomDir;
// ********* END OF ADJUSTMENT *********

void setup () {
  //600 = width * bs and height * bs.  If you change any of those three variables,
  //be sure to change the arguments to the size function accordingly.
  size (600, 600);            //size will only take literals, not variables
  x.add(5);              //Just a random starting position for the snake
  y.add(5);

  // ********* ADJUSTMENT for task 4 *********
  deathX.add(20);
  deathY.add(20);
  // ********* END OF ADJUSTMENT *********

  frameRate (initialFrameRate);              //start slow to make the game easier.
}
void draw () {
  background(255);            //make the background white
  //Create a grid pattern on the screen with vertical and horizontal lines
  for (int i = 0; i < width; i++) {
    line (i*bs, 0, i*bs, height);
  }
  for (int i = 0; i < height; i++) {
    line (0, i * bs, width, i * bs);
  }
  for (int i = 0; i < x.size(); i++) {      //draw the snake
    //    fill(0, 255, 0);
    fill(colors[i % colors.length]);
    rect(x.get(i)*bs, y.get(i)*bs, bs, bs);

    // ********* ADJUSTMENT for task 4 *********
    //Draw the death snake since they will have the same size
    fill(204, 204, 204);
    rect(deathX.get(i)*bs, deathY.get(i)*bs, bs, bs);
  }
  if (!gameover) {
    //draw the apple
    fill(255, 0, 0);
    rect(applex * bs, appley * bs, bs, bs);

    // ********* ADJUSTMENT for task 2 *********
    // Draw the mine if there's an apple get eaten
    if (appleEaten) {
      for (int i  = 0; i < minex.size(); i++) {
        fill(0, 0, 0);
        rect(minex.get(i) * bs, miney.get(i) *bs, bs, bs);
      }
    }
    // ********* END OF ADJUSTMENT *********
  }
  if (!gameover) {
    if (frameCount % 5 == 0) {
      x.add(0, x.get(0) + dx[dir]);
      y.add(0, y.get(0) + dy[dir]);

      // ********* ADJUSTMENT for task 4 *********
     
      if (tempDir != dir) {
        randomDir = (int) random(0, 4);
        tempDir = dir;
      }
      deathX.add(0, deathX.get(0) + dx[randomDir]);
      deathY.add(0, deathY.get(0) + dy[randomDir]);
      // ********* END OF ADJUSTMENT *********

      //Make sure that we do not run off the edge of the board
      if (x.get(0) < 0 || y.get(0) < 0 || x.get(0) >= w || y.get(0) >= h) {
        gameover = true;
      }
      
      // ********* ADJUSTMENT for task 4 *********
      //Test if the death snake reaches the edge of the board
      while (deathX.get(0) < 0 || deathY.get(0) < 0 || deathX.get(0) >= w || deathY.get(0) >= h) {
        randomDir = randomDir == 0 ? 1 : (randomDir == 1 ? 0 : (randomDir == 2 ? 3 : (randomDir == 3 ? 2 : -1)));
        
        //trim off the head since it is reversing
        deathX.remove(0);
        deathY.remove(0);
        
        //add to the head when it reverses the direction
        deathX.add(0, deathX.get(0) + dx[randomDir]);
        deathY.add(0, deathY.get(0) + dy[randomDir]);
      }
      
      //Test if the death snake hits the apple, if yes, reverse direction
      if ((deathX.get(0) == applex) && (deathY.get(0) == appley)) {
        randomDir = randomDir == 0 ? 1 : (randomDir == 1 ? 0 : (randomDir == 2 ? 3 : (randomDir == 3 ? 2 : -1)));
      }
      
      //Test if the death snake hits one of the mines, if yes, reverse direction
      for (int i = 0; i < minex.size(); i++) {
        if ((deathX.get(0) == minex.get(i)) && (deathY.get(0) == miney.get(i))) {
        randomDir = randomDir == 0 ? 1 : (randomDir == 1 ? 0 : (randomDir == 2 ? 3 : (randomDir == 3 ? 2 : -1)));
        }
      }
      // ********* END OF ADJUSTMENT *********
      
      //See if we've hit the apple
      if (x.get(0) == applex && y.get(0) == appley) {

        // ********* ADJUSTMENT for task 2 *********
        //Creating a new apple that is not colliding with any mines
        boolean appleDuplicated;
        do {
          tempAppleX = (int) random(0, w);    // Make temp variables to check if it collides with the mines  
          tempAppleY = (int) random(0, h);
          appleDuplicated = false;

          for (int i = 0; i < minex.size(); i++) {
            if ((tempAppleX == minex.get(i)) && (tempAppleY == miney.get(i)))
              appleDuplicated = true;
          }
        } while (appleDuplicated);

        applex = tempAppleX; // If tempApple is not colliding, record it to the actual apple
        appley = tempAppleY;
        // ********* END OF ADJUSTMENT *********

        frameRate(frameRate + frameRate / 10);

        // ********* ADJUSTMENT for task 2 *********
        appleEaten = true;
        boolean mineDuplicated = false;
        do {
          //Set the temp new mine variable to random
          randomMineX = (int) random(0, w);
          randomMineY = (int) random(0, h);
          mineDuplicated = false;

          for (int i = 0; i < minex.size(); i++) {
            if (((randomMineX == minex.get(i)) && (randomMineY == miney.get(i)))) { //Check to see if the temp new mine is duplicated 
              mineDuplicated = true; //If yes then go back to the loop and randomize again
            }
          }

          if ((randomMineX == applex) && (randomMineY == appley)) //Check if the temp new mine collides with the apple
            mineDuplicated = true;
        } while (mineDuplicated);

        minex.add(randomMineX);      
        miney.add(randomMineY);

        // ********* END OF ADJUSTMENT *********
      } else {                      //Trim off the last element in the snake
        x.remove(x.size() - 1);
        y.remove(y.size() - 1);

        // ********* ADJUSTMENT for task 4 *********
        deathX.remove(deathX.size() - 1);
        deathY.remove(deathY.size() - 1);
        // ********* END OF ADJUSTMENT *********
      }

      // ********* ADJUSTMENT for task 1 *********
      //See if the snakes collide by itself
      if (x.size() > 4) { //Snake's length must be larger than 4 to collide by itself
        for (int i = 1; i < x.size(); i++) {
          if ((x.get(0) == x.get(i)) && (y.get(0) == y.get(i))) {
            gameover = true;
          }
        }
      }
      // ********* END OF ADJUSTMENT *********

      // ********* ADJUSTMENT for task 2 *********
      //See if the snake hit the mine
      for (int i = 0; i < minex.size(); i++) {
        if ((x.get(0) == minex.get(i)) && (y.get(0) == miney.get(i)))
          gameover = true;
      }
      // ********* END OF ADJUSTMENT *********
      
      // ********* ADJUSTMENT for task 4 *********
      //Check if the snake crossed the death snake
      for (int i = 0; i < x.size(); i++) {
        for (int j = 0; j < x.size(); j++) {
          if ((x.get(i) == deathX.get(j)) && (y.get(i) == deathY.get(j)))
            gameover = true;
        }
      }
    }
  } else if (gameover) {
    fill (0);
    textSize(30);
    textAlign(CENTER);
    text("GAME OVER. Press space bar to resume.", width/2, height/2);
    if (keyPressed && key == ' ') {      //user wants to resume
      frameRate(initialFrameRate);      //start over with the speed of the game
      x.clear();
      y.clear();
      x.add(5);
      y.add(5);

      // ********* ADJUSTMENT for task 4 *********
      deathX.clear();
      deathY.clear();
      deathX.add(20);
      deathY.add(20);
      // ********* END OF ADJUSTMENT *********

      // ********* ADJUSTMENT for task 2 *********
      minex.clear();
      miney.clear();
      // ********* END OF ADJUSTMENT *********

      gameover = false;
    }
  }
}
void keyPressed () {
  /*
  The "a" key starts the snake going left, "d" sends it right, "w" sends it up 
   and "s" sends it down.  The way to remember which is which is by their position
   on the qwerty keyboard.
   
   The dir variable is the index into the dx and dy vectors that we use when we add
   a new set of x,y coordinates to the front of the arraylist of points that represents
   our snake.
   */
  println("Key pressed is: " + key);
  int newdir;
  // ********* ADJUSTMENT for task 2 *********
  if (key == CODED) 
    newdir = keyCode == DOWN ? 0 : (keyCode == UP ? 1 : (keyCode == RIGHT ? 2 : (keyCode == LEFT ? 3 : -1))); // and use newdir to dictate where the snake goes
  // ********* END OF ADJUSTMENT *********
  else
    newdir = key == 's' ? 0 : (key == 'w' ? 1 : (key == 'd' ? 2 : (key == 'a' ? 3 : -1)));

  // ********* ADJUSTMENT for task 1 *********
  if (newdir != -1) {
    if (x.size() == 1) //Snake can reverse the direction when size = 1
      dir = newdir; 

    else {
      if (dir == 3 && newdir != 2 || dir == 2 && newdir != 3 || //Prevent snake from reversing itself when size > 1
        dir == 1 && newdir != 0 || dir == 0 && newdir != 1)
        dir = newdir;
      else
        gameover = true;
    }
  }
  // ********* END OF ADJUSTMENT *********
}
