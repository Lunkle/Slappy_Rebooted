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

    void saveScores() {
        if(this.score > highScoresList[9].score){
            highScoresList = (HighScore[])append(shorten(highScoresList), this);
        }
        highScoresList = sortHighScores(highScoresList);
        PrintWriter output = createWriter("HighScores.txt"); 
        for (int i = 0; i < highScoresList.length; i ++) {
            output.println(highScoresList[i]);
        }
        output.flush(); // Writes the remaining data to the file.
        output.close(); // Finishes the file.
    }
    
    boolean before(HighScore otherHighScore){
        if(otherHighScore.score > this.score){
            return true;
        }else if(this.score > otherHighScore.score){
            return false;
        }
        //CompareTo function returns negative number if second one is alphabetically before first one.
        if(otherHighScore.name.compareTo(this.name) < 0){
            return true;
        }else if(this.name.compareTo(otherHighScore.name) < 0){
            return false;
        }
        return false;
    }
    
    HighScore[] sortHighScores(HighScore[] array){
        for(int i = 0; i < array.length; i++){
            for(int j = 0; j < array.length; j++){
                if(array[j].before(array[i])){
                    array = swap(array, i, j);
                }
            }
        }
        return array;
    }
    
    HighScore[] swap(HighScore[] array, int index1, int index2){
        HighScore c = array[index1];
        array[index1] = array[index2];
        array[index2] = c;
        return array;
    }
}