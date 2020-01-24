boolean showPathfinding = false;
class Enemy extends GameCharacter {
    int wanderTimer = parseInt(random(0, 100));

    Enemy(CharacterData cData, float x, float y, float size, float wanderSpeed, float chaseSpeed, int maxHealth, Weapon weapon, float detectionRange) {
        super(cData, x, y, chaseSpeed, size, maxHealth, color(0, 102, 153));
        this.wanderSpeed = wanderSpeed;
        this.weapon = weapon;
        this.targetDetectionRange = detectionRange;
        init();
    }

    void init() {
        weapon.assignOwner(this);
    }

    void displayCharacter() {
        super.displayCharacter();
    }

    void updateCharacter() {
        if (target != null) {
            //Target is already chosen.
            pathfind(currentLevel.map.getOnTile(this), currentLevel.map.getOnTile(mainCharacter));
            //This will check if lost target
            if (distToCharacterSquared(target) > pow(targetDetectionRange, 2)) {
                target = null;
            }
        }
        if (target == null) {
            //Target is not chosen and/or out of range.
            wanderTimer += 1000/frameRate;
            if (wanderTimer >= 1000) {
                wanderTimer = 0;
                selfDirection = PVector.random2D();
            }
            selectTarget();
        }
        weaponAngle = atan2(mainCharacter.yPos - yPos, mainCharacter.xPos - xPos) + random(-QUARTER_PI, QUARTER_PI)/2;
        super.updateCharacter();
    }

    void removeIfDead() {
        if (currentHealth <= 0) {
            currentLevel.characterData.characters = removeCharacterByIndex(characterIndex, currentLevel.characterData.characters);
            try{
                smallImpact.play();
            }catch(NullPointerException e){}
            currentScore.score+=maxHealth;
        }
    }

    void selectTarget() {    
        int shortestDistanceCharIndex = 0;
        float shortestDistance = distToCharacterSquared(currentLevel.characterData.friendlyCharacters[0]);
        for (int i = 1; i < currentLevel.characterData.friendlyCharacters.length; i++) {
            float distance = distToCharacterSquared(currentLevel.characterData.friendlyCharacters[i]);
            if (distance < shortestDistance) {
                shortestDistanceCharIndex = i;
                shortestDistance = distance;
            }
        }
        if (shortestDistance < pow(targetDetectionRange, 2)) {
            target = currentLevel.characterData.friendlyCharacters[shortestDistanceCharIndex];
        }
    }

    void chase(PVector target) {
        PVector direction = target.sub(new PVector(this.xPos, this.yPos));
        move(direction, speed);
    }

    boolean foundTarget = true;
    ////Here we will implement A* Search algorithm.
    void pathfind(Tile start, Tile goal) {
        stroke(0);
        strokeWeight(5);
        HashMap<Float, Tile> priorityFrontier = new HashMap<Float, Tile>();
        HashMap<Tile, Tile> cameFrom = new HashMap<Tile, Tile>();
        HashMap<Tile, Float> costSoFar = new HashMap<Tile, Float>();
        priorityFrontier.put(0.0, start);
        cameFrom.put(start, null);
        costSoFar.put(start, 0.0);
        while (!priorityFrontier.isEmpty()) {
            Tile current = priorityFrontier.remove(Collections.min(priorityFrontier.keySet()));
            if (current == goal) {
                foundTarget = true;
                break;
            } else {
                foundTarget = false;
            }
            Tile[] neighbors = currentLevel.map.neighbors(current);
            for (int i = 0; i < neighbors.length; i ++) {
                Tile neighbor = neighbors[i];
                if (neighbor.walkable == true) {
                    float newCost = costSoFar.get(current) + currentLevel.map.getCost(current, neighbor);
                    if (!costSoFar.containsKey(neighbor)) {
                        costSoFar.put(neighbor, newCost);
                        float priority = newCost + currentLevel.map.getCost(goal, neighbor);
                        priorityFrontier.put(priority, neighbor);
                        cameFrom.put(neighbor, current);
                        if (showPathfinding) {
                            line(neighbor.getCenter().x, neighbor.getCenter().y, current.getCenter().x, current.getCenter().y);
                            fill(216, 131, 2);
                            ellipse(neighbor.getCenter().x, neighbor.getCenter().y, 20, 20);
                            fill(0, 102, 153);
                            ellipse(current.getCenter().x, current.getCenter().y, 20, 20);
                        }
                    }
                }
            }
        }
        if (foundTarget) {
            fill(0, 0, 255);
            Tile trace = goal;
            while (true) {
                Tile next = cameFrom.get(trace);
                if (next == start) {
                    selfDirection = currentLevel.map.getVector(start, trace);
                    break;
                } else if (next == null) {
                    chase(start.getCenter());
                    break;
                }
                if (showPathfinding) {
                    line(next.getCenter().x, next.getCenter().y, trace.getCenter().x, trace.getCenter().y);
                    ellipse(trace.getCenter().x, trace.getCenter().y, 20, 20);
                }
                trace = next;
            }
            if (showPathfinding) {
                line(start.getCenter().x, start.getCenter().y, trace.getCenter().x, trace.getCenter().y);
                ellipse(trace.getCenter().x, trace.getCenter().y, 20, 20);
                fill(255, 0, 0);
                ellipse(start.getCenter().x, start.getCenter().y, 20, 20);
                fill(0, 255, 0);
                ellipse(goal.getCenter().x, goal.getCenter().y, 20, 20);
            }
        } else {
            println("AAAAAAAAAAAAAAAAAAAH");
        }
    }
}
