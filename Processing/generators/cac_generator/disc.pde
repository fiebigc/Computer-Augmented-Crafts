
// create a flat circular disc

void createDisc() {
  b = disc(r, d, n);
  tri = delaunay(b);
}

// parametric disc function
// returns an array of 3d vertices
// the density of samples in each row is determined by the units array

float[][] disc(float r, int[] units, float coverage) {
  int u = sum(units);
  float[][] verts = new float [u][3];
  int m = units.length;
  for (int i = 0, k = 0; i < m; i++) {
    float phi = PI * i / m * coverage;
    int n = units[i];
    for (int j = 0; j < n; j++, k++) {
      float rho = TWO_PI * j / n;
      verts[k] = new float[] {
        r * cos(rho) * phi,
	r * sin(rho) * phi, 
        0
      };
    }
  }
  return verts;
}

// same as above - calculating the number of
// units from d and the circumferences

float[][] disc(float r, float d, int n) {
  //int n = int(r * PI * coverage / d );
  float coverage = (d * n) / (r * PI);
  float cmax = r * TWO_PI;
  int[] units = new int[n];
  for (int i=0; i < n; i++) {
    float phi = PI * i / n * coverage;
    float circum = r * TWO_PI * phi;
    int m =  int(circum / d);
    units[i] = max(1, m);
  }
  return disc(r, units, coverage);
}


