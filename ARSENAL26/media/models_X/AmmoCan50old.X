xof 0303txt 0032

Frame Root {
  FrameTransformMatrix {
     1.000000, 0.000000, 0.000000, 0.000000,
     0.000000,-0.000000, 1.000000, 0.000000,
     0.000000, 1.000000, 0.000000, 0.000000,
     0.000000, 0.000000, 0.000000, 1.000000;;
  }
  Frame Cube {
    FrameTransformMatrix {
       1.000000, 0.000000, 0.000000, 0.000000,
       0.000000, 1.000000, 0.000000, 0.000000,
       0.000000, 0.000000, 1.000000, 0.000000,
       0.000000, 0.000000, 0.000000, 1.000000;;
    }
    Mesh { // Cube mesh
      8;
      -0.045000;-0.130000; 0.100000;,
      -0.045000;-0.010000; 0.100000;,
      -0.045000;-0.130000;-0.080000;,
      -0.045000;-0.010000;-0.080000;,
       0.045000;-0.130000; 0.100000;,
       0.045000;-0.010000; 0.100000;,
       0.045000;-0.130000;-0.080000;,
       0.045000;-0.010000;-0.080000;;
      6;
      4;2,3,1,0;,
      4;6,7,3,2;,
      4;4,5,7,6;,
      4;0,1,5,4;,
      4;0,4,6,2;,
      4;5,1,3,7;;
      MeshNormals { // Cube normals
        6;
        -1.000000; 0.000000; 0.000000;,
         0.000000;-0.000000;-1.000000;,
         1.000000; 0.000000; 0.000000;,
         0.000000; 0.000000; 1.000000;,
         0.000000;-1.000000;-0.000000;,
         0.000000; 1.000000;-0.000000;;
        6;
        4;0,0,0,0;,
        4;1,1,1,1;,
        4;2,2,2,2;,
        4;3,3,3,3;,
        4;4,4,4,4;,
        4;5,5,5,5;;
      } // End of Cube normals
    } // End of Cube mesh
  } // End of Cube
} // End of Root
