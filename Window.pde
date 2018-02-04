class Window {
    //Position of the screen.
    PVector position = new PVector(0, 0);
    //Width of the screen.
    float screenWidth;
    //Height of the screen
    float screenHeight;
    //The final speed of fixing the window to a position
    final float WINDOW_FIX_SPEED = 0.03;
    //The vector of where it is fixing to.
    PVector windowFixVector = new PVector(0, 0);
    
    //Constructor.
    Window(float x, float y, float screenWidth, float screenHeight) {
        this.position.x = x;
        this.position.y = y;
        this.screenWidth = screenWidth;
        this.screenHeight = screenHeight;
    }
    
    //Shake vectors array stores a lot of random vectors to shake the screen
    PVector[] shakeVectors = new PVector[0];
    int currentShakeIndex = 0;
    //Shake screen function adds more stuff to the array
    void shakeScreen(float duration, float magnitude){
        shakeVectors = new PVector[max(1, parseInt(frameRate * duration / 1000))];
        for(int i = 0; i < shakeVectors.length; i ++){
            shakeVectors[i] = PVector.random2D().mult(magnitude);
        }
        currentShakeIndex = 0;
    }
    
    //Lets the screen move towards a certain point.
    void fixScreenTo(float x, float y) {
        PVector windowMiddle = new PVector(position.x + screenWidth / 2, position.y + screenHeight / 2);
        windowFixVector = new PVector(x, y).sub(new PVector(windowMiddle.x, windowMiddle.y)).mult(0.8);
        position.add(new PVector(windowFixVector.x, windowFixVector.y).mult(100 * WINDOW_FIX_SPEED / frameRate));
        if(currentShakeIndex == shakeVectors.length){
            shakeVectors = new PVector[]{};
            currentShakeIndex = 0;
        }else{
            position.add(shakeVectors[currentShakeIndex]);
            currentShakeIndex++;
        }
    }
}