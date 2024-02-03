class KinectHandler {

  KinectPV2 kinect;

  // Index for going through the rawDepthData array.
  int [] rawDepthData;

  // Variables for adjusting the minimum/maximum depth that the processing window shows (Filters Kinect visual output)
  // These values range from 0 to 4500, I think it corresponds with the distance. 1000 = 1 meter
  int minDepth;
  int maxDepth;

  // If the Q/W keys are pressed, adjust the minDepth
  // If the A/S keys are pressed, adjust the maxDepth
  int depthChange;

  KinectHandler(KinectPV2 kinectParam) {

    // Initialize KinectPV2 object (aka. the Kinect)
    kinect = kinectParam;

    minDepth = 0;
    maxDepth = 1000;

    depthChange = 100;

    // Enable Kinect to send depth data. Allows to use rawDepthData array
    kinect.enableDepthImg(true);

    kinect.init();
  }

  // Method for updating the needed variables for the average point to work correctly
  // Does not draw/render anything, just updates variables
  void updateDepthData() {

    rawDepthData = kinect.getRawDepthData();

    int index;

    for (int i = 0; i < 512; i++) {
      for (int j = 0; j < 424; j++) {
        index = i + j * 512;
        if (!(rawDepthData[index] > minDepth && rawDepthData[index] < maxDepth)) {
          rawDepthData[index] = 0;
        }
      }
    }

    index = 0;
  }

  int[] getDepthData() {
    return rawDepthData;
  }

  int getMinDepth() {
    return minDepth;
  }

  int getMaxDepth() {
    return maxDepth;
  }
}
