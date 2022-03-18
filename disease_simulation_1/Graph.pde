class Graph {
  float x, y;
  float w, h;
  PGraphics g;

  HashMap<String, Dataset> datasets = new HashMap<String, Dataset>();

  float maxVal = 1000;
  float minVal = 0;

  Graph(float x, float y, float w, float h, PGraphics g) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.g = g;
  }

  void addDataset(String name, float min, float max) {
    datasets.put(name, new Dataset(min, max));
  }

  void setMin(float min) {
    this.minVal = min;
  }

  void setMax(float max) {
    this.maxVal = max;
  }

  void append(float value, String dataset) {
    datasets.get(dataset).append(value);
  }

  void show(String name, String flag) {
    String[] names = name.split(",");
    String[] flags = flag.split(",");

    boolean stack = false; 

    if (flags[0].charAt(0) == '+') {
      flags[0] = flags[0].substring(1, flags[0].length());
      stack = true;
    }

    for (int k = names.length-1; k >= 0; k--) {
      g.beginShape();
      color c = color(255);
      boolean fill = false;
      for (int i = 0; i < flags[k].length(); i++) {
        switch (flags[k].charAt(i)) {
        case 'r':
          c = color(255, 0, 0);
          break;
        case 'g':
          c = color(0, 255, 0);
          break;
        case 'b':
          c = color(0, 0, 255);
          break;
        case 'y':
          c = color(255, 255, 0);
          break;
        case 'm':
          c = color(255, 0, 255);
          break;
        case 'c':
          c = color(0, 255, 255);
          break;
        case '0':
          c = color(0);
          break;
        case '1':
          c = color(255);
          break;
        case 'f':
          fill = true;
          break;
        }
      }

      if (stack) fill = true;

      g.stroke(c);
      if (fill) 
        g.fill(c);
      else
        g.noFill();

      if (fill)
        g.vertex(x, y);

      Dataset data = datasets.get(names[k]);
      for (int i = 0; i < data.size(); i++) {
        float ystack = 0;

        if (stack) {
          for (int j = 0; j < k; j++) {
            ystack += datasets.get(names[j]).get(i);
          }
        }

        if (!fill || (fill && data.get(i) != 0)) {
          float vx = map(i, 0, data.size()-1, 0, w);
          float vy = map(data.get(i)+ystack, data.min, data.max, 0, h);
          g.vertex(x+vx, y-vy);
        }
      }
      if (fill)
        g.vertex(x+w, y);
      g.endShape();
    }
  }
}

class Dataset {
  float min, max;
  FloatList data = new FloatList();

  Dataset(float min, float max) {
    this.min = min;
    this.max = max;
  }

  int size() {
    return data.size();
  }

  float get(int i) {
    return data.get(i);
  }

  void append(float value) {
    data.append(value);
  }
}
