public class Camera {
  private PVector pos;
  private float scale;
  private float scaleSpeed;
  private float minScale;
  private float maxScale;
  private PVector center;
  public PVector vel;
  public boolean dragging = false;
  public PVector dragPoint;

  public PGraphics hud;
  public PGraphics canvas;

  public Camera() {
    center = new PVector(width / 2, height / 2);
    pos = new PVector();
    vel = new PVector();
    scale = 1;
    scaleSpeed = 1/20f;
    minScale = 0.1;
    maxScale = 10;

    canvas = createGraphics(width, height);
    hud = createGraphics(width, height);
  }

  //must be called regularly if dragging with the middle mouse button or the vel variable is being used
  public void update() {
    if (!dragging) {
      pos.add(vel);
    } else {
      //find the change in the mouse position and move the camera by that much
      PVector p = screenToCanvas(mouseX, mouseY);
      pos.add(PVector.sub(p, dragPoint));
    }
  }

  //moves the camera
  public void move(float x, float y) {
    pos.add(x, y);
  }

  public void setCenter(float x, float y) {
    center.set(x, y);
  }

  //must be called before drawing to the canvas
  public void beginDraw() {
    canvas.beginDraw();  
    canvas.clear();
  }

  //called when done drawing to the canvas
  public void endDraw() {
    canvas.endDraw();
  }

  //must be called before drawing to the hud
  public void beginHUD() {
    hud.beginDraw();  
    hud.clear();
  }

  //called when done drawing to the hud
  public void endHUD() {
    hud.endDraw();
  }

  public void render() {
    image(canvas, 0, 0);
    image(hud, 0, 0);
  }

  //maps position in the canvas to the screen
  public PVector canvasToScreen(PVector canvasPos) {
    float mx = (pos.x + canvasPos.x) * scale + center.x;
    float my = (pos.y + canvasPos.y) * scale + center.y;

    return new PVector(mx, my);
  }

  //maps position in the canvas to the screen
  public PVector canvasToScreen(float x, float y) {
    float mx = (pos.x + x) * scale + center.x;
    float my = (pos.y + y) * scale + center.y;

    return new PVector(mx, my);
  }

  //maps position on the screen to the canvas
  public PVector screenToCanvas(PVector screenPos) {
    float mx = (screenPos.x - center.x) / scale - pos.x;
    float my = (screenPos.y - center.y) / scale - pos.y;

    return new PVector(mx, my);
  }

  //maps position on the screen to the canvas
  public PVector screenToCanvas(float x, float y) {
    float mx = (x - center.x) / scale - pos.x;
    float my = (y - center.y) / scale - pos.y;

    return new PVector(mx, my);
  }

  //zooms in or out centered on the mouse
  public void changeScale(float amount) {
    PVector before = screenToCanvas(mouseX, mouseY);
    scale = round(constrain(scale - amount * scaleSpeed, minScale, maxScale), 2);
    PVector after = screenToCanvas(mouseX, mouseY);  
    pos.add(PVector.sub(after, before));
  }

  //rests position and scaleing
  public void reset() {
    scale = 1;
    pos.set(0, 0);
  }

  //draws a point on the canvas using game coords
  public void point(float x, float y) {
    PVector p = canvasToScreen(new PVector(x, y));

    if (onScreen(p.x, p.y))
      canvas.point(p.x, p.y);
  }

  //draws a line on the canvas using game coords
  public void line(float x1, float y1, float x2, float y2) {
    PVector p1 = canvasToScreen(x1, y1);
    PVector p2 = canvasToScreen(x2, y2);

    if (onScreen(p1.x, p1.y) || onScreen(p2.x, p2.y))
      canvas.line(p1.x, p1.y, p2.x, p2.y);
  }

  //draws a rect on the canvas using game coords
  public void rect(float x, float y, float w, float h) {
    PVector p = canvasToScreen(x, y);

    if (onScreen(p.x, p.y, w, h))
      canvas.rect(p.x, p.y, w*scale, h*scale);
  }

  //changes canvas stroke
  public void stroke(float v1, float v2, float v3) {
    canvas.stroke(v1, v2, v3);
  }

  //changes canvas stroke
  public void strokeWeight(float v) {
    canvas.strokeWeight(v*scale);
  }

  //changes canvas fill
  public void fill(float v1, float v2, float v3) {
    canvas.fill(v1, v2, v3);
  }

  //changes canvas fill
  public void fill(color c) {
    canvas.fill(c);
  }

  //checks if coord is on the screen
  private boolean onScreen(float x, float y) {
    return onScreen(x, y, 0, 0);
  }

  //checks if coord is on screen with a margin around 
  private boolean onScreen(float x, float y, float margin) {
    return onScreen(x, y, margin, margin);
  }

  //checks if coord is on screen with a different margin for each axis
  private boolean onScreen(float x, float y, float marginX, float marginY) {
    float sw = canvas.strokeWeight;
    return x > -marginX - sw && x < width + marginY + sw && y > -marginX - sw && y < height + marginY + sw;
  }
}

//rounds a float to d number of decimals
float round(float num, float d) {
  return round(num * pow(10, d)) / pow(10, d);
}
