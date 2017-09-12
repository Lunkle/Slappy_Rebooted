int canvasWidth = 800;
int canvasHeight = 600;

void setup() {
  surface.setSize(canvasWidth, canvasHeight);
}

void draw() {
  float angle = atan2(mouseY - canvasHeight/2, mouseX - canvasWidth/2);

  background(255);
  pushMatrix();
  translate(canvasWidth/2, canvasHeight/2);
  rotate(angle - HALF_PI);
  rect(-5, 10, 10, 50);
  popMatrix();
  ellipse(canvasWidth/2, canvasHeight/2, 22, 22);
}

void makeBitmap(bitmap, x, y, squareSize) {
  for(i = 0; i < bitmap.length; i++){
    for (j = 0; j < bitmap[i].length; j++){
      rect()
    }
  }
}