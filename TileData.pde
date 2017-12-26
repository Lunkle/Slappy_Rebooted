public class TileData{
    static final float TILE_SIZE = 100;
    static final int NUM_X_TILES = 20;
    static final int NUM_Y_TILES = 20;
    //Store all them tiles
    Tile[][] tileGrid = new Tile[NUM_X_TILES][NUM_Y_TILES];
    
    public TileData(){}
    
    void addTileToGrid(Tile tile){
        tileGrid[tile.tileGridX][tile.tileGridY] = tile;
    }
    
    void setAllTo(TileTypes typeOfTile){
        for (int i = 0; i < TileData.NUM_X_TILES; i++) {
            for (int j = 0; j < TileData.NUM_Y_TILES; j++) {
                Tile newTile = new Tile(typeOfTile, i, j);
                this.addTileToGrid(newTile);
            }
        }
    }
    
    //The function called all da times to draw de tiles.
    public void displayTiles(float windowX, float windowY, float windowWidth, float windowHeight){
        int lowerXBound = max(0, floor(windowX/TILE_SIZE));
        int upperXBound = min(NUM_X_TILES, lowerXBound + ceil(windowWidth/TILE_SIZE) + 1);
        int lowerYBound = max(0, floor(windowY/TILE_SIZE));
        int upperYBound = min(NUM_Y_TILES, lowerYBound + ceil(windowHeight/TILE_SIZE) + 1);
        for(int i = lowerXBound; i < upperXBound; i ++){
            for(int j = lowerYBound; j < upperYBound; j ++){
                try{
                    tileGrid[i][j].drawTile();
                }catch(Exception e){}
            }
        }
    }
}

enum TileTypes{
    SAND,
    BEACH,
    ROCK,
    WATER,
    DEEP_WATER,
    ICE,
    TEMPLE_TILE,
    GRASS,
    MOSS,
    BUSH
}