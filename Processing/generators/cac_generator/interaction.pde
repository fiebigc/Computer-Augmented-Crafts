
void keyPressed() {
  int dmin = 20;
  int dmax = 100;
  switch(key) {
    case ' ': pick = (pick + 1) % 3; createMesh(); break;
    case '+': if(d > dmin) { d = d * (n-1) / n; n++; } break; 
    case '-': if(d < dmax) { n--; d = d * n / (n-1); } break;
    case 'a': autoRotate =! autoRotate; break;
    case 'x': exportMesh(); return;
    case CODED: switch(keyCode) {
        case UP: if(valid(n+1)) n++; break;
        case DOWN: if(valid(n-1)) n--; break;
      }
      break;
  }
  createMesh();
}

// Note: JDT does not triangulate well along the Z-axis!
// This should prevent invalid settings
boolean valid(int n) {
  return n >1 && (d * n < r * PI * .35);
}

// switching thru mesh grenerators
void createMesh() {
  switch(pick) {
    case 0: createBowl(); break;
    case 1: createDisc(); break;
    case 2: createSunflower(); break;
  } 
}
