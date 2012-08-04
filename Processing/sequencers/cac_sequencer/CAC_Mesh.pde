
// A Mesh including a walk through the edges and a index to the current edge
 
final static int OPENING_EDGE = 0, CLOSING_EDGE = 1;

class CAC_Mesh {

  HE_Mesh hemesh;
  List<HE_Edge> walk;
  int current = 0;
  
  // constructor using a sequencer
  CAC_Mesh(HE_Mesh hemesh, CAC_Sequencer sequencer) {
    this.hemesh = hemesh;
    createWalk(sequencer);
  }
  
   // constructor using a walk file
  CAC_Mesh(HE_Mesh hemesh, String filename) {
    this.hemesh = hemesh;
    loadWalk(filename);
  }
  
  HE_Edge nextEdge() {
    current = min(walk.size() - 1, current + 1);
    return getCurrentEdge();
  }
  
  HE_Edge prevEdge() {
    current = max(0, current - 1);  
    return getCurrentEdge();
  }
  
  HE_Edge firstEdge() {
    current = 0;
    return getCurrentEdge(); 
  }
  
  HE_Edge lastEdge() {
    current = walk.size() - 1;
    return getCurrentEdge();
  }
  
  HE_Edge getCurrentEdge() {
     return walk.get(current);
  }
  
  // load step sequence from a file
  void loadWalk(String filename) {
    
    String path = dataPath(filename);
    int[] data = int(loadStrings(path));

    reset();
    List newWalk = new ArrayList();
    
    for(int i=0; i<data.length; i++) {
      HE_Edge edge = hemesh.getEdgeByKey(data[i]);
      if(edge == null) {
        println("Mesh and Sequence files don't seem to match ... aborting.");
        return;
      }
      newWalk.add(edge);
    }
    walk = newWalk;
    println("Loaded sequence from " + filename);
  }
  
  void reset() {
    current = 0; 
  }
  
  void createWalk(CAC_Sequencer sequencer) {
    reset();
    walk = sequencer.createSequence(hemesh);
  }
  
    // save step sequence to a file
  void saveWalk(String filename) {
    
    // assemble edge keys + types
    String[] data = new String[walk.size()];
    int i = 0;
    for(HE_Edge edge : walk) {
      data[i++] = str(edge.key()) + "\t" + str(edge.getLabel());
    }  
    
    // file format: tab seperated key/type pairs
    String path = dataPath(filename);
    saveStrings(path, data);
    println("Saved sequence (" + walk.size() + " edges) to " + path);
    
  }
  
  // draw the mesh edges with different styles determined by edge labels
  void draw() {
    
    for (int i=0; i<walk.size(); i++) {
      HE_Edge edge = walk.get(i);
      int label = edge.getLabel();
      
      // thick and thin lines for current position
      if(i <= current) {
        // thick lines for visited edges
        float zoom = width / (float) cam.getDistance();
        strokeWeight(4 * zoom);
      } else {
        // thin lines for edges that lie ahead the current one
        strokeWeight(1);
      };
      
      // red and green lines for opening/closing edges 
      switch(label) {
        case OPENING_EDGE:
          stroke(#aaffaa);
          break;
        case CLOSING_EDGE:
          stroke(#ffaaaa);
          break;
      }
      
      gfx.drawEdge(edge);
    }

  }
  
}


