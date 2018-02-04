/*
    The chaacter data class is responsible for dealing with interactions of game characters and displaying them.
    In addition, it is able to spawn different enemies and stores the parameters for each type.
*/
class CharacterData {
    GameCharacter[] characters = {};
    //All the friendly characters are still in the characters array.
    //Just used to simplify pathfinding methods. TODO: add friendly npc's.
    GameCharacter[] friendlyCharacters = {};

    void updateAndDisplayCharacters() {
        //Updating the main character.
        mainCharacter.updateCharacter();
        mainCharacter.displayCharacter();
        for (int j = 0; j < currentLevel.characterData.characters.length; j++) {
            if (mainCharacter.weapon.hitChar(characters[j]) == true) {
                window.shakeScreen(1, 1);//Shake the screen
                characters[j].currentHealth -= mainCharacter.weapon.getDamage();
                PVector immediateFixVector = mainCharacter.weapon.getImmediateFixVector(characters[j]);
                characters[j].xPos += immediateFixVector.x;
                characters[j].yPos += immediateFixVector.y;
                PVector bounceVector = mainCharacter.weapon.getBounceVector(characters[j]);
                characters[j].addDirectionForce(bounceVector, 0.1);
            }
            if (currentLevel.characterData.characters[j] instanceof Enemy) {
                ((Enemy)characters[j]).removeIfDead();
            }
        }
        //Updating and displaying all the enemies.
        for (int i = 1; i < currentLevel.characterData.characters.length; i++) {
            if(characters[i].equals(mainCharacter)){
                println(i);
            }
            characters[i].updateCharacter();
            characters[i].displayCharacter();
            for (int j = 0; j < currentLevel.characterData.characters.length; j++) {
                if (characters[i].weapon.hitChar(characters[j]) == true) {
                    if (!(characters[j] instanceof Enemy)) {
                        characters[j].currentHealth -= characters[i].weapon.getDamage();
                    }
                    PVector immediateFixVector = characters[i].weapon.getImmediateFixVector(characters[j]);
                    characters[j].xPos += immediateFixVector.x;
                    characters[j].yPos += immediateFixVector.y;
                    PVector bounceVector = characters[i].weapon.getBounceVector(characters[j]);
                    characters[j].addDirectionForce(bounceVector, 0.1);
                }
                if (currentLevel.characterData.characters[j] instanceof Enemy) {
                    ((Enemy)characters[j]).removeIfDead();
                }
            }
        }
    }

    GameCharacter enemy;
    //Add a specified amount of enemies at a certain point.
    void addEnemies(EnemyTypes type, int amount, float xPos, float yPos) {
        Weapon weapon;
        for (int i = 0; i < amount; i++) {
            switch(type) {
            case DUMMY:
                weapon = new Weapon(0, 0);
                enemy = new Enemy(this, xPos, yPos, 40, 0, 0, 200, weapon,0);
                break;
            case BASIC_WANDER:
                weapon = new Weapon(10, 40);
                weapon.setSpeeds(50, 50, 100);
                enemy = new Enemy(this, xPos, yPos, 50, 1.2, 3.6, 20, weapon, 1700);
                break;
            case BIG_TANKY_MEATY_BOI:
                weapon = new Weapon(30, 50);
                weapon.setSpeeds(50, 5, 100);
                enemy = new Enemy(this, xPos, yPos, 75, 1, 2, 2000, weapon, 1000);
                break;
            case DA_BIG_BOSS:
                weapon = new Weapon(80, 100);
                weapon.setSpeeds(50, 0.5, 75);
                enemy = new Enemy(this, xPos, yPos, 150, 1, 2, 10000, weapon, 800);
            case FAST_THINGIES:
                weapon = new Weapon(5, 15);
                weapon.setSpeeds(50, 0.5, 75);
                enemy = new Enemy(this, xPos, yPos, 20, 1.2, 2, 10, weapon, 2500);
            }
        }
    }
}

enum EnemyTypes {
    DUMMY, 
    BASIC_WANDER, 
    BIG_TANKY_MEATY_BOI, 
    DA_BIG_BOSS,
    FAST_THINGIES
}