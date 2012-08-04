
class HEC_DelaunayDisc extends HEC_FromDelaunay {
  
  float radius;
  float step;
  int level;
  int type;
  
  HEC_DelaunayDisc setRadius(float radius) {
    this.radius = radius;
    return this;
  }
    
  HEC_DelaunayDisc setLevel(int level) {
    this.level = level;
    return this;
  }
  
  HEC_DelaunayDisc setStep(float step) {
    this.step = step;
    return this;
  }
  
  HEC_DelaunayDisc setType(int type) {
    this.type = type;
    return this;
  }
   
  float[][] getVertices() {
    switch(type) {
      case 0:
        return disc(radius, step, level);
      case 1:
        return phyllotaxis(radius, step, level);
      default:
        return vertices;
    }
  }
  
  private float[][] phyllotaxis(float r, float d, int n) {
    float PHI = (1 + sqrt(5)) / 2;
    int m = int(n * n * 2);
    float[][] points = new float[m][3];
    float dang = TWO_PI * PHI;
    float ang = 0;
    for(int i=0; i < m; i++) {
      float dd =  sqrt(i+.5) / PHI * d;
      ang = -i * dang;
      points[i] = new float[] {
        cos(ang) * dd,
        sin(ang) * dd,
        0
      };
    }
    return points;
  }
  
  private float[][] disc(float r, float d, int n) {
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
  
  private float[][] disc(float r, int[] units, float coverage) {
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
    
  private int sum(int[] a) {
    int sum = 0; for(int x : a) sum += x; return sum;
  }

}

