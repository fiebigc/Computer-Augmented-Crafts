
// create a disc with nodes arranged like sunflower seeds

void createSunflower() {
  b = phyllotaxis(r, d, n);
  tri = delaunay(b);
}

float[][] phyllotaxis(float r, float d, int n) {
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


