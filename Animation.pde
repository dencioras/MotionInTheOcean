class Animation {

  int numFrames;
  int currentFrame;
  PImage images[];
  float speed;

  int minRotateThresh;

  int imageWidth, imageHeight;

  Animation(String fileName) {
    imageMode(CENTER);

    imageWidth = 100;
    imageHeight = 50;
    numFrames = 46;
    currentFrame = 0;
    images = new PImage[numFrames];
  
    for (int i = 1; i < numFrames / 2; i++) {
      String imageName = fileName + nf(i * 2 - 1, 2) + ".png";
      println(imageName);
      images[i] = loadImage(imageName);
    }


    speed = 1f;

    minRotateThresh = 3;
  }

  void updateFrame() {

    currentFrame += speed;
    if (currentFrame > numFrames) {
      currentFrame = 0;
    }
  }

  // There is a rare issue with this method, that it throws a "NegativeArraySizeException"
  // It is quite rare, but when it happens the "newWidth" and "newHeight" are extremely large, like 10,000x10,000 large
  void playAnimation(float scale) {
    int newWidth = abs(int(imageWidth * scale));
    int newHeight = abs(int(imageHeight * scale));
    println(scale);
    if (newWidth > 0 && newHeight > 0) {
      images[int(currentFrame % numFrames)].resize(newWidth, newHeight);
      image(images[int(currentFrame % numFrames)], 0, 0, newWidth, newHeight);
      updateFrame();
    }
  }
}
