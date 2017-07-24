//Optical Character Recognition, July
//Stejara Dinulescu

Table table;
int picNum = 71;
int picCount = 70;
int count = 0;
Input input = new Input("Test_Bi.png"); //"input" object
String stringPoints = " ";

void vertSweep(Input list) { //checks with line sweeps down the picture screen
  for (int j = 50; j < list.image.width; j += 50) { //where lines start down the picture
    for (int i = 0; i < list.image.height - 1; i++) { //moves all the way down the picture from top to bottom
      if (list.image.get(j, i) != list.image.get(j, i+1)) { // two cases, in point or out point
        if (list.image.get(j, i+1) != color(255)) { //when it changes from white to black
          list.vInPoint.add(new PVector(j, i+1)); //"in" point created when the pixel color changes
          list.vInPoints++; //will increment everytime it moves out
        }
        if (list.image.get(j, i+1) == color(255)) { //when it changes from black to white
          list.vOutPoint.add(new PVector(j, i+1)); //"out" point created when pixel color changes
          list.vOutPoints++; //will increment everytime it moves out
          list.vPointCount++;
        }
      }
    }
    list.vPoints.add(list.vPointCount);
    list.vPointCount = 0;
  }
}

void horzSweep(Input list) { //checks with line sweeps across the picture screen
  for (int i = 50; i < list.image.height; i += 50) {
    for (int j = 0; j < list.image.width-1; j++) {
      if (list.image.get(j, i) != list.image.get(j+1, i)) {
        if (list.image.get(j+1, i) != color(255)) { 
          list.hInPoint.add(new PVector(j+1, i)); 
          list.hInPoints++;
        }
        if (list.image.get(j+1, i) == color(255)) { 
          list.hOutPoint.add(new PVector(j+1, i)); 
          list.hOutPoints++;
          list.hPointCount++;
        }
      }
    }
    list.hPoints.add(list.hPointCount);
    list.hPointCount = 0;
  }
}


void characterMatch() {
  for (int i = 0; i < picNum; i++) { //convert all strings in database to int arrays
    String points = table.getString(i, "Points");
    String[] items = points.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
    int[] results = new int[items.length];
    stringToInt(results, items);
    for (int a = 0; a < input.vPoints.size(); a++) { //checks for how many numbers match
      if (input.vPoints.get(a) == results[a]) { 
        count++; //increment this variable for every match
      }
    }
    if (count >= 6) { 
      println("Character Match: " + table.getString(i, "Name") + "; Count Number: " + count);
    } else {
      changeInput(1);
      countMatches(results);
      if (count >= 6) { 
        println("Character Match: " + table.getString(i, "Name") + "; Count Number: " + count);
      } else {
        changeInput(-2);
        countMatches(results);
        if (count >= 6) { 
          println("Character Match: " + table.getString(i, "Name") + "; Count Number: " + count);
        }
      }
    }
    count = 0;
  }
}

void stringToInt(int[] array, String[] arr) {
  for (int j = 0; j < arr.length; j++) {
    array[j] = Integer.parseInt(arr[j]);
  }
}

void countMatches(int[] array) {
  for (int a = 0; a < input.vPoints.size(); a++) { //checks for how many numbers match
    if (input.vNewPoints.get(a) == array[a]) { 
      count++; //increment this variable for every match
    }
  }
}

void changeInput(int increment) {
  input.vNewPoints.clear();
  for (int b = 0; b < input.vPoints.size(); b++) {
    input.vNewPoints.add(input.vPoints.get(b) + increment);
  }
  count = 0;
}

void setup() {
  size(500, 500);
  background(255);
  table = loadTable("Name.csv", "header");
  input.load();
  vertSweep(input);
  stringPoints = stringPoints + input.vPoints;
  println(stringPoints);

  /* //Table Setup
   table.setInt(picCount, "InPoint Count", input.inPoints);
   table.setInt(picCount, "OutPoint Count", input.outPoints);
   table.setString(picCount, "Points", stringPoints);
   saveTable(table, "data/Name.csv");
   */
  //println(table.findRow(stringPoints, "Points").getString("PicNum")); -> NEED TO FIND A WAY TO IGNORE ONLY SPECIFIC NUMBERS
  characterMatch();
  println("Done");
}

void draw() {
  input.display();
  strokeWeight(5);
  stroke(0, 0, 255);
  for (int i = 0; i < input.vInPoint.size(); i++) {
    point(input.vInPoint.get(i).x, input.vInPoint.get(i).y);
  }
  stroke(0, 255, 0);
  for (int i = 0; i < input.vOutPoint.size(); i++) {
    point(input.vOutPoint.get(i).x, input.vOutPoint.get(i).y);
  }
}