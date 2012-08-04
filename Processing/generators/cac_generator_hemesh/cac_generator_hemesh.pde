/**
 *
 * Computer Augmented Crafts : Generator Hemesh 
 *
 * (c) Martin Schneider 2012
 *
 * This sketch demonstrates how to wrap the generators from 
 * cac_generator sketch inside a HEC_Creator classes 
 * for use with the HEMesh framework.
 *
 * Libraries inside the code folder:
 *
 * - hemesh processing library
 * - delaunay triangulation library
 * 
 */

import processing.opengl.*;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

String filename;
HE_Mesh mesh, mesh2;
WB_Render render;

int radius = 200;
float zoom = 1.2f;
int meshStyle = 1;
int meshSelect = 1;
boolean autoRotate = true;
int fps = 1;

public void setup() {
  
  size(800, 600, OPENGL);
  pickMesh(meshSelect);
  render = new WB_Render(this);
  smooth();
  
  // mouse / trackpad zooming
  setupMouseWheel();
}


public void draw() {
  background(255);
  translate(width/2, height/2);
  rotateX(-PI * 2/3);
  scale(zoom);
  stroke(1);
  if (autoRotate) {
    mesh.rotateAboutAxis(.005, WB_Point3d.ZERO(), WB_Point3d.Z());
  }
  drawMesh();
}


