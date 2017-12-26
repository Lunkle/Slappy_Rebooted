import processing.sound.*;

/*
    Allspeeds are in pixels/second units  unless otherwise specified
*/
int canvasWidth = 800;
int canvasHeight = 600;
final int ARENA_WIDTH = parseInt(TileData.TILE_SIZE * TileData.NUM_X_TILES);
final int ARENA_HEIGHT = parseInt(TileData.TILE_SIZE * TileData.NUM_Y_TILES);
TileData tileData = new TileData();

HighScore[] highScoresList;
HighScore currentScore;
CharacterData characterData;

//The window class is where the window is relative to the elements on the screen
Window window;
//Main character is you!
GameCharacter mainCharacter;

void setup() {
    //Loading the high scores.
    loadHighScores();
    //Creating the canvas.
    surface.setSize(canvasWidth, canvasHeight);
    //Custom cursor utilised, so do not show original cursor.
    noCursor();
    //Set frame rate
    frameRate(200);
    //Initialized window object.
    window = new Window((ARENA_WIDTH - canvasWidth)/2, (ARENA_HEIGHT - canvasHeight)/2, canvasWidth, canvasHeight);
    //Initialized enemy data.
    characterData = new CharacterData();
    //Initialized character object, set him in middle.
    mainCharacter = new MainCharacter(ARENA_WIDTH/2, ARENA_HEIGHT/2);
    //Enemy testEnemy = new Enemy(ARENA_WIDTH/2 + 200, ARENA_HEIGHT/2 + 200, 80, 0.5, 4, 2000);
    characterData.addEnemies(EnemyTypes.BIG_TANKY_MEATY_BOI, 10, ARENA_WIDTH/2 + 200, ARENA_HEIGHT/2 + 200);
    characterData.addEnemies(EnemyTypes.DA_BIG_BOSS, 1, ARENA_WIDTH/2 - 200, ARENA_HEIGHT/2 - 200);
    characterData.addEnemies(EnemyTypes.BASIC_WANDER, 100, ARENA_WIDTH/2 + 200, ARENA_HEIGHT/2 + 200);
    //Set all tiles to a certain base tile type. Change this later if needed.
    tileData.setAllTo(TileTypes.GRASS);
    //This tile is just here for a reference point for character movement. Remove if needed.
    tileData.addTileToGrid(new Tile(TileTypes.GRASS, 10, 10));
    for(int i = 0; i < TileData.NUM_X_TILES; i++){
        for(int j = i%2; j < TileData.NUM_Y_TILES; j+=2){
            tileData.addTileToGrid(new Tile(TileTypes.MOSS, i, j));
        }
        
    }
}

SoundFile smallImpact = new SoundFile(this, "C:/Users/Donnel/Desktop/Actually Good Programming/Slappy_Rebooted/data/Sharp Punch-SoundBible.com-1947392621.mp3");

//This is used to get all the highscores into the highScoresList array.
void loadHighScores() {
    String[] highScoresRaw = loadStrings("High Scores.txt");
    highScoresList = new HighScore[highScoresRaw.length];
    for (int i = 0; i < highScoresRaw.length; i ++) {
        highScoresList[i] = new HighScore(highScoresRaw[i]);
    }
    currentScore = new HighScore("Donny Ren, 0");
}

void draw() {
    //characterData.addEnemies(EnemyTypes.BASIC_WANDER, 1, ARENA_WIDTH/2 + 200, ARENA_HEIGHT/2 + 200);
    keyRespond();
    
    background(52, 204, 255);

    pushMatrix();
    
    translate(-window.position.x, -window.position.y);
    tileData.displayTiles(window.position.x, window.position.y, window.screenWidth, window.screenHeight);
    mainCharacter.updateCharacter();
    mainCharacter.displayCharacter();
    window.fixScreenTo(mainCharacter.xPos, mainCharacter.yPos);
    for (int i = 0; i < characterData.characters.length; i++) {
        characterData.characters[i].updateCharacter();
        characterData.characters[i].displayCharacter();
        if(((MainCharacter)mainCharacter).weapon.checkHitEnemy(characterData.characters[i]) == true){
            //println("HITTTTTTTTTTTTTTTTTTT");
            characterData.characters[i].currentHealth -= 10;
        }
        if(characterData.characters[i] instanceof Enemy){
            ((Enemy)characterData.characters[i]).removeIfDead();
        }
    }
    popMatrix();
    fill(0);
    textSize(20);
    text(currentScore.score, 10, 25);
    drawCursor(mouseX, mouseY);
}

boolean wPressed, aPressed, sPressed, dPressed;
void keyPressed() {
    switch(key) {
    case 'w':
        wPressed = true;
        break;
    case 'a':
        aPressed = true;
        break;
    case 's':
        sPressed = true;
        break;
    case 'd':
        dPressed = true;
        break;
    }
}

void keyRespond() {
    float verticalValue = 0;
    float horizontalValue = 0;
    if (wPressed) {
        verticalValue -= 1;
    }
    if (aPressed) {
        horizontalValue -= 1;
    }
    if (sPressed) {
        verticalValue += 1;
    }
    if (dPressed) {
        horizontalValue += 1;
    }
    mainCharacter.move(new PVector(horizontalValue, verticalValue), mainCharacter.speed);
}

//When keys are released set status to false.
void keyReleased() {
    switch(key) {
    case 'w':
        wPressed = false;
        break;
    case 'a':
        aPressed = false;
        break;
    case 's':
        sPressed = false;
        break;
    case 'd':
        dPressed = false;
        break;
    }
}

//WOOHOO custom cursor I'm cool
void drawCursor(float x, float y) {
    //Push matrix translate to x, y.
    pushMatrix();
    translate(x, y);
    //Set colours.
    fill(255);
    stroke(0);
    rect(-10, -10, 8, 3);
    rect(-10, -10, 3, 8);
    rect(10, -10, -8, 3);
    rect(10, -10, -3, 8);
    rect(-10, 10, 8, -3);
    rect(-10, 10, 3, -8);
    rect(10, 10, -8, -3);
    rect(10, 10, -3, -8);
    ellipse(0, 0, 4, 4);
    //These lines are to cover up the overlap outlines.
    stroke(255);
    line(-7, -9, -7, -8);
    line(7, -9, 7, -8);
    line(-7, 9, -7, 8);
    line(7, 9, 7, 8);
    //No stroke again.
    noStroke();
    //Return to normal matrix.
    popMatrix();
}