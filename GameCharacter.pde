public abstract class GameCharacter {
    float xPos, yPos;
    float speed;
    float hCircleRadius;
    float size;
    int maxHealth;
    int currentHealth;
    Weapon weapon;
    
    
    SoundFile onDeath;

    ////Only applies to enemies.
    //int characterIndex;

    int damageTimer;
    //So that a character doesn't take damage multiple times a second.

    GameCharacter(float x, float y, float speed, float size) {
        xPos = x;
        yPos = y;
        this.speed = speed;
        this.size = size;
    }

    void makeBitmap(color[][] bitmap, int x, int y, int squareSize) {
        pushMatrix();
        translate(x, y);
        for (int i = 0; i < bitmap.length; i++) {
            for (int j = 0; j < bitmap[i].length; j++) {
                fill(bitmap[i][j]);
                rect(j * squareSize, i * squareSize, squareSize, squareSize);
            }
        }
        popMatrix();
    }

    abstract void updateCharacter();

    void displayCharacter() {
        ellipse(xPos, yPos, size, size);
    }

    void move(PVector direction, float moveSpeed) {
        if (direction.mag() != 0) {
            float xChange = (100 * moveSpeed / frameRate) * (direction.x / direction.mag());
            float yChange = (100 * moveSpeed / frameRate) * (direction.y / direction.mag());
            xPos += xChange;
            yPos += yChange;
        }
        checkAndFixPositionToBoundary();
    }

    void checkAndFixPositionToBoundary() {
        xPos = max(size/2, min(xPos, ARENA_WIDTH - size/2));
        yPos = max(size/2, min(yPos, ARENA_HEIGHT - size/2));
    }

    boolean collidedWithCharacter(GameCharacter checkCharacter) {
        if (dist(this.xPos, this.yPos, checkCharacter.xPos, checkCharacter.yPos) <= (this.size + checkCharacter.size)/2) {
            return true;
        }
        return false;
    }

    PVector getFixVectorFromChar(GameCharacter checkCharacter) {
        PVector towardsVector = new PVector(checkCharacter.xPos - this.xPos, checkCharacter.yPos - this.yPos);
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
        for (int i = index; i < characterData.characters.length; i++) {
            if (characterData.characters[i] instanceof Enemy) {
                ((Enemy)characterData.characters[i]).characterIndex--;
            }
        }
        return (GameCharacter[]) concat(prefix, suffix);
    }
}