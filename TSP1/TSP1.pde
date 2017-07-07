color backgroundColour = color(0), cityColour = color(255), pathColour = color(255), bestPathColour = color(0, 255, 0);
boolean draw = true, finished = false;
float citySize = 6, record, percent, seconds;
int numCities = 7, totalPermutations = factorial(numCities), count = 0;
PVector[] city = new PVector[numCities];
int[] order = new int[numCities], bestPath = new int[numCities];

void setup() {
  size(1280, 720);
  //fullscreen();
  noSmooth();
  frameRate(999);
  strokeJoin(ROUND);
  textSize(40);
  if (!draw) noLoop();
  for (int i = 0; i < city.length; i++) {
    city[i] = new PVector(random(citySize/2, width - citySize), random(citySize/2, height - 55 - citySize));
    order[i] = i;
  }
  record = calcDistance(city, order);
  arrayCopy(order, bestPath);
}

void draw() {
  println(frameRate);
  background(backgroundColour);
  noStroke();
  fill(200);
  fill(cityColour);
  for (int i = 0; i < city.length; i++) ellipse(city[i].x, city[i].y, citySize, citySize);
  noFill();
  if (!finished) {
    stroke(pathColour);
    strokeWeight(1);
    beginShape();
    for (int i = 0; i < order.length; i++) vertex(city[order[i]].x, city[order[i]].y);
  }
  endShape();
  stroke(bestPathColour);
  strokeWeight(2);
  beginShape();
  for (int i = 0; i < order.length; i++) vertex(city[bestPath[i]].x, city[bestPath[i]].y);
  endShape();
  if (calcDistance(city, order) < record) {
    record = calcDistance(city, order);
    arrayCopy(order, bestPath);
  }
  if (count < totalPermutations) count++;
  percent = abs(100 * float(count) / float(totalPermutations));
  seconds = !finished ? 0.001*millis() : seconds;
  text(nf(percent, 0, 6) + "% completed", 5, height - 10);
  text(nf(seconds, 0, 3) + " secs", 0.45*width, height - 10);
  text("Optimal: " + record, 0.69*width, height - 10);
  nextOrder();
}

void swap(PVector[] a, int i, int j) {
  PVector tmp = a[i];
  a[i] = a[j];
  a[j] = tmp;
}

void swap(int[] a, int i, int j) {
  int tmp = a[i];
  a[i] = a[j];
  a[j] = tmp;
}

float calcDistance(PVector[] points, int[] order) {
  float sum = 0;
  for (int i = 0; i < order.length - 1; i++) {
    PVector cityA = points[order[i]], cityB = points[order[i + 1]];
    float distance = dist(cityA.x, cityA.y, cityB.x, cityB.y);
    sum += distance;
  }
  return sum;
}

void nextOrder() {
  int largestI = -1;
  for (int i = 0; i < order.length - 1; i++) if (order[i] < order[i + 1]) largestI = i;
  if (largestI != -1) {
    int largestJ = -1;
    for (int j = 0; j < order.length; j++) if (order[largestI] < order[j]) largestJ = j;
    swap(order, largestI, largestJ);
    int[] endArray = subset(order, largestI + 1);
    order = expand(order, largestI + 1);
    endArray = reverse(endArray);
    order = concat(order, endArray);
  } else finished = true;
}

int factorial(int n) {
  if (n == 1) return 1;
  else return n * factorial(n - 1);
}