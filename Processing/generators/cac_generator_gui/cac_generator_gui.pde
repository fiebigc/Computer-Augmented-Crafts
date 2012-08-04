
/**
 *
 * Computer Augmented Crafts : Generator with GUI
 *
 * (c) Martin Schneider 2012
 *
 *   Libraries inside the code folder:
 * 
 * - controlp5 processing library (version 0.5.4) - don't try to use newer versions with cp5magic
 * - cp5magic processing library
 * - peasycam processing library
 * - delaunay_triangulation library
 *
 */
 
import processing.opengl.*; 
import peasy.*;
PeasyCam cam;

int [][] tri;
float[][] b;
int pick = 0;
String[] filenames = { "bowl", "disc", "sunflower" };

final int dmin = 20;
final int dmax = 100;
int rotation = 0;

void setup() {
  size(800, 600, OPENGL);
  cam = new PeasyCam(this, r * 1.4);
  cam.setResetOnDoubleClick(false);
  createMesh();
  setupGui();
}

void draw() {
  
  if(autoRotate) rotation++;
  
  background(#888888);
  strokeWeight(2);
  
  // rotate in space
  rotateX(-2);
  rotateZ( rotation * -.005);
  
  // draw triangles
  for (int i=0; i<tri.length; i++) {
    int[] t = tri[i];
    try {
      triangle(b[t[0]], b[t[1]], b[t[2]]);
    } catch(Exception e) {
      // println("delaunay triangulator cannot handle this"); 
    }
  }
   
  drawGui();
  
}

void triangle(float[] a, float[] b, float[] c) {
  line(a, b); line(b, c); line(c, a);
}

void line(float[] a, float[] b) {
  line(a[0], a[1], a[2], b[0], b[1], b[2]);
}

