//Optical Character Recognition, July
//Stejara Dinulescu

Table table;
int picNum = 70;
int picCount = 70;
int count = 0;
int horzCount = 0;
Input input = new Input("Test_A.png"); //"input" object
String stringPoints = " ";
String name = " ";

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
    String verticalPoints = table.getString(i, "Points");
    String horizontalPoints = table.getString(i, "HorzPoints");
    String[] items = verticalPoints.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
    String[] horzItems = horizontalPoints.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
    int[] results = new int[items.length];
    int[] horzResults = new int[horzItems.length];
    stringToInt(results, items);
    stringToInt(horzResults, horzItems);
    for (int a = 0; a < input.vPoints.size(); a++) { //checks for how many numbers match
      if (input.vPoints.get(a) == results[a]) { 
        count++; //increment this variable for every match
      }
    }
    for (int a = 0; a < input.hPoints.size(); a++) {
      if (input.hPoints.get(a) == horzResults[a]) { 
        horzCount++; //increment this variable for every match
      }
    }
    if (count >= 6) { 
      println("Vert Character Match: " + table.getString(i, "Name") + "; Count Number: " + count);
  }
    if (horzCount >= 6) {
      println("Horz Character Match: " + table.getString(i, "Name") + "; Count Number: " + horzCount);
    }
    
    if (count >= 6 && horzCount >= 6) {
      name = table.getString(i, "Name");
    }
    count = 0;
    horzCount = 0;
  }
}

void stringToInt(int[] array, String[] arr) {
  for (int j = 0; j < arr.length; j++) {
    array[j] = Integer.parseInt(arr[j]);
  }
}

void setup() {
  size(500, 500);
  background(255);
  table = loadTable("Name.csv", "header");
  input.load();
  vertSweep(input);
  stringPoints = "v:" + stringPoints + input.vPoints;
  horzSweep(input);
  stringPoints = stringPoints + " h: " + input.hPoints;
  println(stringPoints);

  /* //Table Setup
   table.setInt(picCount, "InPoint Count", input.inPoints);
   table.setInt(picCount, "OutPoint Count", input.outPoints);
   table.setString(picCount, "Points", stringPoints);
   table.setString(picCount, "HorzPoints", stringPoints);
   saveTable(table, "data/Name.csv");
   */
  
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
  for (int i = 0; i < input.vOutPoint.size(); i++) {
    point(input.vOutPoint.get(i).x, input.vOutPoint.get(i).y);
  }
  stroke(0, 255, 0);
  for (int i = 0; i < input.hInPoint.size(); i++) {
    point(input.hInPoint.get(i).x, input.hInPoint.get(i).y);
  }
  for (int i = 0; i < input.hOutPoint.size(); i++) {
    point(input.hOutPoint.get(i).x, input.hOutPoint.get(i).y);
  }
  
  
  fill(0);
  if (name == " ") {
    textSize(25);
    text("Character match: no absolute match", 10, 30);
  } else {
    textSize(25);
    text("Character Match: " + name, 10, 30);
  }
}