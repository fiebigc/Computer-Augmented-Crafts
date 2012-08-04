
/**
 *
 * Computer Augmented Crafts : Mesh Generator 
 *
 * (c) Martin Schneider 2012
 *
 * Libraries inside the code folder:
 *
 * - hemesh processing library
 * - peasycam processing library
 * - delaunay triangulation library
 *
 */
 
import processing.opengl.*; 
import peasy.*;
PeasyCam cam;

boolean autoRotate = true;
float r = 300;
float d = 50;
int n = 5;
int [][] tri;
float[][] b;
float dmin = 20;
int pick = 0;
String[] filenames = { "bowl", "disc", "sunflower" };

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, r * 1.4);
  createMesh();
}

void draw() {
  
  background(255);
  strokeWeight(2);
  
  // rotate in space
  rotateX(-2);
  if(autoRotate) rotateZ(frameCount * -.005);
  
  // draw triangles
  for (int i=0; i<tri.length; i++) {
    int[] t = tri[i];
    triangle(b[t[0]], b[t[1]], b[t[2]]);
  } 
}

void triangle(float[] a, float[] b, float[] c) {
  line(a, b); line(b, c); line(c, a);
}

void line(float[] a, float[] b) {
  line(a[0], a[1], a[2], b[0], b[1], b[2]);
}




