//Source: https://blackpawn.com/texts/pointinpoly/
Vector2 barycentricPointOnTriangle(Vector2 p, Vector2 a, Vector2 b, Vector2 c) {
  Vector2 v0 = Vector2.sub(c, a);
  Vector2 v1 = Vector2.sub(b, a);
  Vector2 v2 = Vector2.sub(p, a);

  float dot00 = Vector2.dot(v0, v0);
  float dot01 = Vector2.dot(v0, v1);
  float dot02 = Vector2.dot(v0, v2);
  float dot11 = Vector2.dot(v1, v1);
  float dot12 = Vector2.dot(v1, v2);

  float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);

  float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
  float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

  return new Vector2(u, v);
}

boolean isCW(Vector2 a, Vector2 b, Vector2 c) {
  boolean b0 = Vector2.cross(Vector2.sub(b, a), Vector2.sub(c, b)) > 0;
  boolean b1 = Vector2.cross(Vector2.sub(c, b), Vector2.sub(a, c)) > 0;

  return b0 && b1;
}

boolean isOnScreen(Vector2 p) {
  return p.x >= 0 && p.x < width && p.y >= 0 && p.y < height;
}

boolean isBarycentricPointOnTriangle(Vector2 v) {
  return (v.x >= 0) && (v.y >= 0) && (v.x + v.y <= 1);
}

//N = surface normal
//lightDir = light direction
float light(Vector3 N, Vector3 lightDir) {
  return constrain(Vector3.dot(N, lightDir), 0, 1); //Cosine between light direction and surface normal. Capped between 0 and 1
}

float light(Vector3 N) {
  return light(N, gLight);
}

Vector2 posOnScreen(float x, float y, float z) {
  float ooz = 1/z;
  float K;
  //if(fov == PI) K = 1E-6;
  //K = sin(PI/2-fov)/sin(fov);
  //K = 1;
  K = fov;
  float px = width/2 + K*ooz*x;
  float py = height/2 - K*ooz*y;
  return new Vector2(px, py);
}

Vector2 posOnScreen(Vector3 pos) {
  return posOnScreen(pos.x, pos.y, pos.z);
}

float triGradient(float u, float v, float a, float b, float c) {
  float b1 = (a*(1-v) + b*v)/2;
  float b2 = (a*(1-u) + c*u)/2;
  return b1*(1-u)+b2*(1-v);
}
