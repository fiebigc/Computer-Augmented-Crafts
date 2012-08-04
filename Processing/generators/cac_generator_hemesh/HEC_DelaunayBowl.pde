
class HEC_DelaunayBowl extends HEC_FromDelaunay {
  
  float radius;
  float step;
  int level;
  int type;
  
  HEC_DelaunayBowl setRadius(float radius) {
    this.radius = radius;
    return this;
  }
    
  HEC_DelaunayBowl setLevel(int level) {
    this.level = level;
    return this;
  }
  
  HEC_DelaunayBowl setStep(float step) {
    this.step = step;
    return this;
  }
  
  HEC_DelaunayBowl setType(int type) {
    this.type = type;
    return this;
  }
   
  float[][] getVertices() {
    return bowl(radius, step, level);
  }
  
  // parametric bowl function
  // returns an array of 3d vertices
  // the density of samples in each row is determined by the units array
  
  private float[][] bowl(float r, int[] units, float coverage) {
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
  
  private float[][] bowl(float r, float d, int n) {
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
  
  private int sum(int[] a) {
    int sum = 0; for(int x : a) sum += x; return sum;
  }

}

