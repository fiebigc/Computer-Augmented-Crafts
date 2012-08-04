
// using controlP5 for the GUI
import controlP5.*;

// using cp5magic to create the GUI using annotations
import toxi.geom.Vec2D;
import toxi.gui.Range;
import toxi.gui.*;
import toxi.util.datatypes.FloatRange;

PeasyCam cam;
ControlP5 cp5;
GUIManager gui;

final int guiWidth = 180;
final int LMIN = 50, LMAX = 150;

final int STACKED_HISTOGRAM = 0, STAGGERED_HISTOGRAM = 1;
int histogramType = STAGGERED_HISTOGRAM;

boolean showGui = true;
float lmin, lmax;
float bbx, bby, bbz;


// mesh import / modify / export

@GUIElement
public String import_mesh = "load mesh";

@GUIElement
public String export_mesh = "save mesh";

@Range(min = 0.01, max = 10.0)
@GUIElement(label = "scale mesh", y = 80)
public float scale_mesh = 1.0;


// auto scale

@GUIElement(y = 100)
public String min_scale = "minimum scale";

@GUIElement(y = 120)
public String opt_scale = "optimum scale";

@GUIElement(y = 140)
public String max_scale = "maximum scale";


// edge limits

@GUIElement(builder=FloatRangeCustomMinMaxBuilder.class, y = 300)
public FloatRange edge = new FloatRange(0, LMAX+LMIN);

@GUIElement(y = 340)
public String reset_limits = "reset edge limits";


// display modes

@GUIElement(label = "auto rotate", y = 490)
public boolean autoRotate = false;

@GUIElement(label = "bounding box", y = 520)
public boolean showBBox= true;

@GUIElement(label = "node space", y = 550)
public boolean showNodeSpace = true;



Chart chart; 

void setupGui() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);  
  gui = new GUIManager(cp5);
  gui.createControllers(this, width - guiWidth + 10, 20, "default");
 
  chart = cp5.addChart("histogram_chart", width -guiWidth + 10, 200, 160, 60);
  cp5.addButton("histogram_type", 1, width -guiWidth + 10, 260, 160, 15).setValue(0);
 
  chart.setDisplay(new ChartHistogramDisplay(chart));
  reset_limits();
  updateGui();
}

void updateHistogram() {
  ArrayList<Float> data = getEdgeLengths();
  switch(histogramType) {
    case STACKED_HISTOGRAM:
      chart.setDataSet(histogramDataSet(data, chart.getWidth()));
      break;
    case STAGGERED_HISTOGRAM:
      chart.setDataSet(sortedValueDataSet(data));
      break;
  }
}

ChartDataSet sortedValueDataSet(ArrayList<Float> a) {
  ChartDataSet  dataset = new ChartDataSet();
  Collections.sort(a);
  for (float l : a) {
    ChartData data = new ChartData(l);
    data.setColor(l < lmin ? hicolor1 : l > lmax ? hicolor2 : fgcolor);
    dataset.add(data);
  }
  return dataset;
}

ChartDataSet histogramDataSet(ArrayList<Float> a, int bins) {
  int[] histogram = new int[bins];
  ChartDataSet dataset = new ChartDataSet();
  float lbottom = MAX_FLOAT;
  float ltop = 0;
  // find lowest and highest value
  for (float l : a) {
    lbottom = min(lbottom, l);
    ltop = max(ltop, l);
  }
  float hbottom = min(lbottom, lmin);
  float htop = max(ltop, lmax);
  // fill bins of the histogram
  for (float l : a) {
    int bin = (int) map(l, hbottom, htop, 0, bins-1);
    histogram[bin]++;
  }
  // create chart data
  for (int bin = 0; bin < bins; bin++) {
    ChartData data = new ChartData(histogram[bin]);
    float l = map(bin, 0, bins-1, hbottom, htop);
    data.setColor(l < lmin ? hicolor1 : l > lmax ? hicolor2 : fgcolor);
    dataset.add(data);
  }
  return dataset;
}

void toggleGui() {
  showGui = !showGui;
}

void drawGui() {
  if (showGui) {
    cam.beginHUD();
    pushStyle();
    noStroke();
    fill(255, 64);
    rect(width - guiWidth, 0, width, height);
    cp5.draw();
    popStyle();
    cam.endHUD();
  }
}

boolean insideGui(int x, int y) {
  return  x > width - guiWidth;
}

void updateGui() {
  updateStats();
  boolean nomesh = working_mesh == null;
  if (!nomesh) updateHistogram();  
  setLock(gui.getForID("export_mesh"), nomesh || (too_short + too_long > 0) );
  setLock(gui.getForID("scale_mesh"), nomesh);
  setLock(gui.getForID("min_scale"), nomesh);
  setLock(gui.getForID("max_scale"), nomesh);  
  setLock(gui.getForID("opt_scale"), nomesh);
}

// locking with greying out
void setLock(Controller c, boolean lock) {
  CColor activeGuiColor = new CColor();
  CColor lockedGuiColor = new CColor();
  lockedGuiColor.setAlpha(50);
  c.setLock(lock);
  if (!lock) {
    c.setColor(activeGuiColor);
  } 
  else {
    c.setColor(lockedGuiColor);
  }
}


////////////////////////////////////////////////////////////////
// public  gui functions 

public void histogram_type(ControlEvent e) {
  String[] labels = { "edge histogram ", "staggered edges" };
  histogramType = 1 - (int) e.value();
  e.controller().setLabel(labels[histogramType]);
  e.controller().changeValue(histogramType);
  if(working_mesh != null) updateHistogram();
}

public void reset_limits() {
  lmin = LMIN;
  lmax = LMAX;
  gui.getForID("edge_min").setValue(lmin);
  gui.getForID("edge_max").setValue(lmax);
}

public void import_mesh() {
  // start a new thread, so the animation does not halt
  thread("importMesh");
}

public void export_mesh() {
  // start a new thread, so the animation does not halt
  thread("exportMesh");
}

public void edge_min(float l) {
  lmin = l;
  updateGui();
}

public void edge_max(float l) {
  lmax = l;
  updateGui();
}

public void scale_mesh(float s) {
  working_mesh = source_mesh.get();
  working_mesh.scale(s);
  println("scaling source mesh by " +s);
  updateGui();
}

public void min_scale() {
  float s = lmin / shortest;
  gui.getForID("scale_mesh").setValue(s);
}


public void opt_scale() {
  float s = (lmax + lmin)  / (longest + shortest);
  gui.getForID("scale_mesh").setValue(s);
}


public void max_scale() {
  float s = lmax / longest;
  gui.getForID("scale_mesh").setValue(s);
}



