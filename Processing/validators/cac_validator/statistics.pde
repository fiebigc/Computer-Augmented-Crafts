
int too_short, too_long;
float shortest, longest;

// find number of edges which are too short or too long
void updateStats() {
  too_short = too_long = 0;
  if (working_mesh != null) {
    Iterator<HE_Edge> eItr = working_mesh.eItr();
    while (eItr.hasNext ()) {
      HE_Edge edge = eItr.next();
      float l = (float) edge.getLength();
      if (l < lmin) too_short++; 
      else if (l > lmax) too_long++;
    }
  }
}


// find shortest and longest edge of the source mesh
void updateSourceStats() {
  shortest = MAX_FLOAT;
  longest = 0;
  Iterator<HE_Edge> eItr = source_mesh.eItr();
  while (eItr.hasNext ()) {
    HE_Edge edge = eItr.next();
    float l = (float) edge.getLength();
    shortest = min(l, shortest);
    longest = max(l, longest);
  }
}


