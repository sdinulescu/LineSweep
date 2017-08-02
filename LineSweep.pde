//Optical Character Recognition, July
//Stejara Dinulescu

Table table; //database table
int picNum = 70; //number of pictures in the hiragana database
int picCount = 13; //used for cycling through database pictures when putting them in the "name" database .csv file
int count = 0; //counts vertical in/out point matches
int horzCount = 0; //counts horizontal in/out point matches
Input input = new Input("Test_Ge.png"); //"input" object created
String vstringPoints = " "; //used to convert the vertical in/out point array into a string for database
String hstringPoints = " "; //used to convert the horizontal in/out point array into a string for database
String name = " "; //variable to store name of a character match to draw later
int[] v = new int[picNum]; //array that stores the vertical count matches for the test character against each database character
int[] h = new int[picNum]; //array that stores the horizontal count matches for the test character against each database character
int vlargest = 0; //largest vertical count match
int hlargest = 0; //largest horizontal count match

void vertSweep(Input list) { //checks with line sweeps down the picture screen
  for (int j = 10; j < list.image.width; j += 10) { //where lines start down the picture
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
  for (int i = 10; i < list.image.height; i += 10) {
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
  for (int i = 0; i < picNum; i++) { //convert all strings in database to int arrays in order to match with the test character
    String verticalPoints = table.getString(i, "Points");
    String horizontalPoints = table.getString(i, "HorzPoints");
    String[] items = verticalPoints.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
    String[] horzItems = horizontalPoints.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
    int[] results = new int[items.length];
    int[] horzResults = new int[horzItems.length];
    stringToInt(results, items);
    stringToInt(horzResults, horzItems);
    for (int a = 0; a < input.vPoints.size(); a++) { //checks for how many numbers match vertically
      if (input.vPoints.get(a) == results[a]) { 
        count++; //increment this variable for every vertical match
      }
    }
    for (int a = 0; a < input.hPoints.size(); a++) { //checks for how many nubmers match horizontally
      if (input.hPoints.get(a) == horzResults[a]) { 
        horzCount++; //increment this variable for every horizontal match
      }
    }
    v[i] = count; //fill an array with the number of vertical matches the test character has with each database character
    h[i] = horzCount; //fill an array with the number of horizontal matches the test character has with each database character
    count = 0; //reset to zero for the next database image
    horzCount = 0; //reset to zero for the next database image
  } 
  for (int i = 0; i < picNum; i++) { 
    if (v[i] > vlargest) {//find the largest vertical match
      vlargest = v[i];
    }
    if (h[i] > hlargest) {//find the largest horizontal match
      hlargest = h[i];
    }
  }
  println("vlargest: " + vlargest); //prints the largest number match (vertical)
  println("hlargest: " + hlargest); //prints the largest number match (horizontal)
  for (int i = 0; i < picNum; i++) {
    if (vlargest == v[i] && hlargest == h[i]) { //if largest horizontal match and largest vertical match are the same character, then it is an absolute match
      println("Match: " + table.getString(i, "Name"));
      name = table.getString(i, "Name");
    } else if (vlargest == v[i]) { //print the characters with the largest vertical matches
      println("V: " + table.getString(i, "Name"));
    } else if (hlargest == h[i]) { //print the characters with the largest horizontal matches
      println("H: " + table.getString(i, "Name"));
    }
  }
}

void stringToInt(int[] array, String[] arr) { //converts string array to an integer array for checking
  for (int j = 0; j < arr.length; j++) {
    array[j] = Integer.parseInt(arr[j]);
  }
}

void setup() {
  size(500, 500);
  background(255);
  table = loadTable("Name.csv", "header");
  input.load(); //load the test image
  vertSweep(input); //analyze test image vertically
  vstringPoints = vstringPoints + input.vPoints; //array of vertical in out points
  //println("V: " + vstringPoints);
  horzSweep(input);
  hstringPoints = hstringPoints + input.hPoints; //array of horizontal in out points
  //println("H: " + hstringPoints);
//Table Setup
  //table.setInt(picCount, "InPoint Count", input.vInPoints);
  //table.setInt(picCount, "OutPoint Count", input.vOutPoints);
  //table.setString(picCount, "Points", vstringPoints);
  //table.setString(picCount, "HorzPoints", hstringPoints);
  //saveTable(table, "data/Name.csv");
  characterMatch(); //matches the test character to a character in the database
  println("Done");
}

void draw() {
  input.display();
  strokeWeight(5);
  stroke(0, 0, 255);
  for (int i = 0; i < input.vInPoint.size(); i++) { //draws vertical in points
    point(input.vInPoint.get(i).x, input.vInPoint.get(i).y);
  }
  for (int i = 0; i < input.vOutPoint.size(); i++) { //draws vertical out points
    point(input.vOutPoint.get(i).x, input.vOutPoint.get(i).y);
  }
  stroke(0, 255, 0);
  for (int i = 0; i < input.hInPoint.size(); i++) { //draws horizontal in points
    point(input.hInPoint.get(i).x, input.hInPoint.get(i).y);
  }
  for (int i = 0; i < input.hOutPoint.size(); i++) { //draws horizontal out points
    point(input.hOutPoint.get(i).x, input.hOutPoint.get(i).y);
  }
  fill(0);
  if (name == " ") { //lists the character match at the top of the drawn image
    textSize(25);
    text("Character match: no absolute match", 10, 30);
  } else {
    textSize(25);
    text("Character Match: " + name, 10, 30);
  }
}