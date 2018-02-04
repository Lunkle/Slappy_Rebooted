class MainCharacter extends GameCharacter{
    float originalMouseAngle = 0;
    float weaponWidth = 20;
    float weaponLength = 120;
    float swingMaxSpeed = 20; //This is in degrees
    float size = 100;
    boolean dead = false;
    
    MainCharacter(CharacterData cData, float startX, float startY){
        super(cData, startX, startY, 5, 100, 2000, color(216, 131, 2));
        init();
    }
    
    void init(){
        target = this;
        MainCharacter[] self = {this};
        currentLevel.characterData.friendlyCharacters = (GameCharacter[])concat(self, currentLevel.characterData.friendlyCharacters);
        //println();
        weaponAngle = atan2(rotatedMousePosition.y - yPos, rotatedMousePosition.x - xPos);
        weapon = new Weapon(weaponWidth, weaponLength, this);
        weapon.setSpeeds(200, 100, 500);
    }
    
    void updateCharacter(){
        originalMouseAngle = weaponAngle;
        weaponAngle = atan2(rotatedMousePosition.y + window.position.y - yPos, rotatedMousePosition.x + window.position.x - xPos);
        super.updateCharacter();
        if(currentHealth <= 0 && !dead){
            dead = true;
            loseGame();
        }
    }
    
    void displayCharacter(){
        noStroke();
        super.displayCharacter();
    }
}