class CharacterData{
    GameCharacter[] characters = {};
    CharacterData(){}
    
    GameCharacter enemy;
    void addEnemies(EnemyTypes type, int amount, float xPos, float yPos){
        for(int i = 0; i < amount; i++){
            switch(type){
                case DUMMY:
                    enemy = new Enemy(xPos, yPos, 40, 0, 0, 2000, 0);
                    break;
                case BASIC_WANDER:
                    enemy = new Enemy(xPos, yPos, 50, 0.5, 2, 20, 20);
                    break;
                case BIG_TANKY_MEATY_BOI:
                    enemy = new Enemy(xPos, yPos, 75, 0.5, 2, 10000, 280);
                    break;
                case DA_BIG_BOSS:
                    enemy = new Enemy(xPos, yPos, 175, 1, 2, 80000, 280);
            }
        }
    }
    
}

enum EnemyTypes{
    DUMMY,
    BASIC_WANDER,
    BIG_TANKY_MEATY_BOI,
    DA_BIG_BOSS,
}