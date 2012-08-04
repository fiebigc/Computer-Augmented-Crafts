
/**
 *
 * CAC_OpenGL mode 
 * 
 * An OPENGL graphics mode that supports thick lines with round caps.
 * This mode can be used like regular OPENGL mode:
 * 
 * import processing.opengl.*;
 * void setup() {
 *   size(800, 600, "CAC_OpenGL");
 * }
 *
 * The code is heavily inspired by http://wiki.processing.org/index.php?title=Stroke_attributes_in_OpenGL
 * and the Processing 2.0 code base
 *
 * (c) Martin Schneider 2012
 *
 */


import peasy.*;
import processing.opengl.*;
import java.awt.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import java.awt.geom.*;

public class CAC_OpenGL extends PGraphicsOpenGL {
  
  PeasyCam cam;
  
  // TODO: implement a proper 3D projection based on the actual transformation matrix
  public void line(float x1, float y1, float z1, float x2, float y2, float z2) {
    if(strokeWeight <=1) {
      // draw thin lines the regular way
       super.line(x1, y1, z1, x2, y2, z2);
    } else {
      // draw thick lines as 2D projections
      float x1_ = screenX(x1, y1, z1);
      float y1_ = screenY(x1, y1, z1);
      float x2_ = screenX(x2, y2, z2);
      float y2_ = screenY(x2, y2, z2);
      lineHUD(x1_, y1_, x2_, y2_);
    }
  }
      
  // draw a 2D line ontop of the peasycam heads up device
  public void lineHUD(float x1, float y1, float x2, float y2) {
      cam = ((cac_sequencer) parent).cam;
      cam.beginHUD();
      line(x1, y1, x2, y2);
      cam.endHUD();
  }
  
  // draw a 2D line
  public void line(float x1, float y1, float x2, float y2) {
    if(strokeWeight <= 1) {
       // draw thin lines the regular way
      super.line(x1, y1, x2, y2); 
    } else {
      // draw thick lines using AWT path tesselation
      GeneralPath path = new GeneralPath();
      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
      tessellatePath(path);
    }
  }
  
  public void tessellatePath(GeneralPath path) {

    // save old style
    float oldStrokeWeight = strokeWeight;
    int oldFillColor = fillColor;
    
    // apply stroke style to path shape
    noStroke();
    fill(strokeColor);
    
    int strokeCap = BasicStroke.CAP_ROUND;  
    int strokeJoin = BasicStroke.JOIN_ROUND;
    BasicStroke bs = new BasicStroke(strokeWeight, strokeCap, strokeJoin);
    
    // Make the outline of the stroke from the path
    Shape sh = bs.createStrokedShape(path);

    glu.gluTessBeginPolygon(tobj, null);

    float lastX = 0;
    float lastY = 0;
    double[] vertex;
    float[] coords = new float[6];

    PathIterator iter = sh.getPathIterator(null); // ,5) add a number on here to simplify verts
    int rule = iter.getWindingRule();
    switch(rule) {
    case PathIterator.WIND_EVEN_ODD:
      glu.gluTessProperty(tobj, GLU.GLU_TESS_WINDING_RULE, GLU.GLU_TESS_WINDING_ODD);
      break;
    case PathIterator.WIND_NON_ZERO:
      glu.gluTessProperty(tobj, GLU.GLU_TESS_WINDING_RULE, GLU.GLU_TESS_WINDING_NONZERO);
      break;
    }

    while (!iter.isDone ()) {

      switch (iter.currentSegment(coords)) {

      case PathIterator.SEG_MOVETO:   // 1 point (2 vars) in coords
        glu.gluTessBeginContour(tobj);

      case PathIterator.SEG_LINETO:   // 1 point
        vertex = new double[] { 
          coords[0], coords[1], 0
        };
        glu.gluTessVertex(tobj, vertex, 0, vertex);
        lastX = coords[0];
        lastY = coords[1];
        break;

      case PathIterator.SEG_QUADTO:   // 2 points
        for (int i = 1; i < bezierDetail; i++) {
          float t = (float)i / (float) bezierDetail;
          vertex = new double[] { 
            bezierPoint(lastX, coords[0], coords[2], coords[2], t), 
            bezierPoint(lastY, coords[1], coords[3], coords[3], t), 
            0
          };
          glu.gluTessVertex(tobj, vertex, 0, vertex);
        }
        lastX = coords[2];
        lastY = coords[3];
        break;

      case PathIterator.SEG_CUBICTO:  // 3 points
        for (int i = 1; i < bezierDetail; i++) {
          float t = (float)i / (float) bezierDetail;
          vertex = new double[] { 
            bezierPoint(lastX, coords[0], coords[2], coords[4], t), 
            bezierPoint(lastY, coords[1], coords[3], coords[5], t), 
            0
          };
          glu.gluTessVertex(tobj, vertex, 0, vertex);
        }
        lastX = coords[4];
        lastY = coords[5];
        break;

      case PathIterator.SEG_CLOSE:
        glu.gluTessEndContour(tobj);
        break;
      }
      iter.next();
    }

    glu.gluTessEndPolygon(tobj);
    
    // restore old style
    stroke(strokeColor);
    fill(oldFillColor);
  }
}


