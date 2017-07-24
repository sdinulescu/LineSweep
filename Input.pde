class Input {
  String name;
  PImage image;
  int vInPoints = 0, hInPoints = 0;
  int vOutPoints = 0, hOutPoints = 0;
  int vPointCount = 0, hPointCount = 0;
  ArrayList<PVector> input = new ArrayList<PVector>(); //creates an arrayList to store PVector data for black pixels
  ArrayList<PVector> vInPoint = new ArrayList<PVector>();
  ArrayList<PVector> hInPoint = new ArrayList<PVector>();
  ArrayList<PVector> vOutPoint = new ArrayList<PVector>();
  ArrayList<PVector> hOutPoint = new ArrayList<PVector>();
  ArrayList<Integer> vPoints = new ArrayList<Integer>();
  ArrayList<Integer> hPoints = new ArrayList<Integer>();
  ArrayList<Integer> vNewPoints = new ArrayList<Integer>();
  ArrayList<Integer> hNewPoints = new ArrayList<Integer>();
  
  Input(String name) {
    this.name = name;
  }
  void load() {
    image = loadImage(name);
    image.resize(500, 500); //size the image for standardization
    image.filter(THRESHOLD); //sets image to black and white, depending on whether it is above 0.5 threshold
    image.loadPixels(); //loads pixels to allow getting function
  }
  
  void display() {
    image(image, 0, 0);
  }
}