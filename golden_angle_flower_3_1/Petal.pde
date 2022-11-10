//Draws a petal at (x,y) with dimensions (w,h) 
void petal(float x, float y, float w, float h) {
  strokeWeight(constrain(size/starting_size, 0, 1) * stroke_mult);
  stroke(0);
  if (!stroke) noStroke();

  pushMatrix();

  //right half
  translate(x - 2, y);
  beginShape();
  curveVertex(0, -h);
  curveVertex(0, -h);
  curveVertex(w, -h*2/3);
  curveVertex(w, -h*1/3);
  curveVertex(0, 0);
  curveVertex(0, 0);
  endShape();

  //left half
  translate(1, 0);
  beginShape();
  curveVertex(0, -h);
  curveVertex(0, -h);
  curveVertex(-w, -h*2/3);
  curveVertex(-w, -h*1/3);
  curveVertex(0, 0);
  curveVertex(0, 0);
  endShape();

  popMatrix();
}
