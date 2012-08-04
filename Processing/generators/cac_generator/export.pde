
// Saving meshes to STL using the HE-Mesh library

import wblut.hemesh.core.*;
import wblut.hemesh.creators.*;
import wblut.hemesh.tools.*;

void exportMesh() {
   String filename = filenames[pick] + "_r" + int(r) + "_d" + int(d) + "_n" + int(n) + ".stl";
   String path = dataPath(filename);
   println("Saving mesh to " + path);
   HEC_Creator creator = new HEC_FromFacelist()
      .setVertices(b)
      .setFaces(tri)
      ;
   HE_Mesh mesh = new HE_Mesh(creator);
   HET_Export.saveToSTL(mesh , path, 1.0);
}

