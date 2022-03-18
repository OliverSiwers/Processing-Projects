import static processing.core.PApplet.*;

public class Vector3 {
  public float x, y, z;

  public Vector3() {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }

  public Vector3(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Vector3 add(Vector3 v) {
    this.x += v.x;
    this.y += v.y;
    this.z += v.z;
    return this;
  }

  public static Vector3 add(Vector3 v1, Vector3 v2) {
    return new Vector3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
  }

  public Vector3 sub(Vector3 v) {
    this.x -= v.x;
    this.y -= v.y;
    this.z -= v.z;
    return this;
  }

  public static Vector3 sub(Vector3 v1, Vector3 v2) {
    return new Vector3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
  }

  public Vector3 mult(float n) {
    this.x *= n;
    this.y *= n;
    this.z *= n;
    return this;
  }

  public static Vector3 mult(Vector3 v, float n) {
    return new Vector3(v.x*n, v.y*n, v.z*n);
  }

  public Vector3 div(float n) {
    x /= n;
    y /= n;
    z /= n;
    return this;
  }

  public static Vector3 div(Vector3 v, float n) {
    return new Vector3(v.x/n, v.y/n, v.z/n);
  }

  public float dot(float x, float y, float z) {
    return this.x*x + this.y*y + this.z*z;
  }

  public float dot(Vector3 v) {
    return x*v.x + y*v.y + z*v.z;
  }

  static public float dot(Vector3 v1, Vector3 v2) {
    return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;
  }

  public float mag() {
    return (float)Math.sqrt(x*x + y*y + z*z);
  }

  public Vector3 setMag(float len) {
    normalize();
    mult(len);
    return this;
  }

  public Vector3 normalize() {
    float m = mag();
    if (m != 0 && m != 1) {
      div(m);
    }
    return this;
  }

  public Vector3 set(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    return this;
  }

  public Vector3 set(float[] v) {
    x = v[0];
    y = v[1];
    z = v[2];
    return this;
  }

  public Vector3 set(Vector3 v) {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    return this;
  }

  public Vector3 copy() {
    return new Vector3(x, y, z);
  }

  public boolean equals(Vector3 v) {
    return x == v.x && y == v.y && z == v.z;
  }

  public String toString() {
    return("["+x+", "+y+", "+z+"]");
  }

  //rotates along the z axis by theta radians
  Vector3 rotateZ(float theta) {
    float c = (float)Math.cos(theta);
    float s = (float)Math.sin(theta);
    float tmpX = x*c - y*s;
    float tmpY = x*s + y*c;
    this.x = tmpX;
    this.y = tmpY;
    return this;
  }

  //rotates along the y axis by theta radians
  Vector3 rotateY(float theta) {
    float c = (float)Math.cos(theta);
    float s = (float)Math.sin(theta);

    float tmpX = x*c + z*s;
    float tmpZ = -x*s + z*c;
    this.x = tmpX;
    this.z = tmpZ;
    return this;
  }

  //rotates along the x axis by theta radians
  Vector3 rotateX(float theta) {
    float c = (float)Math.cos(theta);
    float s = (float)Math.sin(theta);
    float tmpY = y*c - z*s;
    float tmpZ = y*s + z*c;
    this.y = tmpY;
    this.z = tmpZ;
    return this;
  }

  //used by rotate method
  private static float[][] rotMatrix = new float[3][3];
  private static Vector3 prevAxis = new Vector3();

  private static final float [][] I = {
    {1, 0, 0 }, 
    {0, 1, 0}, 
    {0, 0, 1}
  };

  //rotates vector phi radians around axis
  public Vector3 rotate(Vector3 axis, float phi) {
    if (!prevAxis.equals(axis)) {
      float [][] W = {
        {0, -axis.z, axis.y}, 
        {axis.z, 0, -axis.x}, 
        {-axis.y, axis.x, 0}
      };

      float[][] WW = MM.multMatrices(W, W);

      float a = sin(phi); 
      float b = 2*(sq(sin(phi/2)));

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          rotMatrix[i][j] = I[i][j] + W[i][j] * a + WW[i][j] * b;
        }
      }
      prevAxis = axis.copy();
    }

    float[] result = MM.multMatrices(new float[][] {{x, y, z}}, rotMatrix)[0];

    set(result);
    return this;
  }

  static Vector3 cross(Vector3 u, Vector3 v) {
    return new Vector3(u.y*v.z - u.z*v.y, u.z*v.x - u.x*v.z, u.x*v.y - u.y*v.x);
  }
}
