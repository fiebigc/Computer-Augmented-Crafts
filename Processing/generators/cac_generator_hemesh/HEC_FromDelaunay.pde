
// This is a simple adapter to the awesome JDT triangulation library
// http://code.google.com/p/jdt/
import delaunay_triangulation.*;

class HEC_FromDelaunay extends HEC_Creator {
  float[][] vertices;
  
  HEC_FromDelaunay setVeritices(float[][] vertices) {
    this.vertices = vertices;
    return this;
  }
  
  float[][] getVertices() {
    return vertices; 
  }
  
  HE_Mesh createBase() {
    vertices = getVertices();
    int[][] faces = delaunay(vertices);
    HEC_FromFacelist meshCreator = new HEC_FromFacelist();
    meshCreator
      .setFaces(faces)
      .setVertices(vertices)
      ;
    return new HE_Mesh(meshCreator);  
  }
  
  // 3d Delaunay Triangulation
  // takes an array of 3d vertices
  // returns trangles as triples of node indices
  protected int[][] delaunay(float[][] vertices) {
    Delaunay_Triangulation triangulation = new Delaunay_Triangulation();
    ArrayList<Point_dt> points = new ArrayList();
    for(int i=0; i<vertices.length; i++) {
      float[] v = vertices[i];
      Point_dt p = new Point_dt(v[0], v[1], v[2]);
      triangulation.insertPoint(p);
      points.add(p);
    }
    ArrayList<int[]> triangles = new ArrayList();
    Iterator<Triangle_dt> i = triangulation.trianglesIterator();
    while(i.hasNext()) {
       Triangle_dt tri = i.next();
       if(!tri.isHalfplane()) {
         triangles.add(new int[] {
           points.indexOf(tri.p1()), 
           points.indexOf(tri.p2()), 
           points.indexOf(tri.p3())
         });
       };
    }
    int[][] a = new int[triangles.size()][];
    triangles.toArray(a);
    return a;
  }
  
}

