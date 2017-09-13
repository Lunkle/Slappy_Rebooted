int canvasWidth = 800;
int canvasHeight = 600;

MainCharacter mainCharacter;

void setup() {
  surface.setSize(canvasWidth, canvasHeight);
  mainCharacter = new MainCharacter(canvasWidth/2, canvasHeight/2);
}

void draw() {
  background(255);
  mainCharacter.updateChar(); 
}

//void makeBitmap(bitmap, x, y, squareSize) {
//  for(i = 0; i < bitmap.length; i++){
//    for (j = 0; j < bitmap[i].length; j++){
//      print("hi")
//    }
//  }
//}
