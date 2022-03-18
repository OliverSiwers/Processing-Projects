//To do: 
//1. rotate frame of reference together with shape. Rotating along the x axis should rotate along the shapes x azis, not the global x axis

//Might do:
//Flappy Bird with 3D graphics 

public int test = 0;

static final String version = "1.10";

Vector3 gLight = new Vector3(0.5, 1, -1).normalize();

float R1 = 2;
float R2 = 3;

float fov = 300; //Field of view (fov). View zoomes in as fov increases

Mesh torus;
Mesh tri;

//int scale = 20;
//int w = 1200/scale;
//int h = 900/scale;

void setup() {
  size(600, 600);
  noiseSeed(0);

  //new Vector3(2, 3, 1).rotate(new Vector3(1, 0, 0), 0);

  torus = torus(0, 0, 10, R1, R2);
  //torus.rotate(-0.75, -1, -0);

  //tri = new Mesh(0, 0, 5);
  //Vector3[] vertices = {
  //  new Vector3(0, 0, 0), 
  //  new Vector3(1, 0, 0), 
  //  new Vector3(0, 1, 1)
  //};
  //int[] triangles = {
  //  0, 2, 1 
  //};
  //tri.vertices = vertices;
  //tri.triangles = triangles;
  //tri.recalculateNormals();


  torus.globalRotate(-PI/4, 0, 0);

  colorMode(HSB);
}

int n = 0;

void keyPressed() {
  switch(key) {
  case 'w':
    torus.localRotate(-PI/10, 0, 0);
    break;

  case 'a':
    torus.localRotate(0, -PI/10, 0);
    break;
  }
  //println(torus.zAxis);
  //torus.rotateX(PI/4);
  //println(torus.zAxis);
  //tri.rotate(0, 0.1, 0);
  //torus.rotate(0.03, 0.03, 0);
}

void draw() {
  background(51);

  torus.render();

  //torus.rotate(PI/200, PI/200, PI/200);

  torus.globalRotateX(PI/200);
  torus.globalRotateY(PI/50);
  torus.globalRotateZ(PI/200);
  //tri.render();
  //tri.renderVertices();

  textSize(15);
  fill(255);
  textAlign(LEFT, TOP);
  text("FPS: " + (int)frameRate, 10, 10);
}
