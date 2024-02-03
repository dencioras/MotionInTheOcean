class Background {

  // Color for filling in shape
  color colorFill = color(11, 10, 56); // The background color for the visuals is RGB(11, 10, 56)

  // Variable related to particals
  int n = 2000;
  PVector[] ps = new PVector[n];

  Background() {
    for (int i = 0; i < n; i++) {
      ps[i] = new PVector(random(width), random(height));
    }
  }

  void renderVisuals(PVector point) {
    fill(0, 10);
    noStroke();
    rect(0, 0, width, height);
    stroke(0, 0, 255);
    float f1 = 0.015 * frameCount;
    float f2 = 0.01 * frameCount;

    for (int i = 0; i < n; i++) {
      PVector p = ps[i];

      // Calculate the vector pointing away from the mouse
      PVector awayFromPoint = PVector.sub(p, point);
      awayFromPoint.mult(1500.0 / (awayFromPoint.magSq() + 1)); // Adjust the strength of avoidance

      float theta = noise(0.001 * p.x, 0.001 * p.y) * 4 * PI;
      PVector a = new PVector(cos(theta), sin(theta));
      PVector b = new PVector(cos(f1), cos(f2));
      PVector v = PVector.lerp(a, b, 0.4);

      // Add the avoidance vector to the movement vector
      v.add(awayFromPoint);
      p.add(v);

      if (0.005 > random(1.0) || p.x < 0 || p.x > width || p.y < 0 || p.y > height)
        ps[i] = new PVector(random(width), random(height));

      float mag = v.mag();
      strokeWeight(1 + 0.6 / (0.01 + mag));
      stroke(100 * mag, 255, 255);
      point(p.x, p.y);
    }
  }
}
