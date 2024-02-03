class KinectRenderer {

  KinectHandler kinectOutput;

  float windowScaleX = 1f;
  float windowScaleY = 1f;

  int[] depthData;

  // The following list is going to be variables that we can use for interacting with visuals
  int pixelsTotal = 0;
  int pixelsMin = 150;
  int totalDepth;
  PVector averagePoint;
  PVector prevAveragePoint;
  PVector averagePointVelocity;
  float averageScale;
  int avgPointYOffset;

  KinectRenderer(KinectPV2 kinectParam) {
    kinectOutput = new KinectHandler(kinectParam);

    windowScaleX = width / 512.0f;
    windowScaleY = height / 424.0f;

    depthData = new int[512*424];

    // Reset pointers PVectors to the middle of the processing window
    averagePoint = new PVector(width / 2, height / 2);
    prevAveragePoint = new PVector(width / 2, height / 2);
    averagePointVelocity = new PVector(0, 0);
    avgPointYOffset = 100;
  }

  void update() {

    kinectOutput.updateDepthData();
    depthData = kinectOutput.getDepthData();
    this.updateAveragePoint();
    this.updateScale();
  }

  void updateScale() {
    if (totalDepth != 0 && pixelsTotal != 0) {
      averageScale = 20000 / float(totalDepth / pixelsTotal);    // scale that is in charge of making the average point bigger or smaller
    }
  }

  // Method for calculating the positions of all pointers.
  void updateAveragePoint() {
    stroke(255, 0, 0);
    fill(255, 0, 0);

    int totalX = 0;
    int totalY = 0;
    pixelsTotal = 0;
    totalDepth = 0;
    
    prevAveragePoint = averagePoint;

    for (int i = 0; i < 512; i++) {
      for (int j = 0; j < 424; j++) {
        int index = i + j * 512;
        if (depthData[index] != 0) {
          pixelsTotal++;
          totalDepth += depthData[index];
          totalX += i;
          totalY += j;
        }
      }
    }

    if (pixelsTotal != 0) {
      averagePoint = new PVector(totalX / pixelsTotal * windowScaleX, totalY / pixelsTotal * windowScaleY - avgPointYOffset);
      averagePointVelocity = new PVector(averagePoint.x - prevAveragePoint.x, averagePoint.y - prevAveragePoint.y);
    } else {
      averagePoint = new PVector(width / 2, height / 2);
    }
  }

  void renderSilhoutte() {
    for (int i = 0; i < 512; i++) {
      for (int j = 0; j < 424; j++) {
        int index = i + j * 512;
        if (depthData[index] > 0) {
          set(int (i * windowScaleX), int (j * windowScaleY), color(40, 40, 150));
        }
      }
    }
  }

  void renderDebugMenu() {
    fill(0);
    rect(0, 0, 425, 110);

    fill(0, 255, 0);
    text("Cur. FPS: " + frameRate + "\n Avg. FPS: " + averageFrames / frameCount, 10, 20);

    String stat;

    stat = "minDepth = " + kinectOutput.getMinDepth();
    text(stat, 10, 65);
    stat = "maxDepth = " + kinectOutput.getMaxDepth();
    text(stat, 10, 80);

    if (pixelsTotal != 0) {
      stat = "Average depth (distance) = " + totalDepth / pixelsTotal;
      totalDepth = 0;
      text(stat, 10, 95);
    }

    text("windowScaleX = " + windowScaleX + " windowScaleY = " + windowScaleY, 160, 20);
  }

  void setAveragePoint(PVector point) {
    averagePoint = point;
  }

  PVector getAveragePoint() {
    return averagePoint;
  }

  PVector getAveragePointVelocity() {
    return averagePointVelocity;
  }

  int getPixelsTotal() {
    return pixelsTotal;
  }

  int getDepthData() {
    return totalDepth;
  }

  int getMinimumPixels() {
    return pixelsMin;
  }

  float getAverageScale() {
    return averageScale;
  }
}
