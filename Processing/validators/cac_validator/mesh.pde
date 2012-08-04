
import wblut.core.processing.*;
import wblut.geom.core.*;
import wblut.hemesh.core.*;
import wblut.hemesh.creators.*;
import wblut.hemesh.modifiers.*;
import wblut.hemesh.tools.*;

WB_Render render;
HE_Mesh source_mesh, working_mesh;
final int stripWeight = 3;

void setupMesh() {
  render = new WB_Render(this);
}

void drawMesh() {
  pushStyle();
  noFill();
  if (working_mesh != null) {
    stroke(0);
    strokeWeight(stripWeight * width / (float) cam.getDistance());
    drawEdges();
  }
  popStyle();
}

void drawSpheres() {

  if (working_mesh != null && showNodeSpace) {
    strokeWeight(1);
    stroke(fgcolor1);
    Iterator<HE_Vertex> vItr = working_mesh.vItr();

    while (vItr.hasNext ()) {
      HE_Vertex v = vItr.next();
      float r = sphereRadius(v);
      if (r > 0) {
        drawSphere(v, r);
      }
    }
  }
}

void drawSphere(HE_Vertex v, float r) {
  // get screen coords
  pushMatrix();
  translate((float) v.x, (float) v.y, (float) v.z);
  float x = screenX(0, 0, 0);
  float y = screenY(0, 0, 0);
  float z = screenZ(0, 0, 0);
  // sphere(r);

  // draw ellipse in 2d ontop of the screen
  cam.beginHUD();
  r *= (1 - z) * 23;   // approximating sphere radius 
  ellipse(x, y, r, r);
  cam.endHUD();
  popMatrix();
}

float sphereRadius(HE_Vertex v) {
  List<HE_Edge> edges = v.getEdgeStar();
  float rmax = MAX_FLOAT;
  for (HE_Edge edge : edges) {
    float l = (float) edge.getLength();
    float r0 = l / 2;           // mesh geometry constraint
    float r1 = (l - lmin) / 2;  // mimimum edge length constraint
    float r2 = (lmax - l) / 2;  // maximum edge length constraint
    rmax = min(min(rmax, r0), min(r1, r2));
  }
  return rmax;
}

void drawBBox() {
  if (working_mesh != null && showBBox) {
    noFill();
    strokeWeight(1);
    stroke(fgcolor2);
    WB_AABB bbox = working_mesh.getAABB();
    render.draw(bbox);
  }
}

void drawEdges() {
  Iterator<HE_Edge> eItr = working_mesh.eItr();
  while (eItr.hasNext ()) {
    HE_Edge edge = eItr.next();
    float l = (float) edge.getLength();
    stroke(l < lmin ? hicolor1 : l > lmax ? hicolor2 : fgcolor);
    render.drawEdge(edge);
  }
}

