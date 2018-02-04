boolean wPressed, aPressed, sPressed, dPressed;
boolean qPressed, ePressed, zPressed;
void keyPressed() {
    if(!gameStarted){
        if (key == BACKSPACE) {
            if (name.length() > 0) {
                name = name.substring(0, name.length()-1);
            }
        } else if((key > 31) && (key != CODED)){
            name = name + key;
        }
    }
    switch(key) {
    case 'w':
        wPressed = true;
        break;
    case 'a':
        aPressed = true;
        break;
    case 's':
        sPressed = true;
        break;
    case 'd':
        dPressed = true;
        break;
    case 'q':
        qPressed = true;
        break;
    case 'e':
        ePressed = true;
        break;
    case 'z':
        zPressed = true;
        break;
    }
}

void keyRespond() {
    float verticalValue = 0;
    float horizontalValue = 0;
    if (wPressed) {
        verticalValue -= 1;
    }
    if (aPressed) {
        horizontalValue -= 1;
    }
    if (sPressed) {
        verticalValue += 1;
    }
    if (dPressed) {
        horizontalValue += 1;
    }
    if(qPressed){
        screenAngle += radians(120)/frameRate;
    }
    if(ePressed){
        screenAngle -= radians(120)/frameRate;
    }
    if(zPressed){
        screenAngle = 0;
    }
    PVector directionVector = new PVector(horizontalValue, verticalValue);
    mainCharacter.selfDirection = rotateVector(directionVector, -screenAngle);
}

//When keys are released set status to false.
void keyReleased() {
    switch(key) {
    case 'w':
        wPressed = false;
        break;
    case 'a':
        aPressed = false;
        break;
    case 's':
        sPressed = false;
        break;
    case 'd':
        dPressed = false;
        break;
    case 'q':
        qPressed = false;
        break;
    case 'e':
        ePressed = false;
        break;
    case 'z':
        zPressed = false;
        break;
    case 'x':
        offCenter = !offCenter;
        break;
    }
}