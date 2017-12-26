class Tile{
    int tileGridX;
    int tileGridY;
    TileTypes tileType;
    
    public Tile(TileTypes tileType, int tileX, int tileY){
        this.tileGridX = tileX;
        this.tileGridY = tileY;
        this.tileType = tileType;
    }
    
    String toString(){
        return this.tileType.toString();
    }
    
    void drawTile(){
        fill(getTileTypeColour(tileType));
        rect(tileGridX * TileData.TILE_SIZE - 1, tileGridY * TileData.TILE_SIZE - 1, TileData.TILE_SIZE + 2, TileData.TILE_SIZE + 2);
    }
    
    private color getTileTypeColour(TileTypes typeOfTile){
        switch(typeOfTile){
            case SAND:
                return color(194, 173, 128);
            case BEACH:
                return color(244, 220, 181);
            case ROCK:
                return color(129, 108, 91);
            case WATER:
                return color(0, 151, 172);
            case DEEP_WATER:
                return color(0, 121, 150);
            case ICE:
                return color(200, 200, 250);
            case TEMPLE_TILE:
                return color(147, 133, 73);
            case GRASS:
                return color(18, 230, 3);
            case MOSS:
                return color(18, 173, 42);
            case BUSH:
                return color(52, 52, 0);
        }
        return color(0, 0, 0);
    }
}