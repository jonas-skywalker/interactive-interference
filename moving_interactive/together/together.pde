float angle = 0;
float[][] values;
int count = 1;
int limit = 100;

Emitter[] emitters;

float x1 = 400;
float y1 = -70;
float z1 = 159.0;

PGraphics pg;

void setup() {
  //fullScreen();
  size(1000, 600);
  values = new float[width][height];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      values[x][y] = 0;
    }
  }
  emitters = new Emitter[]{new Emitter(width * 1/6, height/2), new Emitter(width * 2/6, height/2)};
}

void draw() {
  
  background(0);
  
  loadPixels();
  for (int x = 0; x < width/2; x += 2) {
    for (int y = 0; y < height; y += 2) {
     
      float value = 0;
      for (int k = 0; k < emitters.length; k++) {
        float offset = pow((emitters[k].x - x)*(emitters[k].x - x) + (emitters[k].y - y)*(emitters[k].y - y), 0.5)/10;
        value += sin(angle + offset);
      }
      value = map(value, -emitters.length, emitters.length, 0, 255);
      color c = color(value);
      int index1 = x + y * width;
      pixels[index1] = c;
      if (count < limit) {
        values[x][y] += abs(value - 127.5);
      }
      color c2 = color(map(values[x][y]/127.5, -count, count, 0, 255));
      int index2 = x + width/2 + y * width;
      pixels[index2] = c2;
    }
  }
  
  updatePixels();
  angle -= TWO_PI/100;
  if (angle < -TWO_PI) {
    angle = 0;
  }
  for (int k = 0; k < emitters.length; k++) {
    emitters[k].show();
  }
  if (count < limit) {
    count++;
  }
}

void mousePressed() {

  for (int k = 0; k < emitters.length; k++) {
    emitters[k].check_mouse();
  }
}

void mouseReleased() {
  for (int k = 0; k < emitters.length; k++) {
    emitters[k].release_mouse();
  }
}

void keyPressed() {
  if (key == ' ') {
    emitters = (Emitter[])append(emitters, new Emitter(width * 1.5/6, height/2));
  } else if (key == 'r') {
    emitters = (Emitter[])shorten(emitters);
  }
}

void reset_find() {
  values = new float[width][height];
  count = 1;
  loadPixels();
    for (int x = width/2; x < width; x += 1) {
      for (int y = 0; y < height; y += 1) {
        int index = x + y * width;
        pixels[index] = -3355444;
      }
    }
    updatePixels();
}

class Emitter {
  float x;
  float y;
  boolean dragging = false;
  float r = 20;
  Emitter(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void show() {
    if (dragging) {
      x = mouseX;
      y = mouseY;
    }
    ellipse(x, y, r, r);
  }
  
  void check_mouse() {
    if ((x-r < mouseX) && (mouseX < x+r) && (y-r < mouseY) && (mouseY < y+r)) {
      dragging = true;
    }
  }
  
  void release_mouse() {
    dragging = false;
    reset_find();
  }
}
