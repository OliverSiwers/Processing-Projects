public class Vector2 {
  public float x, y;

  public Vector2() {
    this.x = 0;
    this.y = 0;
  }

  public Vector2(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public Vector2 add(Vector2 v) {
    this.x += v.x;
    this.y += v.y;
    return this;
  }

  public static Vector2 add(Vector2 v1, Vector2 v2) {
    return new Vector2(v1.x + v2.x, v1.y + v2.y);
  }

  public Vector2 sub(Vector2 v) {
    this.x -= v.x;
    this.y -= v.y;
    return this;
  }

  public static Vector2 sub(Vector2 v1, Vector2 v2) {
    return new Vector2(v1.x - v2.x, v1.y - v2.y);
  }

  public float heading() {
    return (float)Math.atan2(y, x);
  }

  public Vector2 mult(float n) {
    this.x *= n;
    this.y *= n;
    return this;
  }

  public static Vector2 mult(Vector2 v1, float n) {
    return new Vector2(v1.x*n, v1.y*n);
  }

  public Vector2 div(float n) {
    x /= n;
    y /= n;

    return this;
  }

  public static Vector2 div(Vector2 v1, float n) {
    return new Vector2(v1.x/n, v1.y/n);
  }

  public float dot(float x, float y) {
    return this.x*x + this.y*y;
  }

  public float dot(Vector2 v) {
    return x*v.x + y*v.y;
  }

  static public float dot(Vector2 v1, Vector2 v2) {
    return v1.x*v2.x + v1.y*v2.y;
  }

  public static float cross(Vector2 v1, Vector2 v2) {
    return v1.x*v2.y - v2.x*v1.y;
  }

  public float mag() {
    return (float)Math.sqrt(x*x + y*y);
  }

  public Vector2 setMag(float len) {
    normalize();
    mult(len);
    return this;
  }

  public Vector2 normalize() {
    float m = mag();
    if (m != 0 && m != 1) {
      div(m);
    }
    return this;
  }

  public Vector2 set(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  }

  public Vector2 set(Vector2 v) {
    this.x = v.x;
    this.y = v.y;
    return this;
  }

  public Vector2 copy() {
    return new Vector2(x, y);
  }

  public String toString() {
    return("["+x+", "+y+"]");
  }
}
