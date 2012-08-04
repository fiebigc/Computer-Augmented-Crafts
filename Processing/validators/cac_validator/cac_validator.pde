
/**
 *
 * Computer Augmented Crafts : Mesh Validator 
 *
 * (c) Martin Schneider 2012
 *
 * Use this tool to validate and rescale STL source meshes interactively
 * so you can use them with the CAC assistant
 *
 * basic mesh unit: 1mm
 *
 * Processing libraries inside the code folder:
 * 
 * - peasycam
 * - controlP5
 * - cp5magic 
 * - toxiclibcscore
 * - hemesh
 *
 */

import processing.opengl.*; 
import peasy.*;
float rotation = 0;

color fgcolor = #222222;
color fgcolor1 = #ffffff;
color fgcolor2 = color(255, 64);
color hicolor1 = #cc3333;
color hicolor2 = #3333cc;

float depth;

void setup() {
  size(800, 600, OPENGL);
  depth = width;
  cam = new PeasyCam(this, depth);
  cam.setResetOnDoubleClick(false);
  cam.setMaximumDistance(depth * 5);
  cam.setMinimumDistance(depth / 3);
  setupGui();
  setupMesh();
}

void draw() {
  // ortho(-width/2, width/2, -height/2, height/2, -width*2, width*2);
  // translate(-guiWidth / 2, 0);
  hint(DISABLE_DEPTH_TEST); 
  if(autoRotate)  rotation += 0.5 / frameRate;
  background(#888888);
  pushMatrix();
    rotateX(-PI * 2/3);
    rotateZ(-rotation); 
    drawMesh();
    drawBBox();
    drawSpheres();
  popMatrix();
  drawGui();
}

