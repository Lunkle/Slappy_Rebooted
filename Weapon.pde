class Weapon{
    PMatrix2D coordinates = new PMatrix2D();//box coordinate system
    PMatrix2D reverseCoordinates = new PMatrix2D();//inverted coordinate system
    //Angle is in degrees
    float angle;
    float previousAngle;
    float weaponWidth;
    float weaponLength;
    
    float nearestX;
    float nearestY;
    
    //Damage is calculated by the speed of angle change times the distance 
    
    Weapon(float weaponWidth, float weaponLength, float angle){
        this.weaponWidth = weaponWidth;
        this.weaponLength = weaponLength;
        this.angle = angle;
    }
    
    boolean checkHitEnemy(GameCharacter enemy){
        if(hitChar(enemy.xPos, enemy.yPos, enemy.size/2)){
            return true;
        }
        return false;
    }
    
    void displayWeapon(float xPos, float yPos){
        coordinates = new PMatrix2D();
        pushMatrix();
        coordinates.translate(xPos, yPos);
        coordinates.rotate(angle);
        applyMatrix(coordinates);
        reverseCoordinates = coordinates.get();
        reverseCoordinates.invert();
        rect(0, -weaponWidth/2, weaponLength, weaponWidth);
        popMatrix();
    }
    
    PVector reversedTestPoint = new PVector();//allocate reversed point as vector
    PVector testPoint = new PVector();//allocate regular point as vector
    boolean hitChar(float x, float y, float r) {
        reversedTestPoint.set(0, 0);//reset the reverse test point
        testPoint.set(x, y);//set the x,y coordinates we want to test
        //transform the passed x,y coordinates to the reversed coordinates using matrix multiplication
        reverseCoordinates.mult(testPoint, reversedTestPoint);
        nearestX = max(0, min(reversedTestPoint.x, weaponLength));
        nearestY = max(-weaponWidth/2, min(reversedTestPoint.y, weaponWidth/2));
        return dist(reversedTestPoint.x, reversedTestPoint.y, nearestX, nearestY) < r;
    }
    
    PVector getHitPoint(){
        return new PVector(nearestX, nearestY);
    }
}