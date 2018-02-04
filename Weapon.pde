/*
    So much math in this class my head is gonna exploode!!
    Around 1/5 of the code here is from online sources, most of which was further
    edited and revised for my own purposes.
    Read if you want but it just does some transformation maths. :)
    This class takes care of the spinning stuff around each character.
*/

class Weapon {
    //Coordinates and reverse coordinates in a matrix to draw and do calculations with weapons.
    PMatrix2D coordinates = new PMatrix2D();//box coordinate system
    PMatrix2D reverseCoordinates = new PMatrix2D();//inverted coordinate system
    //Angle is in degrees.
    float angle;
    //The previous angle.
    float previousAngle;
    //How wide the weapon is.
    float weaponWidth;
    //How long the weapon is.
    float weaponLength;
    
    //Base speed of the weapon.
    float weaponBaseSwingSpeed;
    //How fast the weapon gains speed.
    float weaponAccelarationSpeed;
    //Maximum speed of the weapon.
    float weaponMaxSwingSpeed;
    //The speed of the weapon this frame.
    float weaponFinalSwingSpeed;
    
    //Owner of the weapon.
    GameCharacter owner;
    //The center of the weapon.
    float xPos, yPos;
    
    //On contact, this stores the point of contact.
    float nearestX, nearestY;
    //How far down the weapon it is hit.
    float distFromCenter;
    
    //Constructor.
    Weapon(float weaponWidth, float weaponLength, GameCharacter owner) {
        this.weaponWidth = weaponWidth;
        this.weaponLength = weaponLength;
        this.angle = random(2 * PI);
        this.owner = owner;
        this.xPos = owner.xPos;
        this.yPos = owner.yPos;
    }
    
    //Second optional constructor if it gets too cluttered.
    //See setSpeeds function below.
    Weapon(float weaponWidth, float weaponLength){
        this.weaponWidth = weaponWidth;
        this.weaponLength = weaponLength;
        this.angle = 0;
    }
    
    //Call this if you use second constructor.
    //Sets the speeds of the weapon.
    void setSpeeds(float weaponBaseSwingSpeed, float weaponAccelarationSpeed, float weaponMaxSwingSpeed){
        this.weaponBaseSwingSpeed = weaponBaseSwingSpeed;
        this.weaponAccelarationSpeed = weaponAccelarationSpeed;
        this.weaponMaxSwingSpeed = weaponMaxSwingSpeed;
        weaponFinalSwingSpeed = weaponBaseSwingSpeed;
    }
    
    //Also call this if you use second constructor.
    //Sets the owner of the weapon.
    void assignOwner(GameCharacter owner){
        this.owner = owner;
        this.xPos = owner.xPos;
        this.yPos = owner.yPos;
    }
    
    //Get the angle change from the last frame.
    float getAngleDifference(){
        float angleDifference;
        if(angle*previousAngle >= 0){
            angleDifference = abs(angle - previousAngle);
        }else{
            angleDifference = abs(angle + previousAngle);
        }
        return angleDifference;
    }
    
    //Damage is calculated by the speed of angle change times the distance.
    float getDamage() {
        return 5* nearestX * getAngleDifference();
    }
    
    //Returns to a character where to fix after getting hit.
    PVector getImmediateFixVector(GameCharacter hitTarget){
        return PVector.fromAngle(angle + hitAngle).mult(abs(hitTarget.size/2 - distFromCenter));
    }
    
    //Returns to a character where to fly after getting hit.
    PVector getBounceVector(GameCharacter hitTarget){
        return PVector.fromAngle(angle + hitAngle).mult(nearestX * getAngleDifference() * 1000 / pow(hitTarget.size, 2));
    }
    
    //Updates a weapon according to where its owner wants it to go.
    void updateWeapon(float targetAngle){
        float newAngle = 0;
        float angleDifference = angle - targetAngle;
        float frameSwingSpeed = weaponFinalSwingSpeed / frameRate;
        if(abs(angleDifference) < radians(frameSwingSpeed) || abs(angleDifference - 2 * PI) < radians(frameSwingSpeed) || abs(angleDifference + 2 * PI) < radians(frameSwingSpeed)){
            newAngle = targetAngle;
            weaponFinalSwingSpeed -= weaponAccelarationSpeed * 5 / frameRate;
        }else if((angleDifference < 0 && angleDifference > -PI) || angleDifference > PI){
            //Turning Right
            newAngle = angle + radians(frameSwingSpeed);
            weaponFinalSwingSpeed += weaponAccelarationSpeed / frameRate;
        }else if(angleDifference > 0 || angleDifference < -PI){
            //Turning Left
            newAngle = angle - radians(frameSwingSpeed);
            weaponFinalSwingSpeed += weaponAccelarationSpeed / frameRate;
        }
        weaponFinalSwingSpeed = min(weaponMaxSwingSpeed, max(weaponBaseSwingSpeed, weaponFinalSwingSpeed));
        if(abs(newAngle) > PI){
            newAngle += 2 * PI * (newAngle>0?-1:1);
        }
        previousAngle = angle;
        angle = newAngle;
        this.xPos = owner.xPos;
        this.yPos = owner.yPos;
        coordinates = new PMatrix2D();
        coordinates.translate(xPos, yPos);
        coordinates.rotate(angle);
        reverseCoordinates = coordinates.get();
        reverseCoordinates.invert();
    }
    
    //Displays the weapon.
    void displayWeapon() {
        pushMatrix();
        applyMatrix(coordinates);
        stroke(0);
        rect(0, -weaponWidth/2, weaponLength, weaponWidth);
        popMatrix();
    }
    
    //Displays a weapon without outline.
    void displayNoStrokeWeapon(){
        pushMatrix();
        applyMatrix(coordinates);
        noStroke();
        rect(1, -weaponWidth/2 + 1, weaponLength - 2, weaponWidth - 1.5);
        popMatrix();
    }
    
    //Checks if it hit a particular character.
    boolean hitChar(GameCharacter character) {
        if(owner.equals(character)){
            return false;
        }
        return getVectorFromPointToWeapon(character.xPos, character.yPos).mag() < character.size/2;
    }
    
    PVector reversedTestPoint = new PVector();//Allocate reversed point as vector.
    PVector testPoint = new PVector();//Allocate regular point as vector.
    
    float hitAngle;
    //Gets the vector from rotated weapon to a point.
    PVector getVectorFromPointToWeapon(float x, float y){
        reversedTestPoint.set(0, 0);//Reset the reverse test point.
        testPoint.set(x, y);//Set the x,y coordinates to be tested.
        //Transform the passed x,y coordinates to the reversed coordinates using matrix multiplication.
        reverseCoordinates.mult(testPoint, reversedTestPoint);
        nearestX = max(0, min(reversedTestPoint.x, weaponLength));
        nearestY = max(-weaponWidth/2, min(reversedTestPoint.y, weaponWidth/2));
        distFromCenter =  dist(reversedTestPoint.x, reversedTestPoint.y, nearestX, nearestY);
        PVector vector = new PVector(reversedTestPoint.x, reversedTestPoint.y).sub(new PVector(nearestX, nearestY));
        hitAngle = vector.heading();
        return vector;
    }
}