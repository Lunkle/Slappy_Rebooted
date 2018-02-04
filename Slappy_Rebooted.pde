import processing.sound.*; //<>//
import java.util.Collections;
/*
    All speeds are in pixels or degrees  per second units unless otherwise specified
 */
float screenAngle = 0;

Level homeScreen;
Level[] levels = {};
Level currentLevel;
int levelNum = -1;
HighScore[] highScoresList;
HighScore currentScore;

boolean offCenter = false;
boolean gameStarted = false; //Default is false
boolean gameOver = false; //Default is false
boolean gameWon = false; //Default is false
String name = "";

PFont sPro;
SoundFile smallImpact;

//The window class is where the window is relative to the elements on the screen
Window window;
//Main character is you!
GameCharacter mainCharacter;
PVector rotatedMousePosition;

void setup() {
    //Creating the canvas.
    //size(displayWidth, displayHeight, P3D);
    fullScreen(P3D);
    //Initialize levels.
    initLevels();
    //Set current level to desired level.
    currentLevel = homeScreen;
    //Custom cursor utilised, so do not show original cursor.
    noCursor();
    //Set frame rate
    frameRate(1000);
    //Initialized window object.
    window = new Window((TileData.TILE_SIZE * currentLevel.map.numXTiles - width)/2, (TileData.TILE_SIZE * currentLevel.map.numYTiles - height)/2, width, height);
    //Get the rotated mouse position. 
    rotatedMousePosition = getRotatedCursor(mouseX, mouseY);
    //Initialized character object, set him in middle.
    mainCharacter = new MainCharacter(currentLevel.characterData, TileData.TILE_SIZE * currentLevel.map.numXTiles/2, TileData.TILE_SIZE * currentLevel.map.numYTiles/2 );
    sPro = createFont("SourceSansPro-Semibold-120.vlw", 120);
    //smallImpact = new SoundFile(this, sketchPath("SharpPunch.mp3"));
}

void draw() {
    rotatedMousePosition = getRotatedCursor(mouseX, mouseY);
    background(52, 204, 255);
    updateCoordinates();
    hint(ENABLE_DEPTH_TEST);
    pushMatrix();
    rotateX(0.4);
    applyMatrix(screenCoordinates);
    //rotateY(50);
    //Display tiles so that even when rotating everything is displayed.
    currentLevel.map.displayTiles(window);
    translate(0, 0, 5);
    currentLevel.characterData.updateAndDisplayCharacters();
    popMatrix();
    hint(DISABLE_DEPTH_TEST);
    if (gameStarted && !gameOver && !gameWon) {
        window.fixScreenTo(mainCharacter.xPos - (offCenter? 150:0) * sin(screenAngle), mainCharacter.yPos - (offCenter? 150:0) * cos(screenAngle));
        //Respond to key movements only when game is playing.
        keyRespond();
        fill(0);
        textSize(20);
        textAlign(LEFT);
        text(currentScore.score, 10, 25);
        if(currentLevel.characterData.characters.length - currentLevel.characterData.friendlyCharacters.length == 0){
            if(levelNum == levels.length - 1){
                winGame();
            }else{
                currentLevel.over = true;
                if(currentLevel.characterOnEndTile(mainCharacter)){
                    nextLevel();
                }
            }
        }
    } else if(gameOver){
        window.fixScreenTo(mainCharacter.xPos, mainCharacter.yPos - 150);
        textSize(120);
        textFont(sPro);
        textAlign(CENTER);
        fill(0);
        text("You Lose", width/2, height/4);
        textSize(30);
        for(int i = 0; i < 10; i++){
            text(i + 1 + ". " + highScoresList[i], width/2, height/4 + 30 + i * 35);
        }
    }else if(gameWon){
        window.fixScreenTo(mainCharacter.xPos, mainCharacter.yPos - 150);
        textSize(120);
        textFont(sPro);
        textAlign(CENTER);
        fill(0);
        text("You Win", width/2, height/4);
        textSize(30);
        for(int i = 0; i < 10; i++){
            text(i + 1 + ". " + highScoresList[i], width/2, height/4 + 30 + i * 35);
        }
    }else {
        drawTabs();
        window.fixScreenTo(mainCharacter.xPos, mainCharacter.yPos - 150);
        textSize(120);
        textFont(sPro);
        textAlign(CENTER);
        fill(0);
        text("Slappy", width/2, height/4);
        rect(width/4, height/2 - 100, width/2, 60);
        fill(255);
        rect(width/4 + 2, height/2 - 98, width/2 - 4, 56);
        textSize(50);
        float cursorPosition = textWidth(name);
        fill(0);
        strokeWeight(2);
        line(width/4 + 2 + cursorPosition, height/2 - 98, width/4 + 2 + cursorPosition, height/2 - 42);
        if(textWidth(name) == 0){
            textAlign(LEFT);
            fill(150);
            text("Enter name:", width/4 + 8, height/2 - 53);
        }else{
            fill(0);
            text(name, width/2, height/2 - 53);
        }
    }
    drawCursor(mouseX, mouseY);
}

void nextLevel() {
    levelNum += 1;
    currentLevel = levels[levelNum];
    mainCharacter = new MainCharacter(currentLevel.characterData, TileData.TILE_SIZE * currentLevel.startX, TileData.TILE_SIZE * currentLevel.startY);
    delay(100);
}

//Called when you win the game
void winGame(){
    gameWon = true;
    currentScore.saveScores();
}

//Called when you lose the game
void loseGame(){
    gameOver = true;
    currentScore.saveScores();
}

int increaseDirection = 1;
float previousAngle = 0;
int numTabs = 10;
void drawTabs() {
    float theta = radians(360/numTabs);
    float angle = (mainCharacter.weapon.angle + QUARTER_PI + 2 * theta + PI) % (2 * PI);
    pushMatrix();
    translate(mainCharacter.xPos - window.position.x, mainCharacter.yPos - window.position.y);
    if (previousAngle < PI && angle > 2 * PI - theta) {
        increaseDirection = -1;
    } else if (previousAngle > PI && angle < theta) {
        increaseDirection = 1;
    }
    fill(255);
    rect(-5, 100, 10, 20);
    for (int i = 1; i < numTabs; i++) {
        rotate(theta);
        if (angle > theta * i) {
            fill(increaseDirection > 0? 255:50);
        } else {
            fill(increaseDirection < 0? 255:50);
        }
        rect(-5, 100, 10, 20);
    }
    if ((angle > 2 * PI - theta && increaseDirection == 1) || (angle < theta && increaseDirection == -1)) {
        gameStarted = true;
        if(textWidth(name) == 0){
            name = "Anonymous";
        }
        //Loading the high scores.
        loadHighScores();
        nextLevel();
    }
    popMatrix();
    previousAngle = angle;
}

PMatrix2D screenCoordinates = new PMatrix2D();//box coordinate system
PMatrix2D reverseScreenCoordinates = new PMatrix2D();//inverted coordinate system
PVector getRotatedCursor(float x, float y) {
    //PVector mouseReverseScreenCoordinates = 
    PVector reversedTestPoint = new PVector(0, 0);//Reset the reverse test point.
    PVector testPoint = new PVector(x, y);//Set the x,y coordinates to be tested.
    //Transform the passed x,y coordinates to the reversed coordinates using matrix multiplication.
    reverseScreenCoordinates.mult(testPoint, reversedTestPoint);
    return new PVector(reversedTestPoint.x - window.position.x, reversedTestPoint.y - window.position.y);
}

void updateCoordinates() {
    screenCoordinates = new PMatrix2D();
    screenCoordinates.translate(width/2, height/2);
    screenCoordinates.rotate(screenAngle);
    screenCoordinates.translate(-window.position.x - width/2, -window.position.y - height/2);
    reverseScreenCoordinates = screenCoordinates.get();
    reverseScreenCoordinates.invert();
}

float timePressed = 0;
void mousePressed() {
    float time = millis();
    float timeDifference = time - timePressed;
    timePressed = time;
    if (timeDifference < 200 && gameStarted) {
        PVector dashVector = PVector.fromAngle(atan2(rotatedMousePosition.y + window.position.y - mainCharacter.yPos, rotatedMousePosition.x + window.position.x - mainCharacter.xPos)).normalize().mult(3);
        mainCharacter.addDirectionForce(dashVector, 0.05);
        timePressed -= 200;
    }
}

//WOOHOO custom cursor I'm cool
void drawCursor(float x, float y) {
    strokeWeight(1);
    //Push matrix translate to x, y.
    pushMatrix();
    translate(x, y);
    //Set colours.
    fill(255, 0, 0);
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
    translate(0, 0, 0.1);
    fill(255);
    line(-7, -9, -7, -8);
    line(7, -9, 7, -8);
    line(-7, 9, -7, 8);
    line(7, 9, 7, 8);
    //No stroke again.
    noStroke();
    //Return to normal matrix.
    popMatrix();
}

//Rotate a vector in 2D
PVector rotateVector(PVector vector, float theta) {
    float magnitude = vector.mag();
    float angle = vector.heading();
    angle += theta;
    vector.x = magnitude * cos(angle);
    vector.y = magnitude * sin(angle);
    return vector;
}

//Create all the levels.
void initLevels() {
    TileData homeScreenMap = new TileData(40, 40);
    homeScreenMap.addTilesInRectangle(new Moss(0, 0), 0, 0, 40, 40);
    homeScreenMap.addTilesInRectangle(new Grass(0, 0), 5, 10, 25, 10);
    homeScreenMap.addTilesInCircle(new Grass(0, 0), 5, 16, 10);
    for (int i = 0; i < 20; i ++) {
        for (int j = 0; j < 20 - i; j ++) {
            homeScreenMap.addTileToGrid(new Moss(i, j));
        }
    }
    for (int i = 0; i < 16; i++) {
        int randomValue = parseInt(random(5, 15)); 
        homeScreenMap.addTileToGrid(new Moss(randomValue, parseInt(random(20, 30)) - randomValue));
    }
    homeScreenMap.addTilesInCircle(new Water(0, 0), 30, 9, 10);
    homeScreenMap.addTilesInCircle(new DeepWater(0, 0), 30, 9, 5);
    homeScreenMap.addTilesInRectangle(new Rock(0, 0), 13, 6, 8, 4);
    homeScreenMap.addTilesInRectangle(new Water(0, 0), 13, 12, 8, 2);
    for (int i = 0; i < 15; i ++) {
        homeScreenMap.addTilesInRectangle(new Water(0, 0), 12 - i, 13 + i, 3, 1);
    }
    homeScreenMap.addTileToGrid(new Water(20, 11));
    homeScreen = new Level(homeScreenMap, new CharacterData(), 20, 20, 0, 0);
    
    TileData tutorialMap = new TileData(6, 6);
    tutorialMap.addTilesInRectangle(new Temple(0, 0), 0, 0, 6, 6);
    CharacterData tutorialCharacterData = new CharacterData();
    tutorialCharacterData.addEnemies(EnemyTypes.DUMMY, 2, TileData.TILE_SIZE * 2, TileData.TILE_SIZE * 2);
    Level tutorial = new Level(tutorialMap, tutorialCharacterData, 3, 3, 3, 3);
    
    //Level 0
    TileData level0Map = new TileData(10, 10); 
    for (int i = 0; i < level0Map.numXTiles; i++) {
        for (int j = 0; j < level0Map.numYTiles; j++) {
            level0Map.addTileToGrid(new Beach(i, j));
            if (i == 2 || j == 2 || i == level0Map.numXTiles - 3 || j == level0Map.numYTiles - 3) {
                level0Map.addTileToGrid(new Water(i, j));
            }
            if (i == 1 || j == 1 || i == level0Map.numXTiles - 2 || j == level0Map.numYTiles - 2) {
                level0Map.addTileToGrid(new Water(i, j));
            }
            if (i == 0 || j == 0 || i == level0Map.numXTiles - 1 || j == level0Map.numYTiles - 1) {
                level0Map.addTileToGrid(new DeepWater(i, j));
            }
        }
    }
    level0Map.addTileToGrid(new Rock(4, 3));
    level0Map.addTileToGrid(new Rock(5, 3));
    level0Map.addTileToGrid(new Rock(6, 5));
    level0Map.addTileToGrid(new Rock(5, 6));
    level0Map.addTileToGrid(new Rock(4, 6));
    level0Map.addTileToGrid(new Rock(3, 3));
    level0Map.addTileToGrid(new Rock(3, 6));
    level0Map.addTileToGrid(new Rock(6, 3));
    level0Map.addTileToGrid(new Rock(6, 4));
    level0Map.addTileToGrid(new Rock(6, 6));
    CharacterData level0CharacterData = new CharacterData();
    level0CharacterData.addEnemies(EnemyTypes.BASIC_WANDER, 2, TileData.TILE_SIZE * 8, TileData.TILE_SIZE * 2);
    level0CharacterData.addEnemies(EnemyTypes.FAST_THINGIES, 2, TileData.TILE_SIZE * 5, TileData.TILE_SIZE * 7);
    Level level0 = new Level(level0Map, level0CharacterData, 8, 5, 5, 5);
    
    //Level 1
    TileData level1Map = new TileData(20, 20); 
    for (int i = 0; i < level1Map.numXTiles; i++) {
        for (int j = 0; j < level1Map.numYTiles; j++) {
            if (i + j > 30) {
                level1Map.addTileToGrid(new Bush(i, j));
            } else if (i + j > 10) {
                level1Map.addTileToGrid(new Grass(i, j));
            } else {
                level1Map.addTileToGrid(new Jungle(i, j));
            }
        }
    }
    level1Map.addTilesInCircle(new Temple(0, 0), 7, 7, 4);
    level1Map.addTilesInUnfilledRectangle(new Rock(0, 0), 0, 0, level1Map.numXTiles - 1, level1Map.numYTiles - 1);
    level1Map.addTilesInUnfilledRectangle(new Rock(0, 0), 3, 3, 8, 8);
    level1Map.addTilesInRectangle(new Rock(0, 0), 6, 6, 1, 3);
    level1Map.addTileToGrid(new Grass(11, 8));
    level1Map.addTileToGrid(new Grass(11, 7));
    level1Map.addTileToGrid(new Grass(3, 7));
    level1Map.addTilesInRectangle(new Sand(0, 0), 1, 15, 6, 4);
    level1Map.addTilesInRectangle(new Mountain(0, 0, 1), 0, 16, 4, 4);
    level1Map.addTilesInRectangle(new Mountain(0, 0, 2), 0, 17, 3, 3);
    level1Map.addTilesInRectangle(new Mountain(0, 0, 3), 0, 18, 2, 2);
    level1Map.addTileToGrid(new Mountain(1, 18, 2));
    level1Map.addTileToGrid(new Mountain(2, 17, 1));
    level1Map.addTileToGrid(new Grass(6, 15));
    level1Map.addTileToGrid(new Sand(4, 16));
    level1Map.addTileToGrid(new Sand(1, 14));
    level1Map.addTileToGrid(new Sand(2, 14));
    level1Map.addTileToGrid(new Sand(1, 13));
    level1Map.addTileToGrid(new Rock(1, 15));
    level1Map.addTileToGrid(new Rock(4, 18));
    level1Map.addTileToGrid(new Sand(7, 18));
    CharacterData level1CharacterData = new CharacterData();
    level1CharacterData.addEnemies(EnemyTypes.BASIC_WANDER, 4, TileData.TILE_SIZE * 2, TileData.TILE_SIZE * 2);
    level1CharacterData.addEnemies(EnemyTypes.BIG_TANKY_MEATY_BOI, 2, TileData.TILE_SIZE * 2, TileData.TILE_SIZE * 2);
    level1CharacterData.addEnemies(EnemyTypes.DA_BIG_BOSS, 1, TileData.TILE_SIZE * 15, TileData.TILE_SIZE * 15);
    level1CharacterData.addEnemies(EnemyTypes.FAST_THINGIES, 2, TileData.TILE_SIZE * 15, TileData.TILE_SIZE * 15);
    Level level1 = new Level(level1Map, level1CharacterData, 8, 5, 8, 5);
    
    CharacterData level2CharacterData = new CharacterData();
    level2CharacterData.addEnemies(EnemyTypes.BASIC_WANDER, 4, TileData.TILE_SIZE * 2, TileData.TILE_SIZE * 2);
    level2CharacterData.addEnemies(EnemyTypes.BASIC_WANDER, 8, TileData.TILE_SIZE * 30, TileData.TILE_SIZE * 30);
    level2CharacterData.addEnemies(EnemyTypes.BIG_TANKY_MEATY_BOI, 2, TileData.TILE_SIZE * 2, TileData.TILE_SIZE * 2);
    level2CharacterData.addEnemies(EnemyTypes.BIG_TANKY_MEATY_BOI, 2, TileData.TILE_SIZE * 2, TileData.TILE_SIZE * 35);
    level2CharacterData.addEnemies(EnemyTypes.DA_BIG_BOSS, 1, TileData.TILE_SIZE * 3, TileData.TILE_SIZE * 3);
    level2CharacterData.addEnemies(EnemyTypes.DA_BIG_BOSS, 1, TileData.TILE_SIZE * 30, TileData.TILE_SIZE * 30);
    level2CharacterData.addEnemies(EnemyTypes.FAST_THINGIES, 2, TileData.TILE_SIZE * 5, TileData.TILE_SIZE * 5);
    level2CharacterData.addEnemies(EnemyTypes.FAST_THINGIES, 18, TileData.TILE_SIZE * 35, TileData.TILE_SIZE * 5);
    Level level2 = new Level(homeScreenMap, level2CharacterData, 8, 5, 30, 20);
    
    levels = (Level[])append(levels, tutorial);
    levels = (Level[])append(levels, level0);
    levels = (Level[])append(levels, level1);
    levels = (Level[])append(levels, level2);
}

//This is used to get all the highscores into the highScoresList array.
void loadHighScores() {
    String[] highScoresRaw = loadStrings("HighScores.txt");
    //println(highScoresRaw);
    highScoresList = new HighScore[highScoresRaw.length];
    for (int i = 0; i < highScoresRaw.length; i ++) {
        highScoresList[i] = new HighScore(highScoresRaw[i]);
        //println(highScoresList[i]);
    }
    currentScore = new HighScore(name + ", 0");
}