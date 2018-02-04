public abstract class GameCharacter {
    float xPos, yPos;
    float speed;
    float size; //Diameter of circle.
    color colour;
    int maxHealth; //Maximum health of character; cannot have more current health than this. 
    int currentHealth; //Current state of health character is in.
    Weapon weapon; //Character's weapon.
    float weaponAngle;

    int characterIndex;
    float wanderSpeed;
    //Main Character does not use target, but every other computer-controlled entity does.
    GameCharacter target;
    float targetDetectionRange = 600;

    PVector selfDirection = new PVector(0, 0);
    PVector[] directionForces = {};
    float[] directionForcesDeteriorationRate = {};

    SoundFile onDeath;
    CharacterData cData = new CharacterData();
    
    GameCharacter(CharacterData cData, float x, float y, float speed, float size, int maxHealth, color colour) {
        this.cData = cData;
        characterIndex = cData.characters.length;
        if(this instanceof MainCharacter){
            characterIndex = 0;
            for (int i = 0; i < cData.characters.length; i++) {
                cData.characters[i].characterIndex++;
            }
            GameCharacter[] self = {this};
            cData.characters = (GameCharacter[])concat(self, cData.characters);
        }else{
            cData.characters = (GameCharacter[])append(cData.characters, this);
        }
        xPos = x;
        yPos = y;
        this.speed = speed;
        this.size = size;
        this.maxHealth = maxHealth;
        currentHealth = maxHealth;
        this.colour = colour;
        weapon = new Weapon(10, 200, this);
    }

    //PVector getFinalMotionVector(){
    //    float moveSpeed = speed;
    //    PVector finalChange = new PVector((100 * moveSpeed / frameRate) * (selfDirection.x / selfDirection.mag()), (100 * moveSpeed / frameRate) * (selfDirection.y / selfDirection.mag()));
    //    for (int i = 0; i < directionForces.length; i++) {
    //        finalChange.add(directionForces[i]);
    //    }
    //    return finalChange;
    //}

    void applyDirectionForces() {
        for (int i = 0; i < directionForces.length; i++) {
            xPos += 100 * directionForces[i].x / frameRate;
            yPos += 100 * directionForces[i].y / frameRate;
            //finalChange^frameRate = diminishPerSecond
            //finalChange = diminishPerSecond^(1/frameRate).
            float newMagnitude = directionForces[i].mag()* pow(directionForcesDeteriorationRate[i], 1/frameRate);
            if (newMagnitude < 0.001) {
                directionForces = removeVectorByIndex(i, directionForces);
            } else {
                directionForces[i].setMag(newMagnitude);
            }
        }
    }

    void addDirectionForce(PVector direction, float deterioration) {
        directionForces = (PVector[])append(directionForces, direction);
        directionForcesDeteriorationRate = append(directionForcesDeteriorationRate, deterioration);
    }

    void updateCharacter() {
        float moveSpeed = target == null? wanderSpeed:speed;
        move(selfDirection, moveSpeed);
        checkAndFixPositionToTiles();
        checkAndFixPositionToBoundary();
        applyDirectionForces();
        for (int i = 0; i < cData.characters.length; i++) {
            if (i != this.characterIndex) {
                if (collidedWithCharacter(cData.characters[i])) {
                    PVector fixVector = getFixVectorFromChar(cData.characters[i]);
                    float totalSizeSum = pow(this.size, 2) + pow(cData.characters[i].size, 2);
                    PVector selfFixVector = fixVector.copy().mult(pow(cData.characters[i].size, 2)/totalSizeSum);
                    xPos += selfFixVector.x;
                    yPos += selfFixVector.y;
                    PVector otherFixVector = fixVector.copy().mult(-1).mult(pow(this.size, 2)/totalSizeSum);
                    cData.characters[i].xPos += otherFixVector.x;
                    cData.characters[i].yPos += otherFixVector.y;
                }
            }
        }
        checkAndFixPositionToTiles();
        weapon.updateWeapon(weaponAngle);
    }

    void displayCharacter() {
        stroke(0);
        strokeWeight(2);
        fill(lerpColor(color(204, 10, 0), colour, currentHealth/float(maxHealth)));
        pushMatrix();
        weapon.displayWeapon();
        translate(0, 0, 1.001);
        ellipse(xPos, yPos, size, size);
        translate(0, 0, 1.001);
        weapon.displayNoStrokeWeapon();
        popMatrix();
    }

    void move(PVector direction, float moveSpeed) {
        if (direction.mag() != 0) {
            direction.normalize();
            float xChange = (50 * moveSpeed / frameRate) * (direction.x) * (100 - currentLevel.map.getOnTile(this).speedReduction) / 100;
            float yChange = (50 * moveSpeed / frameRate) * (direction.y) * (100 - currentLevel.map.getOnTile(this).speedReduction) / 100;
            xPos += xChange;
            yPos += yChange;
        }
    }

    void checkAndFixPositionToTiles() {
        int left = max(0, parseInt((xPos - size/2)/TileData.TILE_SIZE));
        int right = min(parseInt(currentLevel.map.numXTiles - 1), parseInt((xPos + size/2)/TileData.TILE_SIZE));
        int top = max(0, parseInt((yPos - size/2)/TileData.TILE_SIZE));
        int down = min(parseInt(currentLevel.map.numYTiles - 1), parseInt((yPos + size/2)/TileData.TILE_SIZE));
        for (int i = left; i <= right; i++) {
            for (int j = top; j <= down; j++) {
                if (!currentLevel.map.tileGrid[i][j].walkable) { 
                    //println(i, j, tileData.tileGrid[i][j]);
                    if (currentLevel.map.tileGrid[i][j].intersectsWithCharacter(this)) {
                        PVector fixVector = currentLevel.map.tileGrid[i][j].getFixVector(this);
                        xPos += fixVector.x;
                        yPos += fixVector.y;
                    }
                }
            }
        }
    }

    void checkAndFixPositionToBoundary() {
        xPos = max(size/2, min(xPos, TileData.TILE_SIZE * currentLevel.map.numXTiles - size/2));
        yPos = max(size/2, min(yPos, TileData.TILE_SIZE * currentLevel.map.numYTiles - size/2));
    }

    float distToCharacter(GameCharacter character) {
        return dist(xPos, yPos, character.xPos, character.yPos);
    }

    float distToCharacterSquared(GameCharacter character) {
        return pow(xPos - character.xPos, 2) + pow(yPos - character.yPos, 2);
    }

    boolean collidedWithCharacter(GameCharacter checkCharacter) {
        if (distToCharacter(checkCharacter) <= (this.size + checkCharacter.size)/2) {
            return true;
        }
        return false;
    }

    PVector getFixVectorFromChar(GameCharacter checkCharacter) {
        PVector towardsVector = new PVector(checkCharacter.xPos - this.xPos, checkCharacter.yPos - this.yPos);
        if (towardsVector.mag() == 0) {
            towardsVector = PVector.random2D();
        }
        PVector targetVector = towardsVector.copy().normalize().mult((this.size + checkCharacter.size)/2);
        PVector fixVector = targetVector.sub(towardsVector).mult(-1);
        return fixVector;
    }

    GameCharacter[] removeCharacterByIndex(int index, GameCharacter[] array) {
        int arrayLength = array.length;
        GameCharacter[] prefix = new GameCharacter[index];
        GameCharacter[] suffix = new GameCharacter[arrayLength - index - 1];
        arrayCopy(array, 0, prefix, 0, index);
        arrayCopy(array, index + 1, suffix, 0, arrayLength - index - 1);
        for (int i = index; i < cData.characters.length; i++) {
            cData.characters[i].characterIndex--;
        }
        return (GameCharacter[]) concat(prefix, suffix);
    }

    PVector[] removeVectorByIndex(int index, PVector[] array) {
        int arrayLength = array.length;
        PVector[] prefix = new PVector[index];
        PVector[] suffix = new PVector[arrayLength - index - 1];
        arrayCopy(array, 0, prefix, 0, index);
        arrayCopy(array, index + 1, suffix, 0, arrayLength - index - 1);
        return (PVector[]) concat(prefix, suffix);
    }
}