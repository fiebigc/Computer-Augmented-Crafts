
String filename_base;
String file_ending = ".stl";

// Using HeMesh to import/export STL meshes

void importMesh() {
  String filename = selectInput("Select mesh to import");
  if (filename !=null) {
    importMesh(filename);
    // using the filename as a base for export file name
    filename_base = filename.substring(0, filename.lastIndexOf(file_ending));
    println(filename_base);
  }
  else {
    println("Mesh import aborted.");
  }
}


void importMesh(String path) {
  println("Loading mesh from " + path);
  HEC_Creator creator = new HEC_FromBinarySTLFile(path);
  source_mesh = new HE_Mesh(creator);
  updateSourceStats();
  working_mesh = source_mesh.get();
  updateGui();
  gui.getForID("scale_mesh").changeValue(1);
}


void exportMesh() {

  // the original filename is extended by size information
  String filename_base = "export";
  String filename = filename_base + "_bb" + intf(bbx) + "x" + intf(bby) + "x" + intf(bbz) + "_l" + intf(lmin) + "-" + intf(lmax) + file_ending;

  // the export folder can be picked by the user
  String folder = selectFolder("Select folder to export \"" + filename + "\"");

  if (folder != null) { 
    String path = folder + File.separatorChar + filename;
    // String path = dataPath(filename);

    println("Saving mesh to " + path);
    HET_Export.saveToSTL(working_mesh, path, 1.0);
  }
  else {
    println("Mesh export aborted.");
  }
}

// integer format for filenames 
int intf(float x) {
  return int(10 * x); 
}

