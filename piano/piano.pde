import processing.sound.*;
SoundFile soundC;
SoundFile soundD;
SoundFile soundE;
SoundFile soundF;
SoundFile soundG;

void setup() {
  size(640, 360);
  background(255);
    
  // Load a soundfile from the /data folder of the sketch and play it back
  soundC = new SoundFile(this, "c.wav");
  soundD = new SoundFile(this, "d.wav");
  soundE = new SoundFile(this, "e.wav");
  soundF = new SoundFile(this, "f.wav");
  soundG = new SoundFile(this, "g.wav");
  
}      

void draw() {
}

void keyPressed() {
  switch(key) {
    case '1':
      soundC.play();
      break;
    case '2':
      soundD.play();
      break;
    case '3':
      soundE.play();
      break;
    case '4':
      soundF.play();
      break;
    case '5':
      soundG.play();
      break;
  }
}
