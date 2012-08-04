
// create a bowl (sphere section)

void createBowl() {
  b = bowl(r, d, n);
  tri = delaunay(b);
}

// parametric bowl function
// returns an array of 3d vertices
// the density of samples in each row is determined by the units array

float[][] bowl(float r, int[] units, float coverage) {
  int u = sum(units);
  float[][] verts = new float [u][3];
  int m = units.length;
  for (int i = 0, k = 0; i < m; i++) {
    float phi = PI * i / m * coverage;
    int n = units[i];
    for (int j = 0; j < n; j++, k++) {
      float rho = TWO_PI * j / n;
      verts[k] = new float[] {
        r * cos(rho) * sin(phi), 
	r * sin(rho) * sin(phi), 
	- r + r * cos(phi)
      };
    }
  }
  return verts;
}

// same as above - calculating the number of
// units from d and the circumferences

float[][] bowl(float r, float d, int n) {
  //int n = int(r * PI * coverage / d );
  float coverage = (d * n) / (r * PI);
  float cmax = r * TWO_PI;
  int[] units = new int[n];
  for (int i=0; i < n; i++) {
    float phi = PI * i / n * coverage;
    float circum = r * TWO_PI * sin(phi);
    int m =  int(circum / d);
    units[i] = max(1, m);
  }
  return bowl(r, units, coverage);
}

int sum(int[] a) {
  int sum = 0; for(int x : a) sum += x; return sum;
}



