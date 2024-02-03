import KinectPV2.*;

Animation defaultAnimation;
Animation loopAnimation;
Background background;
KinectRenderer kinect;

boolean fullScreenOn = true;
boolean showFrames = false;

int minRotateThresh = 30;
// FPS
int averageFrames = 0;

float sealSize = 0.25;

void settings() {
  // In line 62, the third parameter of this line you can either write P2D or JAVA2D
  // P2D takes way too long to reach a stable and relatively faster FPS
  // JAVA2D is the default setting (I think) its not that fast, but its also not that much slower than P2D. Stability points here.
  size(1920, 1080, JAVA2D);

  if (fullScreenOn) {
    fullScreen();
  }
}

void setup() {
  frameRate(60);

  // Animation stuff
  defaultAnimation = new Animation("frame_");
  loopAnimation = new Animation("loop_");

  background = new Background();

  kinect = new KinectRenderer(new KinectPV2(this));
}

void draw() {
  background(20, 0, 40); // If you comment out this line of code, you get the cooler background back. Issue is that everything on the screen leaves trails.
  //println("Avg. point velocity: " + kinect.getAveragePointVelocity().x + " " + kinect.getAveragePointVelocity().y);

  kinect.update();
  background.renderVisuals(kinect.getAveragePoint());

  if (kinect.getPixelsTotal() > kinect.getMinimumPixels()) {
    kinect.renderSilhoutte();
    handleAnimation();
  } else {
    kinect.setAveragePoint(new PVector(width / 2, width / 2));
  }

  if (showFrames) {
    showFPS();
  }
}

void handleAnimation() {
  pushMatrix();
  translate(kinect.getAveragePoint().x, kinect.getAveragePoint().y);

  if (abs(kinect.getAveragePointVelocity().x) > minRotateThresh || abs(kinect.getAveragePointVelocity().y) > minRotateThresh) {
    rotate(radians(90 + degrees(kinect.getAveragePointVelocity().heading())));
  }

  if (abs(kinect.getAveragePointVelocity().x) > 15 || abs(kinect.getAveragePointVelocity().y) > 15) {
    //defaultAnimation.playAnimation(kinect.getAverageScale());
    loopAnimation.playAnimation(kinect.getAverageScale() * sealSize);
  } else {
    defaultAnimation.playAnimation(kinect.getAverageScale() * sealSize);
    // loopAnimation.playAnimation(kinect.getAverageScale() * sealSize);
  }

  popMatrix();
}

void showFPS() {
  fill(0, 255, 0);
  text(frameRate, 15, 15);
}

// Event handler for keys pressed:
void keyPressed() {
  if (key == 'h') {
    showFrames = !showFrames;
  }
}
