CAC Processing Tools
--------------------

These are the Processing Tools for Computer Augmented Crafts.
The sketches have been developed for Processing 1.5.1.
They will not work in Processing 2.0 without modification.
For your convenience the Processing Libraries are included 
inside the code folder of each sketch.

### Generators

The CAC Generators allow you to generate simple STL-Meshes.
The provided generators create an arrangement of points,
using the Delaunay Triangulation to connect them to a mesh.

### Sequencer

The CAC Sequencer takes any mesh in STL format and turns it into 
a construction sequence for the CAC Assistant.
The sequence is saved in SEQ format.

### Validator

There are physical limitations of the CAC setup, 
which in turn impose constraints on the input mesh, 
like minimum and  maximum edgelength. 
Use the CAC Validator to check if all edges are 
within the critical range, and resize the mesh if necessary.

### Assistant

The CAC Assistant is the programm running on the CAC Setup
and is not part of this distribution. 
Drop your STL and SEQ file inside a folder named  _CAC 
on your USB stick, plug it in, and you are ready to shape 
the future of Computer Augmented Crafts ...


Licensing
---------

The sketches are released under the MIT License.

The Libraries are published under various licenses listed below.
Please make sure to include the respective licenses,
if you chose to redistribute the libraries

* [ **PeasyCam** by Jonathan Feinberg ](http://mrfeinberg.com/peasycam/) -- Apache 2.0
* [ **HEMesh** by Frederik Vanhoutte  ](http://hemesh.wblut.com/) -- LGPL 
* [ **p5magic** by Karsten Schmidt    ](http://hg.postspectacular.com/cp5magic/) -- LGPL
* [ **Java Delaunay Triangulation**   ](http://code.google.com/p/jdt/) -- Apache 2.0
* [ **ToxicLibs** by Karsten Schmidt  ](http://toxiclibs.org/) -- LGPL
* [ **Javolution**  ](http://javolution.org/) -- BSD