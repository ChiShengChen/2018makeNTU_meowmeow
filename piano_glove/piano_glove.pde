import processing.sound.*;
SoundFile soundC;
SoundFile soundD;
SoundFile soundE;
SoundFile soundF;
SoundFile soundG;


import processing.serial.*;

Serial port;

  
Table table;

short ax1, ay1, az1, gx1, gy1, gz1;
float axg1, ayg1, azg1;
float roll1, yaw1, pitch1;
short ax2, ay2, az2, gx2, gy2, gz2;
float axg2, ayg2, azg2;
float roll2, yaw2, pitch2;
int f1, f2, f3, f4;
int prevF1, prevF2, prevF3, prevF4; // for debounce
int buff;
byte[] inbuffer = new byte[12];
int time;
int id;

short[] ax1Arr = new short[20];
short[] ay1Arr = new short[20];

short[] teapotPacket = new short[32];  // InvenSense Teapot packet
int serialCount = 0;                 // current packet byte position
int aligned = 0;

void setup() {
  
  size(1000, 800);
  background(17, 22, 29);
  
  initValues();
  
  println(Serial.list());
  String portName = Serial.list()[3];
  
  port = new Serial(this, portName, 38400);
  
  table = new Table();
  prevF1 = prevF2 = prevF3 = prevF4 = 0;
  
  table.addColumn("id");
  table.addColumn("time");
  table.addColumn("ax1");
  table.addColumn("ay1");
  table.addColumn("az1");
  table.addColumn("gx1");
  table.addColumn("gy1");
  table.addColumn("gz1");
  table.addColumn("ax2");
  table.addColumn("ay2");
  table.addColumn("az2");
  table.addColumn("gx2");
  table.addColumn("gy2");
  table.addColumn("gz2");
  table.addColumn("f1");
  table.addColumn("f2");
  table.addColumn("f3");
  table.addColumn("f4");
  
  // Load a soundfile from the /data folder of the sketch and play it back
  soundC = new SoundFile(this, "c.wav");
  soundD = new SoundFile(this, "d.wav");
  soundE = new SoundFile(this, "e.wav");
  soundF = new SoundFile(this, "f.wav");
  soundG = new SoundFile(this, "g.wav");
}

void draw() {
  background(17, 22, 29);
  noFill();
  
  // MPU1: AccelX
  strokeWeight(1);
  stroke(81, 125, 120);
  rect(19, 20, 192, 80);
  stroke(113, 247, 235);
  strokeWeight(3);
  //color(113, 247, 235);
  
  beginShape();
  for(int i = 0; i < 20; ++i){ 
    vertex(20+10*i, 60+map(ax1Arr[i], -32768, 32768, -40, 40));
  }
  endShape();
  fill(113, 247, 235);
  text("MPU1: AccelX", 20, 15);
 
  // MPU1: AccelY
  pushMatrix();
  noFill();
  translate(230, 0);
  strokeWeight(1);
  stroke(81, 125, 120);
  rect(19, 20, 192, 80);
  stroke(113, 247, 235);
  strokeWeight(3);
  //color(113, 247, 235);
  
  beginShape();
  for(int i = 0; i < 20; ++i){ 
    vertex(20+10*i, 60+map(ay1Arr[i], -32768, 32768, -40, 40));
  }
  endShape();
  fill(113, 247, 235);
  text("MPU1: AccelY", 20, 15);
  popMatrix();
 
}


void initValues() {
  for(int i = 0; i < 20; ++i){
    ax1Arr[i] = 0;
    ay1Arr[i] = 0;
  }
}

void serialEvent(Serial port) {
  
    while (port.available() > 0) {
        int ch = port.read();
        //print((char)ch);
        if (aligned < 4) {
            // make sure we are properly aligned on a 16-byte packet
            if (ch == '$') {
              serialCount = 0;
            }
            if (serialCount == 0) {
                if (ch == '$') aligned++; else aligned = 0;
            } else if (serialCount == 1) {
                if (ch == '2') aligned++; else aligned = 0;
            } else if (serialCount == 30) {
                if (ch == '\r') aligned++; else aligned = 0;
            } else if (serialCount == 31) {
                if (ch == '\r') aligned++; else aligned = 0;
            }
            println((char)ch + " " + aligned + " " + serialCount);
            serialCount++;
            if (serialCount == 32) serialCount = 0;
        } else {
            if (serialCount > 0 || ch == '$') {
                teapotPacket[serialCount++] = (short)ch;
                if (serialCount == 32) {
                    serialCount = 0; // restart packet byte position
                    
                    time = millis();
                    
                    ax1 = (short)((teapotPacket[2] << 8) + teapotPacket[3]);
                    ay1 = (short)((teapotPacket[4] << 8) + teapotPacket[5]);
                    az1 = (short)((teapotPacket[6] << 8) + teapotPacket[7]);
                    gx1 = (short)((teapotPacket[8] << 8) + teapotPacket[9]);
                    gy1 = (short)((teapotPacket[10] << 8) + teapotPacket[11]);
                    gz1 = (short)((teapotPacket[12] << 8) + teapotPacket[13]);
                    
                    ax2 = (short)((teapotPacket[14] << 8) + teapotPacket[15]);
                    ay2 = (short)((teapotPacket[16] << 8) + teapotPacket[17]);
                    az2 = (short)((teapotPacket[18] << 8) + teapotPacket[19]);
                    gx2 = (short)((teapotPacket[20] << 8) + teapotPacket[21]);
                    gy2 = (short)((teapotPacket[22] << 8) + teapotPacket[23]);
                    gz2 = (short)((teapotPacket[24] << 8) + teapotPacket[25]);
                    
                    f1 = (short)(teapotPacket[26]);
                    f2 = (short)(teapotPacket[27]);
                    f3 = (short)(teapotPacket[28]);
                    f4 = (short)(teapotPacket[29]);
                    
                    if(f1 == 1) {
                      if(prevF1 == 0) {
                        soundC.play();
                      }
                      if(++prevF1 > 10) {
                        prevF1 = 10;
                      }
                    } else if (--prevF1 < 0) {
                      prevF1 = 0;
                    }
                    
                    if(f2 == 1) {
                      if(prevF2 == 0) {
                        soundD.play();
                      }
                      if(++prevF2 > 10) {
                        prevF2 = 10;
                      }
                    } else if (--prevF2 < 0) {
                      prevF2 = 0;
                    }
                    
                    if(f3 == 1) {
                      if(prevF3 == 0) {
                        soundE.play();
                      }
                      if(++prevF3 > 10) {
                        prevF3 = 10;
                      }
                    } else if (--prevF3 < 0) {
                      prevF3 = 0;
                    }
                    
                    if(f4 == 1) {
                      if(prevF4 == 0) {
                        soundF.play();
                      }
                      if(++prevF4 > 10) {
                        prevF4 = 10;
                      }
                    } else if (--prevF4 < 0) {
                      prevF4 = 0;
                    }
                    
                    
                    
                    
                    //ay = (teapotPacket[4] << 8) + teapotPacket[5];
                    //az = (teapotPacket[6] << 8) + teapotPacket[7];
                    //gx = (teapotPacket[8] << 8) + teapotPacket[9];
                    //gy = (teapotPacket[10] << 8) + teapotPacket[11];
                    //gz = (teapotPacket[12] << 8) + teapotPacket[13];
                    
                    TableRow newRow = table.addRow();
                    id = table.getRowCount() - 1;
                    newRow.setInt("id", id);
                    newRow.setInt("time", time);
                    newRow.setInt("ax1", ax1);
                    newRow.setInt("ay1", ay1);
                    newRow.setInt("az1", ay1);
                    newRow.setInt("gx1", gx1);
                    newRow.setInt("gy1", gy1);
                    newRow.setInt("gz1", gy1);
                    newRow.setInt("ax2", ax2);
                    newRow.setInt("ay2", ay2);
                    newRow.setInt("az2", ay2);
                    newRow.setInt("gx2", gx2);
                    newRow.setInt("gy2", gy2);
                    newRow.setInt("gz2", gy2);
                    newRow.setInt("f1", f1);
                    newRow.setInt("f2", f2);
                    newRow.setInt("f3", f3);
                    newRow.setInt("f4", f4);
                    
                    for(int i = 0; i < 19; ++i){
                      ax1Arr[i] = ax1Arr[i+1];
                      ay1Arr[i] = ay1Arr[i+1];
                    }
                    ax1Arr[19] = ax1;
                    ay1Arr[19] = ay1;
                    
                    print(id + "\t" + time + "\t");
                    print(ax1 + "\t" + ay1 + "\t" + az1 + "\t" + gx1 + "\t" + gy1 + "\t" + gz1 + "\t");
                    print(ax2 + "\t" + ay2 + "\t" + az2 + "\t" + gx2 + "\t" + gy2 + "\t" + gz2 + "\t");
                    println(f1 + "\t" + f2 + "\t" + f3 + "\t" + f4);

                }
            }
        }
    }
}


void keyPressed() {
  
}
