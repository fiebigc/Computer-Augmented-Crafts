
//////////////////////////////////////////////////////
//                                                  //
//                  interaction                     //
//                                                  //
//////////////////////////////////////////////////////

//
//   [space]      switch through meshes
//
//   sequencers:
//
//   [1] ... [5]
//
//   [arrow keys] walk through the sequence
//
//
//   import/export:
//
//   [s] save sequence
//   [l] load sequence


void keyPressed() {
  
  CAC_Sequencer sequencer = null;
  
  switch(key) {
    
    case ' ': 
      meshSelect++;
      break;
      
      
    case '1':
      sequencer = new CAC_ContinuousSequencer(CLOCKWISE);
      mesh.createWalk(sequencer);
      break;
      
    case '2':
      sequencer = new CAC_ContinuousSequencer(ANTI_CLOCKWISE);
      mesh.createWalk(sequencer);
      break;
   
   case '3': 
      sequencer = new CAC_BacktrackingSequencer(CLOCKWISE);
      mesh.createWalk(sequencer);
      break;
      
   case '4': 
      sequencer = new CAC_BacktrackingSequencer(ANTI_CLOCKWISE);
      mesh.createWalk(sequencer);
      break;
      
   case '5': 
      sequencer = new CAC_BacktrackingSequencer(MEANDERING);
      mesh.createWalk(sequencer);
      break;
          
      
    case 'l':
      mesh.loadWalk("cac_sequence.seq");
      break;
      
    case 's':
      mesh.saveWalk("cac_sequence.seq");
      break;
      
      
    case CODED:
      switch(keyCode) {
        
        case UP:
          mesh.lastEdge();
          break;
          
        case RIGHT:
          mesh.nextEdge();
          break;
          
        case DOWN:
          mesh.firstEdge();
          break;
          
        case LEFT:
          mesh.prevEdge();
          break;
      }
      break;
  }
}

