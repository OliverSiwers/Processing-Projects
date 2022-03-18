void point(Vector3 pos, float L) {
  Vector2 p = posOnScreen(pos.x, pos.y, pos.z);
  if (isOnScreen(p)) {
    pushMatrix();
    strokeWeight(2);
    stroke(255, L*255);
    point(p.x, p.y);
    popMatrix();
  }
}

Mesh torus(float x, float y, float z, float R1, float R2) { //R1 = minor radius, R2 = major radius
  int theta_steps = 60;
  int phi_steps = 80;

  Mesh mesh = new Mesh(x, y, z);
  Vector3[] vertices = new Vector3[theta_steps * phi_steps];
  int[] triangles = new int[theta_steps * phi_steps * 6];

  for (int i = 0; i < theta_steps; i++) {
    float theta = i / (float)theta_steps * TWO_PI;
    float ct = cos(theta);
    float st = sin(theta);

    for (int j = 0; j < phi_steps; j++) {
      float phi = j / (float)phi_steps * TWO_PI;

      float ox = R2+R1*ct; //circle x pre-rotation
      float oy = R1*st; //circle y pre-rotation

      vertices[i*phi_steps + j] = new Vector3(ox, oy, 0).rotateY(phi);
 
      int offset = (i*phi_steps + j)*6;
      triangles[offset + 0] = i*phi_steps + j;                     //i    j
      triangles[offset + 1] = i*phi_steps + (j+1)%phi_steps;       //i    j+1
      triangles[offset + 2] = ((i+1)%theta_steps)*phi_steps + j;   //i+1  j

      triangles[offset + 3] = i*phi_steps + (j+1)%phi_steps;                   //i    j+1
      triangles[offset + 4] = ((i+1)%theta_steps)*phi_steps + (j+1)%phi_steps; //i+1  j+1
      triangles[offset + 5] = ((i+1)%theta_steps)*phi_steps + j;               //i+1  j
    }
  }
  mesh.vertices = vertices;
  mesh.triangles = triangles;

  mesh.recalculateNormals();
  return mesh;
}

//void sphear(float xoff, float yoff, float zoff, float r) {
//  int theta_steps = 50; 
//  int phi_steps = 25; 

//  for (float i = 0; i < phi_steps; i++) {
//    float phi = i / phi_steps * TWO_PI; 
//    for (float j = 0; j < theta_steps; j++) {
//      float theta = j / theta_steps * PI + HALF_PI; 
//      float ct = cos(theta); 
//      float st = sin(theta); 

//      float ox = r*ct; //object x
//      float oy = r*st; //object y

//      float[] pos = rotateY(ox, oy, 0, phi); 
//      pos = add(pos, new float[]{xoff, yoff, zoff}); 

//      float[] N = rotateY(ct, st, 0, phi); 

//      float L = light(N); 

//      point(pos, L, false);
//    }
//  }
//}
