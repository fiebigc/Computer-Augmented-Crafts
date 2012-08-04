
// Display a Matrix-Style Grid in the Background

public class Grid {

  PApplet p;
  int xmin = -20;
  int xmax = 20; 
  int ymin = -20; 
  int ymax = 20;
  int fgcolor = 0x33ffffff;
  int bgcolor = #777777;
  float dx = 1;
  float dy = 1;
  boolean visible = true;

  public Grid(PApplet parent, float delta) {
    init(parent);
    dx = dy = delta;
  }

  public Grid(PApplet parent, float dx, float dy) {
    init(parent);
    dx = p.width / (xmax - xmin);
    dy = p.height / (ymax - ymin);
  }

  void init(PApplet parent) {
    p = parent;
    p.registerPre(this);
  }

  public void toggle() {
    visible = !visible;
  }

  public void pre() {

    p.background(bgcolor);

    if (visible) {

      p.pushStyle();
      p.strokeWeight(1);
      p.stroke(fgcolor);

      for (int x=xmin; x<=xmax; x++) {
        p.line(x*dx, ymin*dy, x*dx, ymax*dy);
      }

      for (int y=ymin; y<=ymax; y++) {
        p.line(xmin*dx, y*dy, xmax*dx, y*dy);
      }
      p.popStyle();
      
      // temporarily disabling depth test so the grid is 
      // always displayed in the background layer
      p.hint(p.DISABLE_DEPTH_TEST);
      p.hint(p.ENABLE_DEPTH_TEST);
      
    }
  }
}

