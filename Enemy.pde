class Enemy extends GameCharacter{
    float wanderSpeed;
    int characterIndex;
    
    PVector selfDirection;
    
    Enemy(float x, float y, float size, float wanderSpeed, float chaseSpeed, int maxHealth, float weaponLength){
        super(x, y, chaseSpeed, size);
        this.wanderSpeed = wanderSpeed;
        this.maxHealth = maxHealth;
        weapon = new Weapon(20, weaponLength, 0);
        init();
    }
    
    void init(){
        characterIndex = characterData.characters.length;
        characterData.characters = (GameCharacter[])append(characterData.characters, this);
        currentHealth = maxHealth;
    }
    
    void displayCharacter(){
        super.displayCharacter();
    }
    
    PVector wanderVector = PVector.random2D();
    int wanderTimer = parseInt(random(0, 100));
    
    void updateCharacter(){
        fill(lerpColor(color(0, 102, 153), color(204, 102, 0), currentHealth/float(maxHealth)));
        wanderTimer += 200/frameRate;
        if(wanderTimer >= 100){
            wanderTimer = 0;
            wanderVector = PVector.random2D();
        }
        move(wanderVector, wanderSpeed);
        for(int i = 0; i < characterData.characters.length; i++){
            if(i != this.characterIndex){
                if(collidedWithCharacter(characterData.characters[i])){
                    PVector fixVector = getFixVectorFromChar(characterData.characters[i]);
                    xPos += fixVector.x;
                    yPos += fixVector.y;
                }
            }
        }
    }
    
    void removeIfDead(){
        if(currentHealth <= 0){
            characterData.characters = removeCharacterByIndex(characterIndex, characterData.characters);
            smallImpact.play();
            currentScore.score+=maxHealth;
        }
    }
    
    void wander(){
        float angle = random(2*PI);
        this.xPos += cos(angle) * wanderSpeed;
        this.yPos += sin(angle) * wanderSpeed;
    }
    
    void chase(float x, float y){
        float angle = atan2(this.yPos - y, this.xPos - x);
        this.xPos += cos(angle) * speed;
        this.yPos += sin(angle) * speed;
    }
}