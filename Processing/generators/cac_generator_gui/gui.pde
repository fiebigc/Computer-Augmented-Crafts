
// using controlP5 fot the GUI
import controlP5.*;

// using cp5magic to create the GUI using annotations
import toxi.geom.Vec2D;
import toxi.gui.Range;
import toxi.gui.*;

ControlP5 cp5;
GUIManager gui;
final int guiWidth = 180;
boolean showGui = true;
      
@GUIElement
public String export = "export mesh";

@GUIElement(label = "generator", y = 60)
public List pickGenerator = new ArrayList<String>();

@GUIElement(label = "auto rotate", y = 120)
public boolean autoRotate = true;

@GUIElement(label = "limit levels", y = 150)
public boolean limitLevels = false;

@Range(min = dmin, max = dmax)
@GUIElement(label = "step", y = 200)
public float d = 50;

@Range(min = 2, max = 10)
@GUIElement(label = "levels", y = 220)
public int n = 5;

@Range(min = 100, max = 300)
@GUIElement(label = "warp", y = 240)
public float r = 300;
    
    
@GUIElement(y = 280)
public String increaseDensity = "[+] density";

@GUIElement(y = 300)
public String decreaseDensity = "[-] density";


void updateGui() {
  
  // simply recreate the whole gui with the current parameters
  // kind of hackish but very effective
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  gui = new GUIManager(cp5);
  gui.createControllers(this, width - 160, 20, "default"); 

  // we need to set radiobuttons manually
  gui.getForID("pickGenerator").setValue(pick);
  
}

void setupGui() {
  Collections.addAll(pickGenerator, filenames);
  updateGui();
}

void toggleGui() {
  //if(cp5.controlWindow.isVisible()) cp5.hide(); else cp5.show();
  showGui = !showGui;
}

void drawGui() {
  if(showGui) {
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

void limitLevels() {
  limitLevels(limitLevels); 
}


////////////////////////////////////////////////////////////////
// public  gui functions 

public void pickGenerator(int choice) {
  pick = choice;
  createMesh();
}

public void n(int n) {
  createMesh();
}


public void d(int d) {
  limitLevels();
}

public void r(float r) {
  limitLevels();
}

public void limitLevels(boolean lim) {
  Slider s = (Slider) gui.getForID("n");
  if(lim) { 
    int lmax = int((r * PI * .35) / d);
    s.setMax(max(2,lmax));
  } else {
    s.setMax(10);
  }
  createMesh();
}

public void increaseDensity() {
  if(n<10) {
    n++;
    d = d * (n-1) / n;
    updateGui();
    createMesh();
  }
}

public void decreaseDensity() {
  if(n>2) {
   n--; 
   d = d * (n+1) / n;
   updateGui();
   createMesh();
  }
}

public void export() {
  // start a new thread, so the animation does not halt
  thread("exportMesh");
}


