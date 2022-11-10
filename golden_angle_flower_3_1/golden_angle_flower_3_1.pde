final int seed = 1;
final float golden_angle = PI * (3 - sqrt(5)); //golden angle approximation
final float starting_size = 70; //starting size of the petals
final int steps_per_frame = 5; //number of petals drawn per frame
final float size_to_width = 0.5; //ratio between the size varible and the petal width
final float size_to_height = 1; //ratio between the size varible and the petal height
final float size_decreas = 0.99; //petal size multiplier per step
final float min_size = 1; //stops drawing if size is smaller than this
final float y_max = 250; //the distance between the outermost petal and the center
final float x_off = 0; // the x-offset of the petals before being rotated

final boolean stroke = false; //petal stroke
final float stroke_mult = 2; //petal stroke weight multiplier
final int colors = 255; //number of colors. between 0, 255
final float base_hue = 50; //flower petal base hue. between 0, 255
final float hue_range = 150; //range of the hue. between 0, 255
final float min_saturation = 255; //minimum saturation. between 0, 255
final float max_saturation = 255; //maximum saturation. between 0, 255
final float hue_noise = 1; //hue noise multiplier
final float angle_noise_weight = 0; //weight of the angle in color noise genration
final float size_noise_weight = 0; //weight of the size in color noise genration
final float number_noise_weight = 0.5; //weight of the petal number in color noise genration
final float angle_weight = 256 / TWO_PI * 0; //additional hue added based on the angle
final float size_weight = 0; //additional hue added based on the size
final float number_weight = golden_angle / 3.5 * 0; //additional hue added based on the petal number

float angle = 0; //angle at which the next petal is placed
float size = starting_size; //the size of the next petal

void setup() {
  size(600, 600);
  background(51);
  colorMode(HSB);

  noiseSeed(seed);
  randomSeed(seed);
}

void draw() {
  translate(width/2, height/2);
  scale(0.8);

  if (size >= min_size && !(size <= 0)) {
    for (int i = 0; i < steps_per_frame; i++) {
      if (!(size >= min_size && !(size < 0))) break;

      float hNoise = noise((angle - PI) * angle_noise_weight, size * size_noise_weight, (frameCount * steps_per_frame + i) * number_noise_weight + 0);
      float sNoise = noise((angle - PI) * angle_noise_weight, size * size_noise_weight, (frameCount * steps_per_frame + i) * number_noise_weight + 10000);

      float hue = base_hue + 
        angle*angle_weight + 
        size*size_weight + 
        (frameCount * steps_per_frame + i)*number_weight +
        (hNoise-0.5)*hue_range*hue_noise;

      //float min = base_hue - hue_range/2;
      //float max = base_hue + hue_range/2;
      hue /= 255;
      hue *= colors;
      hue = round(hue);
      hue /= colors;
      println(hue);
      hue *= 255;
      hue = (256 + hue) % 256;
      float saturation = map(sNoise, 0, 1, min_saturation, max_saturation);

      fill(hue, saturation, 255);

      float distOff = -map(size, min_size, starting_size, 0, y_max); //distance offset from center
      println(y_max, distOff);

      pushMatrix();
      rotate(angle);
      petal(x_off, distOff, size*size_to_width, size*size_to_height);
      popMatrix();

      angle += golden_angle;
      angle %= TWO_PI;
      size *= size_decreas;
    }
  }
}

void keyPressed() {
  if (key == 's') {
    String[] s = loadStrings("num.txt");
    String path = "images/image " + s[0] + ".png";
    saveFrame(path);  
    println("saved at " + path);
    saveStrings("data/num.txt", new String[] {(int(s[0]) + 1) + ""});
  }
}
