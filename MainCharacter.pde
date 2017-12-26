class MainCharacter extends GameCharacter{
    float originalMouseAngle = 0;
    float mouseAngle;

    float weaponLength = 120;
    float swingMaxSpeed = 2; //This is in degrees
    float size = 100;
    
    MainCharacter(int startX, int startY){
        super(startX, startY, 5, 100);
        characterData.characters = (GameCharacter[])append(characterData.characters, (GameCharacter)this);
        mouseAngle = atan2(mouseY - yPos, mouseX - xPos);
        weapon = new Weapon(20, weaponLength, 0);
    }
    
    void updateCharacter(){
        weapon.angle = determineSpinDirection();
    }
    
    void displayCharacter(){
        noStroke();
        fill(216, 31, 42);
        pushMatrix();
        weapon.displayWeapon(xPos, yPos);
        popMatrix();
        super.displayCharacter();
        originalMouseAngle = mouseAngle;
    }
    
    float determineSpinDirection(){
        float newWeaponAngle = 0;
        mouseAngle = atan2(mouseY + window.position.y - yPos, mouseX + window.position.x - xPos);
        float angleDifference = weapon.angle - mouseAngle;
        float frameSwingSpeed = (100/frameRate) * swingMaxSpeed;
        if(abs(angleDifference) < radians(frameSwingSpeed) || abs(angleDifference - 2 * PI) < radians(frameSwingSpeed) || abs(angleDifference + 2 * PI) < radians(frameSwingSpeed)){
            newWeaponAngle = mouseAngle;
        }else if((angleDifference < 0 && angleDifference > -PI) || angleDifference > PI){
            //Turning Right
            newWeaponAngle = weapon.angle + radians(frameSwingSpeed);
        }else if(angleDifference > 0 || angleDifference < -PI){
            //Turning Left
            newWeaponAngle = weapon.angle - radians(frameSwingSpeed);
        }
        newWeaponAngle = newWeaponAngle % (2 * PI);
        return newWeaponAngle;
    }
      
}