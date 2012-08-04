

class HEC_GeodesicBowl extends HEC_Geodesic {
  HE_Mesh createBase() {
    HEM_Modifier slicer = new HEM_Slice()
    .setPlane(WB_Plane.XY())
    .setCap(false)
    ;
    return super.createBase().modify(slicer);   
  }
}

