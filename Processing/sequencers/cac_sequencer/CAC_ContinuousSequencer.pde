
// A Sequencer that proceeds in a clockwise manner
// Note: does neither jump nor backtrack

// sequencing modes
final int CLOCKWISE = 1;
final int ANTI_CLOCKWISE = -1;

class CAC_ContinuousSequencer implements CAC_Sequencer {
  
  int mode;
  
  CAC_ContinuousSequencer(int mode) {
    this.mode = mode;
  }

  List<HE_Edge> createSequence(HE_Mesh hemesh) {
    
    // pool is a selection of available edges, seq the computed sequence
    HE_Selection pool = new HE_Selection(hemesh).selectAll(hemesh);
    List<HE_Edge> seq = new ArrayList();

    // find the first edge / halfedge
    HE_Halfedge he = getCentralEdge(hemesh).getHalfedge();
    
    // add clockwise sequence
    addSequence(he, pool, seq, mode);
    println("Covered " + seq.size() + "/" + hemesh.numberOfEdges() + " edges");
    return seq;
  }
  
  
  void addSequence(HE_Halfedge he, HE_Selection pool, List<HE_Edge> seq, int direction) {

    HE_Face face = he.getFace();
    while (face != null && pool.contains(face)) {
      // add it to our sequence
      move(he, pool, seq);
      List<HE_Halfedge> fhes = (mode == CLOCKWISE) ? nextHalfedgesClockwise(he, pool) : nextHalfedgesAntiClockwise(he, pool);
      for (HE_Halfedge newHE : fhes) {
        newHE.getEdge().setLabel(OPENING_EDGE);
        move(newHE, pool, seq); // add it to the sequence
        he = newHE.getPair();   // pick the twin of the latest halfedge
      } 
      // change edge type for the last edge in a cycle
      if(fhes.size() >= 1) {
        he.getEdge().setLabel(CLOSING_EDGE);
      }
      // pick the next face
      face = he.getFace();
    }
  }
  
  // Move an Edge from the Selection to the Sequence
  void move(HE_Halfedge he, HE_Selection s1, List<HE_Edge> s2) {
    
    // Removing face + edge + halfedges from the selection
    s1.remove(he);
    s1.remove(he.getPair());
    s1.remove(he.getEdge());  
    s1.remove(he.getFace());
    
    // Adding an Edge to the Sequence - NOTE:  We might want to use a LinkedHashSet rather than an ArrayList ...
    if(!s2.contains(he.getEdge())) {
      s2.add(he.getEdge());
    };
    
  }
  
}


