class HighScore {
    String name;
    int score;

    HighScore(String info) {
        String[] scoreInfo = split(info, ",");
        this.name = scoreInfo[0];
        this.score = parseInt(scoreInfo[1]);
    }

    String toString() {
        return name + "," + score;
    }

    void saveScores(HighScore[] scores) {
        PrintWriter output = createWriter("High Scores.txt"); 
        for (int i = 0; i < scores.length; i ++) {
            output.println(scores[i]);
        }
    }
    
    boolean before(HighScore highScore1, HighScore highScore2){
        if(highScore1.score > highScore2.score){
            return true;
        }else if(highScore2.score > highScore1.score){
            return false;
        }
        if(highScore1.name.compareTo(highScore2.name) < 0){
            //compareTo function returns negative number if second one is alphabetically before first one.
            return false;
        }else if(highScore2.name.compareTo(highScore1.name) < 0){
            return true;
        }
        return false;
    }
    

    HighScore[] sortHighScores(HighScore[] listOfScores){
        int arrayLength = listOfScores.length;
        int numSegments = arrayLength;
        HighScore[][] segments = new HighScore[numSegments][];
        for(int i = 0; i < arrayLength; i ++){
            segments[i] = new HighScore[] {listOfScores[i]};
        }
        while(numSegments != 1){
            HighScore[][] newSegments = new HighScore[floor(numSegments/2)][];
            for(int i = numSegments; i > 1; i -= 2){ //Will stop when i == 1 or 0
                newSegments[(numSegments - i)/2] = merge(segments[i - 1], segments[i - 2]);
            }
            if(numSegments % 2 == 1){
                newSegments[floor(numSegments/2) - 1] = merge(newSegments[floor(numSegments/2) - 1], segments[0]);
            }
            numSegments = floor(numSegments/2);
            arrayCopy(newSegments, segments);
        }
        return segments[0];
    }
    

    private HighScore[] merge(HighScore[] pile1, HighScore[] pile2){
        HighScore[] finalArray = {};
        int smaller = 0;
        while(pile1.length != 0 && pile2.length != 0){
            smaller = pile1[0].score > pile2[0].score? 2:1;
            finalArray = (HighScore[]) append(finalArray, smaller==1?pile1[0]:pile2[0]);
            if(smaller == 1){
                pile1 = removeItemByIndex(0, pile1);
            }else{
                pile2 = removeItemByIndex(0, pile2);
            }
        }
        finalArray = (HighScore[])concat(finalArray, smaller==1?pile2:pile1);
        return finalArray;
    }
    
    private HighScore[] removeItemByIndex(int index, HighScore[] array) {
        int arrayLength = array.length;
        HighScore[] prefix = new HighScore[index];
        HighScore[] suffix = new HighScore[arrayLength - index - 1];
        arrayCopy(array, 0, prefix, 0, index);
        arrayCopy(array, index + 1, suffix, 0, arrayLength - index - 1);
        return (HighScore[])concat(prefix, suffix);
    }
}