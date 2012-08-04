
void keyPressed() {
  switch(key) {
    case ' ': pick = (pick + 1) % 3; createMesh(); break;
    case '+': if(d > dmin) increaseDensity(); return; 
    case '-': if(d < dmax) decreaseDensity(); return;
    case 'a': autoRotate = !autoRotate; break;
    case 'l': limitLevels = !limitLevels; limitLevels(); break;
    case 'x': export(); return;
    case 'm': toggleGui(); return;
    case CODED: switch(keyCode) {
        case UP: if(valid(n+1)) n++; break;
        case DOWN: if(valid(n-1)) n--; break;
      }
      break;
    default: return;
  }
  updateGui();
}

// interaction with mesh vs. gui
void mouseDragged() {
  boolean useCam = !insideGui(mouseX, mouseY);
  cam.setMouseControlled(useCam);
}


// Note: JDT does not triangulate well along the Z-axis!
// This should prevent invalid settings
boolean valid(int n) {
  return (n >1) && (d * n < r * PI * .35);
}

// switching thru mesh grenerators
void createMesh() {
  switch(pick) {
    case 0: createBowl(); break;
    case 1: createDisc(); break;
    case 2: createSunflower(); break;
  } 
}
