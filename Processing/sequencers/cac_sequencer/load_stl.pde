

//  Loading meshes from STL using the HE-Mesh library

import wblut.hemesh.core.*;
import wblut.hemesh.creators.*;
import java.io.*;


ArrayList<CAC_Mesh> meshes = new ArrayList();

// load all meshes from the data folder
void loadMeshes() {
  String path = dataPath("");
  String ending = ".stl";
  String[] filenames = getFilenames(path, ending);
  for(String filename : filenames) {
    meshes.add(loadMesh(dataPath(filename)));
  }
}

// locate files in the given folder by file ending
String[] getFilenames(String path, final String ending) {
  File folder = new java.io.File(path);
  FilenameFilter stlFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(ending);
    }
  };
  return folder.list(stlFilter); 
}

// load a half-edge mesh from STL
CAC_Mesh loadMesh(String path) {
  HEC_Creator creator = new HEC_FromBinarySTLFile(path);
  HE_Mesh hemesh = new HE_Mesh(creator);
  CAC_Sequencer sequencer = new CAC_ContinuousSequencer(CLOCKWISE);
  return new CAC_Mesh(hemesh, sequencer);
}

