class MainCharacter{
  float charcterStartingPositionX;
  float characterStartingPositionY;
  float characterPositionX;
  float characterPositionY;
  float originalMouseAngle = 0;
  float mouseAngleTotal;
  float weaponAngle = 0; //Records radian weapon is at
  float swingSpeed = 5; //This is in degrees
  final float WINDOW_FIX_SPEED = 0.1;
  
  MainCharacter(int startX, int startY){
    charcterStartingPositionX = startX;
    characterStartingPositionY = startY;
    characterPositionX = charcterStartingPositionX;
    characterPositionY = characterStartingPositionY;
  }
  
  void updateChar(){
    mouseAngleTotal += atan2(mouseY - characterPositionX, mouseX - characterPositionX);
    float angleDifference = weaponAngle - mouseAngleTotal;
    if(angleDifference < 0){
      print("Rotate Left");
      weaponAngle -= min(radians(swingSpeed), -angleDifference);
    }else if(angleDifference > 0){
      print("Rotate Right");
      weaponAngle += min(radians(swingSpeed), angleDifference);
    }
    println("Mouse Angle: " + parseInt(mouseAngleTotal), "Weapon Angle: " + parseInt(weaponAngle), "Difference: " + parseInt(angleDifference));
    characterPositionX +=  (charcterStartingPositionX - characterPositionX) * WINDOW_FIX_SPEED;
    pushMatrix();
    translate(characterPositionX, characterPositionY);
    rotate(weaponAngle - HALF_PI);
    rect(-5, 10, 10, 50);
    popMatrix();
    ellipse(characterPositionX, characterPositionY, 22, 22);
    originalMouseAngle = mouseAngleTotal;
  }
  
}