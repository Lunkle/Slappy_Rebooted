public class TileData{
    //The size of a tile.
    static final float TILE_SIZE = 50;
    //Amount of tiles width and height.
    public int numXTiles, numYTiles;
    //Store all them tiles.
    Tile[][] tileGrid;
    
    //Constructor.
    public TileData(int numXTiles, int numYTiles){
        this.numXTiles = numXTiles;
        this.numYTiles = numYTiles;
        tileGrid = new Tile[numXTiles][numYTiles];
    }
    
    //Get which tile a character is on.
    Tile getOnTile(GameCharacter character){
        int tileX = max(0, min(currentLevel.map.numXTiles - 1, floor(character.xPos/TileData.TILE_SIZE)));
        int tileY = max(0, min(currentLevel.map.numYTiles - 1, floor(character.yPos/TileData.TILE_SIZE)));
        return currentLevel.map.tileGrid[tileX][tileY];
    }
    
    //Returns an array of all the neighbours of a tile.
    Tile[] neighbors(Tile tile){
        Tile[] neighbors = {};
        for(int i = -1; i <= 1; i ++){
            for(int j = -1; j <= 1; j ++){
                if(!(i == 0 && j == 0)){
                    try{
                        neighbors = (Tile[])append(neighbors, tileGrid[tile.tileGridX + i][tile.tileGridY + j]);
                    }catch(ArrayIndexOutOfBoundsException e){}
                }
            }
        }
        return neighbors;
    }
    
    //Estimate the cost from one tile to another.
    float getCost(Tile fromTile, Tile toTile){
        return dist(fromTile.tileGridX, fromTile.tileGridY, toTile.tileGridX, toTile.tileGridY) * (fromTile.speedReduction + toTile.speedReduction)/2;
    }
    
    //Gets the vector from one tile to the other.
    PVector getVector(Tile fromTile, Tile toTile){
        return toTile.getCenter().sub(fromTile.getCenter());
    }
    
    //Adds a tile to the grid.
    void addTileToGrid(Tile tile){
        tileGrid[tile.tileGridX][tile.tileGridY] = tile;
    }
    
    //Add tiles in a rectangle.
    void addTilesInRectangle(Tile tile, int xStart, int yStart, int rectWidth, int rectHeight){
        for(int i = xStart; i < xStart + rectWidth; i ++){
            for(int j = yStart; j < yStart + rectHeight; j ++){
                if(i >= 0 && j >= 0 && i < numXTiles && j < numYTiles){
                    tileGrid[i][j] = tile.clone(i, j);
                }
            }
        }
    }
    
    //Add tiles in an empty rectangle.
    void addTilesInUnfilledRectangle(Tile tile, int xStart, int yStart, int rectWidth, int rectHeight){
        for(int i = xStart; i <= xStart + rectWidth; i ++){
            try{
                tileGrid[i][yStart] = tile.clone(i, yStart);
            }catch(ArrayIndexOutOfBoundsException e){}
            try{
                tileGrid[i][yStart + rectHeight] = tile.clone(i, yStart + rectHeight);
            }catch(ArrayIndexOutOfBoundsException e){}
        }
        for(int i = yStart; i < yStart + rectHeight; i ++){
            try{
                tileGrid[xStart][i] = tile.clone(xStart, i);
            }catch(ArrayIndexOutOfBoundsException e){}
            try{
                tileGrid[xStart + rectWidth][i] = tile.clone(xStart + rectWidth, i);
            }catch(ArrayIndexOutOfBoundsException e){}
        }
    }
    
    //Add tiles in a circle.
    void addTilesInCircle(Tile tile, int xCenter, int yCenter, int radius){
        int radiusSquared = parseInt(pow(radius, 2));
        for(int i = xCenter - radius; i < xCenter + radius; i ++){
            for(int j = yCenter - radius; j < yCenter + radius; j ++){
                if(i >= 0 && j >= 0 && i < numXTiles && j < numYTiles){
                    if(pow(xCenter - i, 2) + pow(yCenter - j, 2) < radiusSquared){
                        tileGrid[i][j] = tile.clone(i, j);
                    }
                }
            }
        }
    }
    
    //The function called all da times to draw de tiles.
    public void displayTiles(Window window){
        for(int i = 0; i < numXTiles; i ++){
            for(int j = 0; j < numYTiles; j ++){
                //If it is off-screen then don't draw it.
                if(pow(window.position.x + window.screenWidth/2 - tileGrid[i][j].getCenter().x, 2) + pow(window.position.y + window.screenHeight/2 - tileGrid[i][j].getCenter().y, 2) < pow(window.screenWidth, 2) + pow(window.screenHeight, 2)){
                    tileGrid[i][j].displayTile();
                }
            }
        }
    }
}