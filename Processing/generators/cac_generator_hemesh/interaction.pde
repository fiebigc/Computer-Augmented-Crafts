
public void keyPressed() {

  switch(key) {
  case 's':
    meshStyle = (meshStyle+1) % 3;
    break;
  case ' ':
    meshSelect = (meshSelect+1) % 6;
    pickMesh(meshSelect);
    break;
  case 'r':
    autoRotate = !autoRotate;
    break;
  case 'x': 
    // export to stl
    String path = dataPath(filename + ".stl");
    println("Saving mesh to " + path);
    HET_Export.saveToSTL(mesh , path, 1.0);
    break;
  }
}

void setupMouseWheel() {
    addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
    }
  });
}

void mouseWheel(int delta) {
  zoom = constrain(zoom + delta * .01f, .5f, 1.4f);
}
