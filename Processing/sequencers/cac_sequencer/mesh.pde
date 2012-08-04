

List<HE_Halfedge> nextHalfedgesClockwise(HE_Halfedge he, HE_Selection sel) {
    List<HE_Halfedge> result = new ArrayList();
    HE_Halfedge he1 = he.getPrevInFace();
    HE_Halfedge he2 = he.getNextInFace();
    if(he1 != null && sel.contains(he1)) result.add(he1);
    if(he2 != null && sel.contains(he2)) result.add(he2);
    return result;
}

List<HE_Halfedge> nextHalfedgesAntiClockwise(HE_Halfedge he, HE_Selection sel) {
    List<HE_Halfedge> result = new ArrayList();
    HE_Halfedge he1 = he.getPrevInFace();
    HE_Halfedge he2 = he.getNextInFace();
    if(he2 != null && sel.contains(he2)) result.add(he2);
    if(he1 != null && sel.contains(he1)) result.add(he1);
    return result;
}

// get an edge located in the center of the mesh
HE_Edge getCentralEdge(HE_Mesh m) {
  
  // shrink to the core
  HE_Selection s = new HE_Selection(m).selectAll(m);
 
  // return a random edge from the core
  shrinkToCenter(s);
  return randomEdge(s);
}

HE_Edge randomEdge(HE_Selection selection) {
  
  // create a list of edges
  ArrayList<HE_Edge> edges = new ArrayList();
  Iterator<HE_Edge> eItr = selection.eItr();
  while(eItr.hasNext()) {
    edges.add(eItr.next());
  }
  return getRandom(edges);
}

// get a random element from the list
<T> T getRandom (List<T> edges) {
  int pick = int(random(edges.size()));
  return edges.get(pick);
}

// shrink a selection to its very center
void shrinkToCenter(HE_Selection s) {
  HE_Selection sOld = null;
  Iterator eItr = s.eItr();
  while(eItr.hasNext()) {
    sOld = s.get();
    shrink(s);
    eItr = s.eItr();
  }
  s.union(sOld);
}


// there is a bug in HE_Selection.shrink, so we need to reimplement it ...
void shrink(HE_Selection s) {  
  List<HE_Edge> outerEdges = s.getOuterEdges();
  for (HE_Edge e : outerEdges) {
    HE_Halfedge he1 =  e.getHalfedge();
    HE_Halfedge he2 =  e.getHalfedge().getPair();
    HE_Face f1 = he1.getFace();
    HE_Face f2 = he2.getFace();
    s.remove(e);
    s.remove(he1);
    s.remove(he2);
    if (f1 != null && s.contains(f1)) {
      s.remove(f1);
    }
    if (f2 != null && s.contains(f2)) {
      s.remove(f2);
    }
  }
}
