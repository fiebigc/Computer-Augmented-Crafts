
/**
 *
 *  Computer Augmented Craft : Sequencer
 *
 * (c) Martin Schneider 2012
 *
 * This sketch implements the CAC sequencing algorithm
 * It takes arbitrary meshes in STL format, and 
 * breaks them down into a construction sequence
 * which is used by the CAC_Assistant to control
 * the flow of Computer Augmented Craft
 *
 * Just drop your STL files into the data folder of the sketch
 * to make them available for sequencing
 * (There are already two files in there to get you started)
 *
 * Libraries inside the code folder:
 *
 * - hemesh processing library
 * - peasycam processing library
 *
 */


import peasy.*;
import wblut.core.processing.*;
import wblut.geom.core.*;
import processing.opengl.*;

PeasyCam cam;
Grid grd;
WB_Render gfx;
CAC_Mesh mesh;
float zoom;

int meshSelect;

void setup() {

  // size(800, 600, OPENGL);
  size(800, 600, "CAC_OpenGL");
  // hint(DISABLE_OPENGL_2X_SMOOTH);
  hint(DISABLE_DEPTH_TEST);
  
  // camera settings
  cam = new PeasyCam(this, width * 0.75);
  cam.setMinimumDistance(width * 0.5);
  cam.setMaximumDistance(width * 2.0);
  cam.rotateX(2.6);

  // init
  grd = new Grid(this, 20); 
  gfx = new WB_Render(this);
  loadMeshes();
   
}

void draw() {
  
  // draw meshes
  mesh = meshes.get(meshSelect % meshes.size());
  mesh.draw();
  
}

