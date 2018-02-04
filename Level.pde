class Level{
    TileData map;
    CharacterData characterData;
    int startX, startY;
    int endX, endY;
    boolean over = false;
    
    Level(TileData map, CharacterData characterData, int startX, int startY, int endX, int endY){
        this.map = map;
        this.characterData = characterData;
        this.startX = startX;
        this.startY = startY;
        this.endX = endX;
        this.endY = endY;
    }
    
    boolean characterOnEndTile(GameCharacter character){
        Tile onTile = map.getOnTile(character);
        if(onTile.tileGridX == endX && onTile.tileGridY == endY){
            return true;
        }
        return false;
    }
}