
// CAC_Sequencers creates an ordering over the Edges of a Mesh,
// thus serializing the Process of Mesh Creation into Individual Steps.

// special sequencing mode for meandering sequences:
// changing directions every time we do backtracking
final int MEANDERING = 0;

// interface for sequencers
interface CAC_Sequencer {
  List<HE_Edge> createSequence(HE_Mesh hemesh);
};

// A Sequencer that uses Backtracking, if it gets stuck ...
class CAC_BacktrackingSequencer extends CAC_ContinuousSequencer {
 
  boolean meandering;
   
  CAC_BacktrackingSequencer(int mode) {
    super(mode);
    if (mode == MEANDERING) {
      mode = CLOCKWISE;
      meandering = true; 
    }
  }
    
   List<HE_Edge> createSequence(HE_Mesh hemesh) {
     
    // pool is a selection of available edges, seq the computed edge sequence
    HE_Selection pool = new HE_Selection(hemesh).selectAll(hemesh);
    List<HE_Edge> seq = new ArrayList();

    // start at a random position - just for the fun of it
    HE_Halfedge he = randomEdge(pool).getHalfedge();
    addSequence(he, pool, seq, mode);
    
    // now keep backtracking until all edges are covered
    while( pool.numberOfEdges() > 0) {
      
      // alternate between clockwise and anticlockwise direction
      if(meandering)  mode *= -1;
      
      he = backtrackEdge(seq, pool);
      
      // escape if backtracking fails (should never happen really)
      if(he==null) break; 
      addSequence(he, pool, seq, mode);
    }
    
    return seq;

   }
  
  HE_Halfedge backtrackEdge(List<HE_Edge> seq, HE_Selection pool) {
    ListIterator<HE_Edge> i = seq.listIterator(seq.size());
    while(i.hasPrevious()) {
      HE_Edge edge = i.previous();
      HE_Face face = edge.getFirstFace();
      if(face != null && pool.contains(face)) {
        return edge.getHalfedge();
      } 
      face = edge.getSecondFace();
      if(face != null && pool.contains(face)) {
        return edge.getHalfedge().getPair();
      }
    } 
    return null;
  }
  
}
