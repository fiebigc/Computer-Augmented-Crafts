
class HEC_SphereBowl extends HEC_Sphere {
  HE_Mesh createBase() {
    HEM_Modifier slicer = new HEM_Slice()
    .setPlane(WB_Plane.XZ())
    .setCap(false)
    ;
    return super.createBase().modify(slicer);   
  }
}
