

void keyPressed() {
  switch(key) {
    case 'm':
    case ' ': toggleGui(); break;
  }
}

// interaction with mesh vs. gui
void mouseDragged() {
  boolean useCam = !insideGui(mouseX, mouseY);
  cam.setMouseControlled(useCam);
}
