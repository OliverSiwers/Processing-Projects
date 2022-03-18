float camSpeed = 15;
Camera cam;

int gridW = 100;
int gridH = 100;
int cellSize = 20;

int[][] grid = new int[gridW][gridH];
int[][] deathTime = new int[gridW][gridH];

float recovChance = 0.1;
float spreadChance = 0.5;
float deathChance = 0.1;
float immuneChance = 0;
float rebirthChance = 1;

int lifespan = 100;
int lifeDiff = 20;

int dead = 0;
int recovered = 0;
int sick = 0;
int totalSick = 0;
int susceptible = 0;
int immune = 0;


int t = 0;

Graph graph1;
Graph graph2;

void setup() {
  size(1000, 800);

  randomSeed(4);
  noiseSeed(0);

  cam = new Camera();
  cam.setCenter(700 / 2, height/2);
  cam.move(-gridW*cellSize/2, -gridH*cellSize/2);
  cam.scale = 0.5;

  graph1 = new Graph(700, height-10, 290, 200, cam.hud);
  graph1.addDataset("Sick", 0, gridW*gridH);
  graph1.addDataset("Rec", 0, gridW*gridH);
  graph1.addDataset("Sus", 0, gridW*gridH);
  graph1.addDataset("Immune", 0, gridW*gridH);

  graph2 = new Graph(700, height-220, 290, 200, cam.hud);
  graph2.addDataset("Dead", 0, 600);

  for (int i = 0; i < gridW; i++) {
    for (int j = 0; j < gridH; j++) {
      grid[i][j] = turnAlive();
      deathTime[i][j] = round(random(1, lifespan + round(random(-lifeDiff, lifeDiff))));
    }
  }

  grid[gridW/2][gridH/2] = 3;

  updateStats();

  graph2.append(dead, "Dead");
  graph1.append(immune, "Immune");
  graph1.append(sick, "Sick");
  graph1.append(susceptible, "Sus");
  graph1.append(recovered, "Rec");


  PGraphics h = cam.hud;
  h.beginDraw();
  h.clear();
  h.textAlign(LEFT, TOP);
  h.textSize(25);
  float x = 700;
  h.stroke(0);
  h.fill(102);
  h.rect(x-10, 0, width, height);
  h.fill(255);
  h.text("t=" + t, x, 0);
  h.text("Dead: " + dead, x, 30);
  h.text("Sick: " + sick, x, 60);
  h.text("Total Sick: " + totalSick, x, 90);
  h.text("Recoved: " + recovered, x, 120);
  h.text("Susceptible: " + susceptible, x, 150);
  h.text("Immune: " + immune, x, 180);

  graph1.show("Sick,Rec,Immune,Sus", "+r,b,y,g");
  graph2.show("Dead", "0");
  h.endDraw();
}

void draw() {
  background(51);
  
  step();

  cam.update();
  cam.beginDraw();

  cam.strokeWeight(1);
  for (int i = 0; i < gridW; i++) {
    for (int j = 0; j < gridH; j++) {
      color c = color(255);
      switch (grid[i][j]) {
      case 0: //susceptible
        c = color(0, 255, 0);  
        break;
      case 1: //Immune
        c = color(255, 255, 0);
        break;
      case 2: ////Dead
        c = color(200, 200, 200);  
        break;
      case 3: //Infected
        c = color(255, 0, 0);
        break;
      case 4: //Recovered
        c = color(128, 0, 255);
        break;
      }
      cam.fill(c);

      cam.rect(i*cellSize, j*cellSize, cellSize, cellSize);
    }
  }

  cam.endDraw();
  cam.render();
}

int turnAlive() {
  if (random(1) < immuneChance) {
    return 1;
  } else {
    return 0;
  }
}

void updateStats() {
  susceptible = 0;
  dead = 0;
  immune = 0;
  sick = 0;
  recovered = 0;
  for (int i = 0; i < gridW; i++) {
    for (int j = 0; j < gridH; j++) {
      switch(grid[i][j]) {
      case 0: //susceptible
        susceptible++; 
        break;
      case 1: //Immune
        immune++;
        break;
      case 2:
        dead++;
        break;
      case 3: //Infected
        sick++;
        break;
      case 4: //Recovered
        recovered++;
        break;
      }
    }
  }
}

void step() {
  t++;
  int[][] n = new int[gridW][gridH];
  for (int i = 0; i < gridW; i++) {
    for (int j = 0; j < gridH; j++) {
      n[i][j] = grid[i][j];
      if (grid[i][j] != 2 && deathTime[i][j] <= t) {
        n[i][j] = 2;
      }
    }
  }

  for (int i = 0; i < gridW; i++) {
    for (int j = 0; j < gridH; j++) {
      if (grid[i][j] == 2) {
        if (random(1) < rebirthChance) {
          n[i][j] = turnAlive();
          deathTime[i][j] = t + lifespan + round(random(-lifeDiff, lifeDiff));
          continue;
        }
      } else if (grid[i][j] == 3) {
        if (random(1) < deathChance) {
          n[i][j] = 2;
          continue;
        }

        if (random(1) < recovChance) {
          n[i][j] = 4;
          continue;
        }

        if (i > 0 && n[i-1][j] == 0 && random(1) <= spreadChance) {
          n[i-1][j] = 3;
        }
        if (i < gridW-1 && n[i+1][j] == 0 && random(1) <= spreadChance) {
          n[i+1][j] = 3;
        }
        if (j > 0 && n[i][j-1] == 0 && random(1) <= spreadChance) {
          n[i][j-1] = 3;
        }
        if (j < gridH-1 && n[i][j+1] == 0 && random(1) <= spreadChance) {
          n[i][j+1] = 3;
        }
      }
    }
  }
  grid = n;

  updateStats();

  graph2.append(dead, "Dead");
  graph1.append(immune, "Immune");
  graph1.append(sick, "Sick");
  graph1.append(susceptible, "Sus");
  graph1.append(recovered, "Rec");

  PGraphics h = cam.hud;
  h.beginDraw();
  h.clear();
  h.textAlign(LEFT, TOP);
  h.textSize(25);
  float x = 700;
  h.stroke(0);
  h.fill(102);
  h.rect(x-10, 0, width, height);
  h.fill(255);
  h.text("t=" + t, x, 0);
  h.text("Dead: " + dead, x, 30);
  h.text("Sick: " + sick, x, 60);
  h.text("Total Sick: " + totalSick, x, 90);
  h.text("Recoved: " + recovered, x, 120);
  h.text("Susceptible: " + susceptible, x, 150);
  h.text("Immune: " + immune, x, 180);

  graph1.show("Sick,Rec,Immune,Sus", "+r,b,y,g");
  graph2.show("Dead", "0");
  h.endDraw();
}

void mousePressed(MouseEvent e) {
  if (e.getButton() == 3) {
    cam.dragPoint = cam.screenToCanvas(mouseX, mouseY);
    cam.dragging = true;
  }
}

void mouseReleased(MouseEvent e) {
  cam.dragging = (e.getButton() == 3) ? false : cam.dragging;
}

void keyPressed(KeyEvent e) {
  char c = e.getKey();
  switch(c) {
  case 'w':
    cam.vel.y = camSpeed;
    break;
  case 's':
    cam.vel.y = -camSpeed;
    break;
  case 'a':
    cam.vel.x = camSpeed;
    break;
  case 'd':
    cam.vel.x = -camSpeed;
    break;
  case ' ':
    step();
  }
}

void keyReleased(KeyEvent e) {
  char c = e.getKey();
  switch(c) {
  case 'w':
    cam.vel.y = 0;
    break;
  case 's':
    cam.vel.y = 0;
    break;
  case 'a':
    cam.vel.x = 0;
    break;
  case 'd':
    cam.vel.x = 0;
    break;
  case 'r':
    cam.reset();
    break;
  }
}

void mouseWheel(MouseEvent e) {
  cam.changeScale(e.getCount());
}
