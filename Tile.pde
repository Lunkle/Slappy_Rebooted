public abstract class Tile {
    int tileGridX;
    int tileGridY;
    int speedReduction; //A percentage
    boolean walkable = true;
    color tileColour;

    float nearestTileX, nearestTileY;
    boolean showTileContactWithCharacterPoint = false;
    boolean transparent = false;
    boolean showNumbers = false;

    public Tile(int tileX, int tileY, int speedReduction) {
        this.tileGridX = tileX;
        this.tileGridY = tileY;
        this.speedReduction = speedReduction;
    }

    abstract Tile clone(int tileX, int tileY);

    float extra = 0.5;
    void displayTile() {
        strokeWeight(1);
        fill(tileColour);
        noStroke();
        if (transparent) {
            noFill();
            stroke(0);
        }
        rect(tileGridX * TileData.TILE_SIZE - extra, tileGridY * TileData.TILE_SIZE - extra, TileData.TILE_SIZE + extra, TileData.TILE_SIZE + extra);
        pushMatrix();
        translate((tileGridX + 0.5) * TileData.TILE_SIZE, (tileGridY + 0.5) * TileData.TILE_SIZE, -TileData.TILE_SIZE/2);
        stroke(lerpColor(color(0, 0, 0), tileColour, 0.8));
        box(TileData.TILE_SIZE, TileData.TILE_SIZE, TileData.TILE_SIZE);
        popMatrix();
        if (showNumbers) {
            fill(10);
            textSize(10);
            text(getTileNumber() + " (" + tileGridX + ", " + tileGridY + ")", tileGridX * TileData.TILE_SIZE, tileGridY * TileData.TILE_SIZE + 12);
        }
        if (showTileContactWithCharacterPoint) {
            fill(0);
            ellipse(nearestTileX, nearestTileY, 10, 10);
        }
        //This is for testing purposes Theta*
        //Tile[][] surrounding = new Tile[3][3];
        //for(int i = 0; i < 3; i++){
        //    for(int j = 0; j < 3; j++){
        //        surrounding[i][j] = currentLevel.tileGrid[tileGridX - 1 + i][tileGridY - 1 + j];
        //    }
        //}
    }

    PVector getCenter() {
        return new PVector(tileGridX + 0.5, tileGridY + 0.5).mult(TileData.TILE_SIZE);
    }

    //float nearestTileX, nearestTileY;
    boolean intersectsWithCharacter(GameCharacter character) {
        nearestTileX = max(tileGridX * TileData.TILE_SIZE, min(character.xPos, (tileGridX + 1) * TileData.TILE_SIZE));
        nearestTileY = max(tileGridY * TileData.TILE_SIZE, min(character.yPos, (tileGridY + 1) * TileData.TILE_SIZE));
        return dist(character.xPos, character.yPos, nearestTileX, nearestTileY) < character.size / 2;
    }

    PVector getFixVector(GameCharacter character) {
        nearestTileX = max(tileGridX * TileData.TILE_SIZE, min(character.xPos, (tileGridX + 1) * TileData.TILE_SIZE));
        nearestTileY = max(tileGridY * TileData.TILE_SIZE, min(character.yPos, (tileGridY + 1) * TileData.TILE_SIZE));
        PVector toVector;
        if (nearestTileX == character.xPos && nearestTileY == character.yPos) {
            PVector center = this.getCenter();
            toVector = new PVector(character.xPos - center.x, character.yPos - center.y);
            float biggest = max(abs(toVector.x), abs(toVector.y));
            toVector.mult((character.size + TileData.TILE_SIZE)/(2 * biggest));
        } else {
            toVector = new PVector(nearestTileX - character.xPos, nearestTileY - character.yPos);
            float dist = toVector.mag();
            toVector.normalize().mult(dist - character.size/2);
        }
        return toVector;
    }

    private int getTileNumber() {
        return tileGridY * currentLevel.map.numXTiles + tileGridX;
    }

    String toString() {
        return this.getClass().getName();
    }
}

class Sand extends Tile {
    int numGrains;
    PVector[] locations;
    color[] colours;

    Sand(int tileX, int tileY) {
        super(tileX, tileY, 15);
        init();
    }

    void init() {
        tileColour = color(194, 173, 128);
        numGrains = parseInt(random(40, 50));
        locations = new PVector[numGrains];
        colours = new color[numGrains];
        for (int i = 0; i < numGrains; i++) {
            locations[i] = new PVector(random(tileGridX * TileData.TILE_SIZE, (tileGridX + 1) * TileData.TILE_SIZE), random(tileGridY * TileData.TILE_SIZE, (tileGridY + 1) * TileData.TILE_SIZE));
            ;
            colours[i] = lerpColor(color(126, 88, 27), color(210, 147, 45), random(1));
        }
    }

    void displayTile() {
        super.displayTile();
        for (int i = 0; i < numGrains; i++) {
            strokeWeight(2);
            stroke(colours[i]);
            point(locations[i].x, locations[i].y);
        }
    }

    Tile clone(int tileX, int tileY) {
        return new Sand(tileX, tileY);
    }
}
class Beach extends Tile {
    int numGrains;
    PVector[] locations;
    color[] colours;

    Beach(int tileX, int tileY) {
        super(tileX, tileY, 15);
        init();
    }

    void init() {
        tileColour = color(244, 220, 181);
        numGrains = parseInt(random(40, 50));
        locations = new PVector[numGrains];
        colours = new color[numGrains];
        for (int i = 0; i < numGrains; i++) {
            locations[i] = new PVector(random(tileGridX * TileData.TILE_SIZE, (tileGridX + 1) * TileData.TILE_SIZE), random(tileGridY * TileData.TILE_SIZE, (tileGridY + 1) * TileData.TILE_SIZE));
            ;
            colours[i] = lerpColor(color(126, 88, 27), color(228, 190, 129), random(1));
        }
    }

    void displayTile() {
        super.displayTile();
        for (int i = 0; i < numGrains; i++) {
            strokeWeight(2);
            stroke(colours[i]);
            point(locations[i].x, locations[i].y);
        }
    }

    Tile clone(int tileX, int tileY) {
        return new Beach(tileX, tileY);
    }
}
class Mountain extends Tile {
    int numBlocks = 1;

    Mountain(int tileX, int tileY, int numBlocks) {
        super(tileX, tileY, 0);
        this.numBlocks = numBlocks;
        init();
    }

    void init() {
        walkable = false;
        tileColour = color(129, 108, 91);
    }

    void displayTile() {
        super.displayTile();
        pushMatrix();
        translate((tileGridX + 0.5) * TileData.TILE_SIZE, (tileGridY + 0.5) * TileData.TILE_SIZE, TileData.TILE_SIZE * numBlocks/2.0);
        box(TileData.TILE_SIZE, TileData.TILE_SIZE, TileData.TILE_SIZE * numBlocks);
        popMatrix();
    }

    Tile clone(int tileX, int tileY) {
        return new Mountain(tileX, tileY, numBlocks);
    }
}
class Rock extends Tile {
    Rock(int tileX, int tileY) {
        super(tileX, tileY, 0);
        init();
    }

    void init() {
        walkable = false;
        tileColour = color(129, 108, 91);
    }

    void displayTile() {
        super.displayTile();
        pushMatrix();
        translate((tileGridX + 0.5) * TileData.TILE_SIZE, (tileGridY + 0.5) * TileData.TILE_SIZE, TileData.TILE_SIZE/2.0);
        box(TileData.TILE_SIZE);
        popMatrix();
    }

    Tile clone(int tileX, int tileY) {
        return new Rock(tileX, tileY);
    }
}
class Water extends Tile {
    int numBubbles = 4;
    float[] phaseColours = new float[numBubbles];
    PVector[] locations = new PVector[numBubbles]; 

    Water(int tileX, int tileY) {
        super(tileX, tileY, 40);
        init();
    }

    void init() {
        tileColour = color(0, 151, 172);
        for (int i = 0; i < numBubbles; i ++) {
            locations[i] = new PVector(random(tileGridX * TileData.TILE_SIZE + 4, (tileGridX + 1) * TileData.TILE_SIZE - 4), random(tileGridY * TileData.TILE_SIZE + 2, (tileGridY + 1) * TileData.TILE_SIZE - 2));
            phaseColours[i] = random(1);
        }
    }

    void displayTile() {
        super.displayTile();
        translate(0, 0, 0.01);
        for (int i = 0; i < numBubbles; i++) {
            phaseColours[i] = phaseColours[i] + 1.0/frameRate;
            fill(lerpColor(color(245, 245, 255), tileColour, phaseColours[i]));
            ellipse(locations[i].x, locations[i].y, 8, 4);
            if (phaseColours[i] > 1) {
                phaseColours[i] = 0;
                locations[i] = new PVector(random(tileGridX * TileData.TILE_SIZE + 4, (tileGridX + 1) * TileData.TILE_SIZE - 4), random(tileGridY * TileData.TILE_SIZE + 2, (tileGridY + 1) * TileData.TILE_SIZE - 2));
            }
        }
    }

    Tile clone(int tileX, int tileY) {
        return new Water(tileX, tileY);
    }
}
class DeepWater extends Tile {
    DeepWater(int tileX, int tileY) {
        super(tileX, tileY, 0);
        init();
    }

    void init() {
        walkable = false;
        tileColour = color(0, 121, 150);
    }

    Tile clone(int tileX, int tileY) {
        return new DeepWater(tileX, tileY);
    }
}
class Ice extends Tile {
    Ice(int tileX, int tileY) {
        super(tileX, tileY, 30);
        init();
    }

    void init() {
        tileColour = color(200, 200, 250);
    }

    Tile clone(int tileX, int tileY) {
        return new Ice(tileX, tileY);
    }
}
class Temple extends Tile {
    Temple(int tileX, int tileY) {
        super(tileX, tileY, 5);
        init();
    }

    void init() {
        tileColour = color(147, 133, 73);
    }

    void displayTile() {
        super.displayTile();
        float lineLength = TileData.TILE_SIZE - 20;
        PVector point1 = new PVector(tileGridX * TileData.TILE_SIZE + 10, tileGridY * TileData.TILE_SIZE + 10);
        PVector point2 = new PVector();
        int binary = 0;
        int xSign = 1;
        int ySign = 1;
        stroke(0);
        while (lineLength > 0) {
            if (binary == 0) {
                point2.set(xSign * lineLength + point1.x, point1.y);
                xSign *= -1;
            } else if (binary == 1) {
                point2.set(point1.x, ySign * lineLength + point1.y);
                ySign *= -1;
                lineLength -= 5;
            }
            line(point1.x, point1.y, point2.x, point2.y);
            point1 = point2.copy();
            binary = 1 - binary;
        }
    }

    Tile clone(int tileX, int tileY) {
        return new Temple(tileX, tileY);
    }
}
class Grass extends Tile {
    int numGrass = parseInt(random(10, 20));
    int[] positionX = new int[numGrass];
    int[] positionY = new int[numGrass];
    int[] lengths = new int[numGrass];

    Grass(int tileX, int tileY) {
        super(tileX, tileY, 5);
        init();
    }

    void init() {
        tileColour = color(18, 230, 3);
        for (int i = 0; i < numGrass; i++) {
            positionX[i] = parseInt(random(2, TileData.TILE_SIZE - 2));
            positionY[i] = parseInt(random(2, TileData.TILE_SIZE - 2));
            lengths[i] = parseInt(random(2, TileData.TILE_SIZE - 2));
        }
    }

    void displayTile() {
        super.displayTile();
        stroke(0);
        strokeWeight(0.5);
        for (int i = 0; i < numGrass; i++) {
            pushMatrix();
            translate(tileGridX * TileData.TILE_SIZE + positionX[i], tileGridY * TileData.TILE_SIZE + positionY[i], lengths[i]/2);
            box(2, 2, lengths[i]);
            popMatrix();
        }
    }

    Tile clone(int tileX, int tileY) {
        return new Grass(tileX, tileY);
    }
}
class Moss extends Tile {
    Moss(int tileX, int tileY) {
        super(tileX, tileY, 8);
        init();
    }

    void init() {
        tileColour = color(18, 173, 42);
    }

    Tile clone(int tileX, int tileY) {
        return new Moss(tileX, tileY);
    }
}
//class Tree extends Tile {
//    Tree(int tileX, int tileY) {
//        super(tileX, tileY, 8);
//        init();
//    }

//    void init() {
//        tileColour = color(72, 162, 74);
//        trunkHeight = random(TileData.TILE_SIZE / 2.0, TileData.TILE_SIZE * 3.0 / 4.0);
//    }

//    PVector location = new PVector(random(tileGridX * TileData.TILE_SIZE + 5, (tileGridX + 1) * TileData.TILE_SIZE - 5), random(tileGridY * TileData.TILE_SIZE + 5, (tileGridY + 1) * TileData.TILE_SIZE - 5));
//    float trunkHeight;
//    void displayTile() {
//        super.displayTile();
//        pushMatrix();
//        translate(tileGridX * TileData.TILE_SIZE + location.x, tileGridY * TileData.TILE_SIZE + location.y, trunkHeight/2);
//        box(10, 10, trunkHeight);
//        popMatrix();
//    }

//    Tile clone(int tileX, int tileY) {
//        return new Tree(tileX, tileY);
//    }
//}
class Bush extends Tile {
    Bush(int tileX, int tileY) {
        super(tileX, tileY, 50);
        init();
    }

    void init() {
        tileColour = color(52, 52, 0);
    }

    Tile clone(int tileX, int tileY) {
        return new Bush(tileX, tileY);
    }
}

class Jungle extends Tile {
    Jungle(int tileX, int tileY) {
        super(tileX, tileY, 40);
        init();
    }

    void init() {
        tileColour = color(12, 43, 0);
    }

    Tile clone(int tileX, int tileY) {
        return new Jungle(tileX, tileY);
    }
}