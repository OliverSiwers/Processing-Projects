import java.util.*;

class Mesh {
  Vector3 xAxis = new Vector3(1, 0, 0);
  Vector3 yAxis = new Vector3(0, 1, 0);
  Vector3 zAxis = new Vector3(0, 0, 1);

  Vector3 position = new Vector3(0, 0, 0);
  Vector3[] vertices = new Vector3[0];
  Vector3[] normals = new Vector3[0];
  int[] triangles = new int[0];

  boolean backfaceCulling = true;

  color wireColor = color(255);

  Mesh(float x, float y, float z) {
    position = new Vector3(x, y, z);
  }

  Mesh() {
  }

  void render() {
    PImage output = createImage(width, height, ARGB);
    float[][] zBuffer = new float[width][height];

    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        zBuffer[i][j] = Float.MAX_VALUE;
      }
    }

    int sum = 0;

    output.loadPixels();
    for (int i = 0; i < triangles.length/3; i++) {
      drawFilledTriangle(i, output, zBuffer);
    }
    output.updatePixels();
    image(output, 0, 0);
  }

  void renderVertices() {
    for (int i = 0; i < vertices.length; i++) {
      point(Vector3.add(position, vertices[i]), 1);
    }
  }

  void renderWireFrame() {
    for (int i = 0; i < triangles.length / 3; i++) {
      drawTriangleOutline(i);
    }
  }

  private void drawTriangleOutline(int i) {
    Vector2[] ps = getTriangleMappedToScreen(i);
    pushMatrix();
    stroke(wireColor);
    strokeWeight(1);
    for (int j = 0; j < ps.length-1; j++) {
      for (int k = 1; k < ps.length; k++) {
        line(ps[j].x, ps[j].y, ps[k].x, ps[k].y);
      }
    }
    popMatrix();
  }

  private void drawFilledTriangle(int i, PImage output, float[][] zBuffer) {
    Vector2[] ps = getTriangleMappedToScreen(i);

    if (!backfaceCulling || isCW(ps[0], ps[1], ps[2])) { //backface culling
      Vector3[] verts = getTriangleVertices(i);
      int[] indices = getTriangleIndices(i);

      int minX = width;
      int maxX = 0;
      int minY = height;
      int maxY = 0;
      for (int j = 0; j < ps.length; j++) {
        if (ps[j].x < minX) minX = (int)ps[j].x;
        if (ps[j].x > maxX) maxX = (int)ps[j].x;

        if (ps[j].y < minY) minY = (int)ps[j].y;
        if (ps[j].y > maxY) maxY = (int)ps[j].y;
      }

      minX = max(0, minX) - 2;
      maxX = min(width-1, maxX) + 2;
      minY = max(0, minY) - 2;
      maxY = min(height-1, maxY) + 2;

      for (int k = max(minY, 0); k < min(maxY, height); k++) {
        for (int j = max(minX, 0); j < min(maxX, width); j++) {
          Vector2 bp = barycentricPointOnTriangle(new Vector2(j, k), ps[0], ps[1], ps[2]);

          if (isBarycentricPointOnTriangle(bp)) {

            //Gouraud Shading equation used for finding the z of the point on the mesh
            float z = verts[0].z * (1 - bp.y - bp.x) + verts[1].z * bp.y + verts[2].z * bp.x;

            if (z < zBuffer[j][k]) {
              zBuffer[j][k] = z;

              float L = 200;
              if (normals.length == vertices.length) {

                Vector3 n0 = normals[indices[0]];
                Vector3 n1 = normals[indices[1]];
                Vector3 n2 = normals[indices[2]];

                //Gourdan shading
                Vector3 N = Vector3.mult(n0, 1 - bp.y - bp.x)
                  .add(
                  Vector3.mult(n1, bp.y)
                  ).add(
                  Vector3.mult(n2, bp.x)
                  ).normalize();

                L = light(N)*255;
              }
              output.pixels[j + k*width] = color(i%256, 255, int(L)); //Colored for debug purposes
              output.pixels[j + k*width] = color(int(L)); //Colored for debug purposes
            }
          }
        }
      }
    }
  }

  private Vector2[] getTriangleMappedToScreen(int i) {
    Vector3[] verts = getTriangleVertices(i);

    Vector2[] ps = new Vector2[3];

    for (int j = 0; j < ps.length; j++)
      ps[j] = posOnScreen(Vector3.add(position, verts[j]));

    return ps;
  }

  private int[] getTriangleIndices(int i) {
    int[] indices = new int[3];
    for (int j = 0; j < 3; j++) {
      indices[j] = triangles[i*3 + j];
    }
    return indices;
  }

  private Vector3[] getTriangleVertices(int i) {
    Vector3[] verts = new Vector3[3];
    for (int j = 0; j < 3; j++) {
      verts[j] = vertices[triangles[i*3 + j]];
    }
    return verts;
  }

  void recalculateNormals() {
    if (normals.length != vertices.length)
      normals = new Vector3[vertices.length];

    for (int i = 0; i < normals.length; i++)
      normals[i] = new Vector3(0, 0, 0);


    for (int i = 0; i < triangles.length/3; i++) {
      int ti = i*3;
      int index1 = triangles[ti + 0];
      int index2 = triangles[ti + 1];
      int index3 = triangles[ti + 2];

      Vector3 N = calculateSurfaceNormal(
        vertices[index1], 
        vertices[index2], 
        vertices[index3]);

      normals[index1].add(N);
      normals[index2].add(N);
      normals[index3].add(N);
    }

    for (int i = 0; i < normals.length; i++) {
      normals[i].normalize();
    }
  }

  private Vector3 calculateSurfaceNormal(Vector3 v1, Vector3 v2, Vector3 v3) {
    Vector3 u = Vector3.sub(v2, v1);
    Vector3 v = Vector3.sub(v3, v1);
    return Vector3.cross(u, v).normalize();
  }

  void globalRotate(float xr, float yr, float zr) {
    if (xr != 0) {
      globalRotateX(xr);
    }

    if (yr != 0) {
      globalRotateY(yr);
    }

    if (zr != 0) {
      globalRotateZ(zr);
    }
  }

  void globalRotateX(float phi) {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotateX(phi);
    }
    yAxis.rotateX(phi);
    zAxis.rotateX(phi);
    recalculateNormals();
  }

  void globalRotateY(float phi) {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotateY(phi);
    }
    xAxis.rotateY(phi);
    zAxis.rotateY(phi);
    recalculateNormals();
  }

  void globalRotateZ(float phi) {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotateZ(phi);
    }
    yAxis.rotateZ(phi);
    xAxis.rotateZ(phi);
    recalculateNormals();
  }

  void localRotate(float xr, float yr, float zr) {
    if (xr != 0) 
      localRotateX(xr);
    if (yr != 0) 
      localRotateY(yr);
    if (zr != 0) 
      localRotateZ(zr);
  }

  void localRotateX(float phi) {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotate(xAxis, phi);
      normals[i].rotate(xAxis, phi);
    }
    yAxis.rotate(xAxis, phi);
    zAxis.rotate(xAxis, phi);
    recalculateNormals();
  }

  void localRotateY(float phi) {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotate(yAxis, phi);
    }
    xAxis.rotate(yAxis, phi);
    zAxis.rotate(yAxis, phi);
    recalculateNormals();
  }

  void localRotateZ(float phi) {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotate(zAxis, phi);
    }
    yAxis.rotate(zAxis, phi);
    xAxis.rotate(zAxis, phi);
    recalculateNormals();
  }

  void clear() {
    position = new Vector3(0, 0, 0);
    vertices = new Vector3[0];
    normals = new Vector3[0];
    triangles = new int[0];
  }
}
