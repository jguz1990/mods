xof 0303txt 0032

template Frame {
  <3d82ab46-62da-11cf-ab39-0020af71e433>
  [...]
}

template Matrix4x4 {
  <f6f23f45-7686-11cf-8f52-0040333594a3>
  array FLOAT matrix[16];
}

template FrameTransformMatrix {
  <f6f23f41-7686-11cf-8f52-0040333594a3>
  Matrix4x4 frameMatrix;
}

template Vector {
  <3d82ab5e-62da-11cf-ab39-0020af71e433>
  FLOAT x;
  FLOAT y;
  FLOAT z;
}

template MeshFace {
  <3d82ab5f-62da-11cf-ab39-0020af71e433>
  DWORD nFaceVertexIndices;
  array DWORD faceVertexIndices[nFaceVertexIndices];
}

template Mesh {
  <3d82ab44-62da-11cf-ab39-0020af71e433>
  DWORD nVertices;
  array Vector vertices[nVertices];
  DWORD nFaces;
  array MeshFace faces[nFaces];
  [...]
}

template MeshNormals {
  <f6f23f43-7686-11cf-8f52-0040333594a3>
  DWORD nNormals;
  array Vector normals[nNormals];
  DWORD nFaceNormals;
  array MeshFace faceNormals[nFaceNormals];
}

template Coords2d {
  <f6f23f44-7686-11cf-8f52-0040333594a3>
  FLOAT u;
  FLOAT v;
}

template MeshTextureCoords {
  <f6f23f40-7686-11cf-8f52-0040333594a3>
  DWORD nTextureCoords;
  array Coords2d textureCoords[nTextureCoords];
}

template ColorRGBA {
  <35ff44e0-6c7c-11cf-8f52-0040333594a3>
  FLOAT red;
  FLOAT green;
  FLOAT blue;
  FLOAT alpha;
}

template IndexedColor {
  <1630b820-7842-11cf-8f52-0040333594a3>
  DWORD index;
  ColorRGBA indexColor;
}

template MeshVertexColors {
  <1630b821-7842-11cf-8f52-0040333594a3>
  DWORD nVertexColors;
  array IndexedColor vertexColors[nVertexColors];
}

template VertexElement {
  <f752461c-1e23-48f6-b9f8-8350850f336f>
  DWORD Type;
  DWORD Method;
  DWORD Usage;
  DWORD UsageIndex;
}

template DeclData {
  <bf22e553-292c-4781-9fea-62bd554bdd93>
  DWORD nElements;
  array VertexElement Elements[nElements];
  DWORD nDWords;
  array DWORD data[nDWords];
}

Frame DXCC_ROOT {
  FrameTransformMatrix {
     1.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0000000000000000,
    0.0000000000000000, 1.0000000000000000, 0.0000000000000000, 0.0000000000000000,
    0.0000000000000000, 0.0000000000000000, 1.0000000000000000, 0.0000000000000000,
    0.0000000000000000, 0.0000000000000000, 0.0000000000000000, 1.0000000000000000;;
  }

  Frame 77dqm1r6meua_obj {
    FrameTransformMatrix {
       1.0000000000000000, 0.0000000000000000, -0.0000000000000000, 0.0000000000000000,
      0.0000000000000000, 1.0000000000000000, -0.0000000000000000, 0.0000000000000000,
      -0.0000000000000000, -0.0000000000000000, 1.0000000000000000, -0.0000000000000000,
      0.0000000000000000, 0.0000000000000000, -0.0000000000000000, 1.0000000000000000;;
    }

    Frame Box234_Mesh_003 {
      FrameTransformMatrix {
         1.0000000000000000, 0.0000000000000000, -0.0000000000000000, 0.0000000000000000,
        0.0000000000000000, 1.0000000000000000, -0.0000000000000000, 0.0000000000000000,
        -0.0000000000000000, -0.0000000000000000, 1.0000000000000000, -0.0000000000000000,
        0.0000000000000000, 0.0000000000000000, -0.0000000000000000, 1.0000000000000000;;
      }

      Mesh Box234_Mesh_003_mShape {
        138;
        -0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        -0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        -0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        0.0066749998368323;0.0710960030555725;-0.0895010009407997;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        -0.0066749998368323;0.0710960030555725;-0.0895010009407997;,
        -0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0710960030555725;-0.0895010009407997;,
        -0.0066749998368323;0.0710960030555725;-0.0895010009407997;,
        -0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        -0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        -0.0066749998368323;0.0710960030555725;-0.0895010009407997;,
        -0.0066749998368323;0.1069390028715134;-0.0788870006799698;,
        0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        -0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        -0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        -0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        -0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0066749998368323;0.0964979976415634;-0.0166420005261898;,
        -0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        -0.0066749998368323;0.0591900013387203;-0.0230129994452000;,
        -0.0066749998368323;0.0617659986019135;-0.0502110011875629;,
        -0.0066749998368323;0.0976329967379570;-0.0382240004837513;,
        -0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        -0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        -0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        -0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        -0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        -0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        -0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        -0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        -0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        -0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        -0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        -0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        -0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        -0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        -0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        -0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.0737140029668808;-0.1029340028762817;,
        -0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        -0.0075309998355806;0.1159399971365929;-0.0906220003962517;,
        -0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        -0.0075309998355806;0.1114849969744682;-0.0773179978132248;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.1059409976005554;-0.0935359969735146;,
        0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        -0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        -0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        -0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        -0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        -0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        -0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        -0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;,
        0.0075309998355806;0.0696590021252632;-0.0881550014019012;,
        0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        0.0075309998355806;0.0691689997911453;-0.0862969979643822;,
        0.0075309998355806;0.0991410017013550;-0.0783749967813492;,
        0.0075309998355806;0.1014880016446114;-0.0797609984874725;;
        46;
        3;2,1,0;,
        3;5,4,3;,
        3;8,7,6;,
        3;11,10,9;,
        3;14,13,12;,
        3;17,16,15;,
        3;20,19,18;,
        3;23,22,21;,
        3;26,25,24;,
        3;29,28,27;,
        3;32,31,30;,
        3;35,34,33;,
        3;38,37,36;,
        3;41,40,39;,
        3;44,43,42;,
        3;47,46,45;,
        3;50,49,48;,
        3;53,52,51;,
        3;56,55,54;,
        3;59,58,57;,
        3;62,61,60;,
        3;65,64,63;,
        3;68,67,66;,
        3;71,70,69;,
        3;74,73,72;,
        3;77,76,75;,
        3;80,79,78;,
        3;83,82,81;,
        3;86,85,84;,
        3;89,88,87;,
        3;92,91,90;,
        3;95,94,93;,
        3;98,97,96;,
        3;101,100,99;,
        3;104,103,102;,
        3;107,106,105;,
        3;110,109,108;,
        3;113,112,111;,
        3;116,115,114;,
        3;119,118,117;,
        3;122,121,120;,
        3;125,124,123;,
        3;128,127,126;,
        3;131,130,129;,
        3;134,133,132;,
        3;137,136,135;;

        MeshMaterialList {
          1;
          46;
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
          Material {
            1.0; 1.0; 1.0; 1.000000;;
            1.000000;
            0.000000; 0.000000; 0.000000;;
            0.000000; 0.000000; 0.000000;;
            TextureFilename { ""; }
          }
        }

        MeshNormals {
        138;
        -0.0000000000000000;0.1683000028133392;-0.9857000112533569;,
        -0.0000000000000000;0.1683000028133392;-0.9857000112533569;,
        -0.0000000000000000;0.1683000028133392;-0.9857000112533569;,
        -0.0000000000000000;0.1683000028133392;-0.9857000112533569;,
        -0.0000000000000000;0.1683000028133392;-0.9857000112533569;,
        -0.0000000000000000;0.1683000028133392;-0.9857000112533569;,
        -0.0000000000000000;-0.9747999906539917;-0.2231000065803528;,
        -0.0000000000000000;-0.9904000163078308;-0.1383000016212463;,
        -0.0000000000000000;-0.9904000163078308;-0.1383000016212463;,
        -0.0000000000000000;-0.9904000163078308;-0.1383000016212463;,
        -0.0000000000000000;-0.9747999906539917;-0.2231000065803528;,
        -0.0000000000000000;-0.9747999906539917;-0.2231000065803528;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;0.9728999733924866;0.2310000061988831;,
        -0.0000000000000000;0.9865999817848206;0.1631000041961670;,
        -0.0000000000000000;0.9865999817848206;0.1631000041961670;,
        -0.0000000000000000;0.9865999817848206;0.1631000041961670;,
        -0.0000000000000000;0.9728999733924866;0.2310000061988831;,
        -0.0000000000000000;0.9728999733924866;0.2310000061988831;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;-0.9986000061035156;-0.0524999983608723;,
        -0.0000000000000000;-0.9986000061035156;-0.0524999983608723;,
        -0.0000000000000000;-0.9904000163078308;-0.1383000016212463;,
        -0.0000000000000000;-0.9904000163078308;-0.1383000016212463;,
        -0.0000000000000000;-0.9904000163078308;-0.1383000016212463;,
        -0.0000000000000000;-0.9986000061035156;-0.0524999983608723;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;0.9955000281333923;0.0943000018596649;,
        -0.0000000000000000;0.9955000281333923;0.0943000018596649;,
        -0.0000000000000000;0.9865999817848206;0.1631000041961670;,
        -0.0000000000000000;0.9865999817848206;0.1631000041961670;,
        -0.0000000000000000;0.9865999817848206;0.1631000041961670;,
        -0.0000000000000000;0.9955000281333923;0.0943000018596649;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;-0.2799000144004822;0.9599999785423279;,
        -0.0000000000000000;-0.2799000144004822;0.9599999785423279;,
        0.0000000000000000;-0.2802999913692474;0.9599000215530396;,
        0.0000000000000000;-0.2802999913692474;0.9599000215530396;,
        -0.0000000000000000;-0.2800999879837036;0.9599999785423279;,
        -0.0000000000000000;-0.2799000144004822;0.9599999785423279;,
        -0.0000000000000000;0.2373999953269958;-0.9714000225067139;,
        -0.0000000000000000;0.2373999953269958;-0.9714000225067139;,
        -0.0000000000000000;0.2373999953269958;-0.9714000225067139;,
        -0.0000000000000000;0.2373999953269958;-0.9714000225067139;,
        -0.0000000000000000;0.2373999953269958;-0.9714000225067139;,
        -0.0000000000000000;0.2373999953269958;-0.9714000225067139;,
        -0.0000000000000000;-0.9481999874114990;-0.3174999952316284;,
        -0.0000000000000000;-0.9481999874114990;-0.3174999952316284;,
        -0.0000000000000000;-0.9481999874114990;-0.3174999952316284;,
        -0.0000000000000000;-0.9481999874114990;-0.3174999952316284;,
        -0.0000000000000000;-0.9481999874114990;-0.3174999952316284;,
        -0.0000000000000000;-0.9481999874114990;-0.3174999952316284;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;0.9643999934196472;0.2646000087261200;,
        -0.0000000000000000;0.9643999934196472;0.2646000087261200;,
        -0.0000000000000000;0.9643999934196472;0.2646000087261200;,
        -0.0000000000000000;0.9643999934196472;0.2646000087261200;,
        -0.0000000000000000;0.9668999910354614;0.2549999952316284;,
        -0.0000000000000000;0.9643999934196472;0.2646000087261200;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;-0.2800000011920929;0.9599999785423279;,
        -0.0000000000000000;-0.2800000011920929;0.9599999785423279;,
        -0.0000000000000000;-0.2799000144004822;0.9599999785423279;,
        -0.0000000000000000;-0.2799000144004822;0.9599999785423279;,
        -0.0000000000000000;-0.2799000144004822;0.9599999785423279;,
        -0.0000000000000000;-0.2800000011920929;0.9599999785423279;,
        -0.0000000000000000;0.2554999887943268;-0.9667999744415283;,
        -0.0000000000000000;0.2554999887943268;-0.9667999744415283;,
        -0.0000000000000000;0.2554999887943268;-0.9667999744415283;,
        -0.0000000000000000;0.2554999887943268;-0.9667999744415283;,
        -0.0000000000000000;0.2554999887943268;-0.9667999744415283;,
        -0.0000000000000000;0.2554999887943268;-0.9667999744415283;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;0.9668999910354614;0.2549999952316284;,
        -0.0000000000000000;0.9643999934196472;0.2646000087261200;,
        0.0000000000000000;0.9668999910354614;0.2552999854087830;,
        0.0000000000000000;0.9668999910354614;0.2552999854087830;,
        0.0000000000000000;0.9668999910354614;0.2552999854087830;,
        -0.0000000000000000;0.9668999910354614;0.2549999952316284;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        1.0000000000000000;0.0000000000000000;0.0000000000000000;,
        -0.0000000000000000;-0.5084999799728394;-0.8611000180244446;,
        -0.0000000000000000;-0.5084999799728394;-0.8611000180244446;,
        -0.0000000000000000;-0.5084999799728394;-0.8611000180244446;,
        -0.0000000000000000;-0.5084999799728394;-0.8611000180244446;,
        -0.0000000000000000;-0.5084999799728394;-0.8611000180244446;,
        -0.0000000000000000;-0.5084999799728394;-0.8611000180244446;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;,
        -1.0000000000000000;-0.0000000000000000;0.0000000000000000;;
        46;
        3;2,1,0;,
        3;5,4,3;,
        3;8,7,6;,
        3;11,10,9;,
        3;14,13,12;,
        3;17,16,15;,
        3;20,19,18;,
        3;23,22,21;,
        3;26,25,24;,
        3;29,28,27;,
        3;32,31,30;,
        3;35,34,33;,
        3;38,37,36;,
        3;41,40,39;,
        3;44,43,42;,
        3;47,46,45;,
        3;50,49,48;,
        3;53,52,51;,
        3;56,55,54;,
        3;59,58,57;,
        3;62,61,60;,
        3;65,64,63;,
        3;68,67,66;,
        3;71,70,69;,
        3;74,73,72;,
        3;77,76,75;,
        3;80,79,78;,
        3;83,82,81;,
        3;86,85,84;,
        3;89,88,87;,
        3;92,91,90;,
        3;95,94,93;,
        3;98,97,96;,
        3;101,100,99;,
        3;104,103,102;,
        3;107,106,105;,
        3;110,109,108;,
        3;113,112,111;,
        3;116,115,114;,
        3;119,118,117;,
        3;122,121,120;,
        3;125,124,123;,
        3;128,127,126;,
        3;131,130,129;,
        3;134,133,132;,
        3;137,136,135;;
        }

        MeshTextureCoords {
        138;
        0.1081369966268539;0.2281559705734253;,
        0.1506009995937347;0.2281559705734253;,
        0.1506009995937347;0.1085680127143860;,
        0.1506009995937347;0.1085680127143860;,
        0.1081369966268539;0.1085669994354248;,
        0.1081369966268539;0.2281559705734253;,
        0.4734910130500793;0.3896849751472473;,
        0.4734910130500793;0.2598130106925964;,
        0.4310260117053986;0.2598130106925964;,
        0.4310260117053986;0.2598130106925964;,
        0.4310260117053986;0.3896849751472473;,
        0.4734910130500793;0.3896849751472473;,
        0.2554050087928772;0.4182500243186951;,
        0.1373820006847382;0.4037979841232300;,
        0.1287840008735657;0.5319670438766479;,
        0.1287840008735657;0.5319670438766479;,
        0.2476080060005188;0.5507090091705322;,
        0.2554050087928772;0.4182500243186951;,
        0.4295850098133087;0.3896849751472473;,
        0.4295850098133087;0.2640910148620605;,
        0.3871200084686279;0.2640910148620605;,
        0.3871200084686279;0.2640910148620605;,
        0.3871200084686279;0.3896849751472473;,
        0.4295850098133087;0.3896849751472473;,
        0.1273420006036758;0.6045570373535156;,
        0.1195449978113174;0.4720969796180725;,
        0.0007210000185296;0.4908409714698792;,
        0.0007210000185296;0.4908409714698792;,
        0.0093179997056723;0.6190090179443359;,
        0.1273420006036758;0.6045570373535156;,
        0.4734910130500793;0.1911060214042664;,
        0.4310260117053986;0.1911060214042664;,
        0.4310260117053986;0.2598130106925964;,
        0.4310260117053986;0.2598130106925964;,
        0.4734910130500793;0.2598130106925964;,
        0.4734910130500793;0.1911060214042664;,
        0.1350120007991791;0.6186419725418091;,
        0.2554050087928772;0.6190090179443359;,
        0.2476080060005188;0.5507090091705322;,
        0.2476080060005188;0.5507090091705322;,
        0.1287840008735657;0.5319670438766479;,
        0.1350120007991791;0.6186419725418091;,
        0.4295850098133087;0.1774219870567322;,
        0.3871200084686279;0.1774219870567322;,
        0.3871200084686279;0.2640910148620605;,
        0.3871200084686279;0.2640910148620605;,
        0.4295850098133087;0.2640910148620605;,
        0.4295850098133087;0.1774219870567322;,
        0.1195449978113174;0.4720969796180725;,
        0.1273420006036758;0.4037969708442688;,
        0.0069490000605583;0.4041650295257568;,
        0.0069490000605583;0.4041650295257568;,
        0.0007210000185296;0.4908409714698792;,
        0.1195449978113174;0.4720969796180725;,
        0.6377679705619812;0.2234169840812683;,
        0.5898569822311401;0.2234129905700684;,
        0.5898569822311401;0.2557280063629150;,
        0.5898569822311401;0.2557280063629150;,
        0.6377679705619812;0.2557319998741150;,
        0.6377679705619812;0.2234169840812683;,
        0.6392099857330322;0.1198019981384277;,
        0.6392099857330322;0.1519659757614136;,
        0.6871219873428345;0.1519659757614136;,
        0.6871219873428345;0.1519659757614136;,
        0.6871219873428345;0.1198019981384277;,
        0.6392099857330322;0.1198019981384277;,
        0.6817830204963684;0.1183599829673767;,
        0.6817830204963684;0.0704489946365356;,
        0.6392109990119934;0.0704489946365356;,
        0.6392109990119934;0.0704489946365356;,
        0.6392109990119934;0.1183599829673767;,
        0.6817830204963684;0.1183599829673767;,
        0.5297849774360657;0.3565580248832703;,
        0.4837509989738464;0.3552309870719910;,
        0.4851930141448975;0.3879309892654419;,
        0.4851930141448975;0.3879309892654419;,
        0.5297849774360657;0.3896859884262085;,
        0.5297849774360657;0.3565580248832703;,
        0.7873330116271973;0.3573610186576843;,
        0.8352439999580383;0.3573610186576843;,
        0.8352439999580383;0.3100849986076355;,
        0.8352439999580383;0.3100849986076355;,
        0.7873330116271973;0.3100849986076355;,
        0.7873330116271973;0.3573610186576843;,
        0.7858909964561462;0.3580210208892822;,
        0.7858909964561462;0.2512400150299072;,
        0.7398570179939270;0.2525680065155029;,
        0.7398570179939270;0.2525680065155029;,
        0.7371500134468079;0.3572390079498291;,
        0.7858909964561462;0.3580210208892822;,
        0.6377679705619812;0.1192589998245239;,
        0.5898569822311401;0.1192550063133240;,
        0.5898569822311401;0.2234129905700684;,
        0.5898569822311401;0.2234129905700684;,
        0.6377679705619812;0.2234169840812683;,
        0.6377679705619812;0.1192589998245239;,
        0.6392099857330322;0.2557309865951538;,
        0.6871219873428345;0.2557309865951538;,
        0.6871209740638733;0.1591889858245850;,
        0.6871209740638733;0.1591889858245850;,
        0.6392099857330322;0.1591889858245850;,
        0.6392099857330322;0.2557309865951538;,
        0.5297849774360657;0.2497770190238953;,
        0.4810450077056885;0.2505589723587036;,
        0.4837509989738464;0.3552309870719910;,
        0.4837509989738464;0.3552309870719910;,
        0.5297849774360657;0.3565580248832703;,
        0.5297849774360657;0.2497770190238953;,
        0.7858909964561462;0.2512400150299072;,
        0.7858909964561462;0.2181130051612854;,
        0.7412989735603333;0.2198669910430908;,
        0.7412989735603333;0.2198669910430908;,
        0.7398570179939270;0.2525680065155029;,
        0.7858909964561462;0.2512400150299072;,
        0.7873330116271973;0.3100849986076355;,
        0.8352439999580383;0.3100849986076355;,
        0.8352439999580383;0.3041399717330933;,
        0.8352439999580383;0.3041399717330933;,
        0.7873330116271973;0.3041399717330933;,
        0.7873330116271973;0.3100849986076355;,
        0.7371500134468079;0.3572390079498291;,
        0.7398570179939270;0.2525680065155029;,
        0.7335379719734192;0.2585009932518005;,
        0.7335379719734192;0.2585009932518005;,
        0.7310389876365662;0.3570809960365295;,
        0.7371500134468079;0.3572390079498291;,
        0.6871219873428345;0.1519659757614136;,
        0.6392099857330322;0.1519659757614136;,
        0.6392099857330322;0.1591889858245850;,
        0.6392099857330322;0.1591889858245850;,
        0.6871209740638733;0.1591889858245850;,
        0.6871219873428345;0.1519659757614136;,
        0.4837509989738464;0.3552309870719910;,
        0.4810450077056885;0.2505589723587036;,
        0.4749340116977692;0.2507169842720032;,
        0.4749340116977692;0.2507169842720032;,
        0.4774320125579834;0.3492980003356934;,
        0.4837509989738464;0.3552309870719910;;
        }
      }

    }

  }

}
