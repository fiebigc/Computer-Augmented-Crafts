
import wblut.core.processing.*;
import wblut.geom.core.*;
import wblut.hemesh.core.*;
import wblut.hemesh.creators.*;
import wblut.hemesh.modifiers.*;
import wblut.hemesh.tools.*;


void pickMesh(int id) {

  HEC_Creator meshCreator = null;
  filename = "";

  switch(id) {
    
    case 0:
      // simple sphere
      meshCreator = new HEC_SphereBowl()
        .setRadius(radius)
        .setUFacets(20)
        .setVFacets(20)
        ;
      filename = "_r" + radius +  "_u20_v20";
      break;
  
    case 1:
      // geodesic sphere based on an isocahedron
      meshCreator = new HEC_GeodesicBowl()
        .setRadius(radius)
        .setType(0)
        .setLevel(2)

        ;
        filename = "_r" + radius +  "_t0_l2";
      break;
  
    case 2:
      // geodesic sphere based on an octahedron
      meshCreator = new HEC_GeodesicBowl()
        .setRadius(radius)
        .setType(2)
        .setLevel(3)
         ;
      filename = "_r" + radius +  "_t2_l3";
      break;
      
    case 3:
      // disc using delaunay triangulation
      meshCreator = new HEC_DelaunayDisc()
        .setRadius(radius)
        .setType(0)
        .setLevel(8)
        .setStep(30)
        ;
      filename = "_r" + radius +  "_t0_l8_s30";   
      break;
      
    case 4:
      // disc using delaunay phyllotaxis 
      meshCreator = new HEC_DelaunayDisc()
        .setRadius(radius)
        .setType(1)
        .setLevel(8)
        .setStep(30)
        ;
      filename = "_r" + radius +  "_t1_l8_s30";  
      break;
      
    case 5:
      // bowl based on delaunay triangulation
      meshCreator = new HEC_DelaunayBowl()
        .setRadius(radius)
        .setLevel(8)
        .setStep(30)
        ;
      
      filename = "_r" + radius +  "_l8_s30";  
      break;  
  }
  
  filename = "hemesh_" + meshCreator.getClass().getSimpleName().substring(4) + filename;
  mesh = new HE_Mesh(meshCreator);

}



public void drawMesh() {

  switch(meshStyle) {
    
    case 0:
      stroke(0);
      strokeWeight(1.5f);
      render.drawEdges(mesh);
      break;
  
    case 1:
      mesh2 = mesh.get().move(0, 1f/zoom, 0);
      stroke(150, 192);
      strokeWeight(2 * zoom);
      render.drawEdges(mesh2);
      stroke(0);
      strokeWeight(1 * zoom);
      render.drawEdges(mesh);
      break;
  
    case 2:
      mesh2 = mesh.get().move(0, 2f/zoom, 0);
      stroke(150, 192);
      strokeWeight(4 * zoom);
      render.drawEdges(mesh2);
      stroke(0);
      strokeWeight(2 * zoom);
      render.drawEdges(mesh);
      break;
  }
  
}

