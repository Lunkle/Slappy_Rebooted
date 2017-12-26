class Window {
    PVector position = new PVector(0, 0);
    float screenWidth;
    float screenHeight;
    final float WINDOW_FIX_SPEED = 0.03;
    PVector windowFixVector = new PVector(0, 0);

    Window(float x, float y, float screenWidth, float screenHeight) {
        this.position.x = x;
        this.position.y = y;
        this.screenWidth = screenWidth;
        this.screenHeight = screenHeight;
    }
    
    PVector[] shakeVectors = new PVector[0];
    int currentShakeIndex = 0;
    void shakeScreen(float duration, float magnitude){
        shakeVectors = new PVector[parseInt(frameRate * duration / 1000)];
        for(int i = 0; i < shakeVectors.length; i ++){
            shakeVectors[i] = PVector.random2D().mult(magnitude);
        }
        currentShakeIndex = 0;
    }
    
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