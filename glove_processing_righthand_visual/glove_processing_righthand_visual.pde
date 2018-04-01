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
int buff;
byte[] inbuffer = new byte[12];
int time, oldtime;
int id;

short[] ax1Arr = new short[20];
short[] ay1Arr = new short[20];
short[] az1Arr = new short[20];
short[] gx1Arr = new short[20];
short[] gy1Arr = new short[20];
short[] gz1Arr = new short[20];
short[] ax2Arr = new short[20];
short[] ay2Arr = new short[20];
short[] az2Arr = new short[20];
short[] gx2Arr = new short[20];
short[] gy2Arr = new short[20];
short[] gz2Arr = new short[20];

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
}

void draw() {
  background(17, 22, 29);
  noFill();
  
  // MPU1 raw data charts
  drawChart(ax1Arr, "MPU1: Accel X", 0, 0);
  drawChart(ay1Arr, "MPU1: Accel Y", 230, 0);
  drawChart(az1Arr, "MPU1: Accel Z", 460, 0);
  drawChart(gx1Arr, "MPU1: Gyro  X", 0, 100);
  drawChart(gy1Arr, "MPU1: Gyro  Y", 230, 100);
  drawChart(gz1Arr, "MPU1: Gyro  Z", 460, 100);
 
  // MPU2 raw data charts
  drawChart(ax2Arr, "MPU2: Accel X", 0, 250);
  drawChart(ay2Arr, "MPU2: Accel Y", 230, 250);
  drawChart(az2Arr, "MPU2: Accel Z", 460, 250);
  drawChart(gx2Arr, "MPU2: Gyro  X", 0, 350);
  drawChart(gy2Arr, "MPU2: Gyro  Y", 230, 350);
  drawChart(gz2Arr, "MPU2: Gyro  Z", 460, 350); 
  
  drawCircle(f1, "Index finger", 20, 490);
  drawCircle(f2, "Middle finger", 150, 490);
  drawCircle(f3, "Third finger", 280, 490);
  drawCircle(f4, "Little finger", 410, 490);
  
  drawSerialData();
 
  drawRollPitchYaw(roll1, pitch1, yaw1, "Roll / Pitch / Yaw", 700, 20);
  drawRollPitchYaw(roll2, pitch2, yaw2, "Roll / Pitch / Yaw", 700, 270);
}


void initValues() {
  for(int i = 0; i < 20; ++i){
    ax1Arr[i] = 0;
    ay1Arr[i] = 0;
    az1Arr[i] = 0;
    gx1Arr[i] = 0;
    gy1Arr[i] = 0;
    gz1Arr[i] = 0;
    ax2Arr[i] = 0;
    ay2Arr[i] = 0;
    az2Arr[i] = 0;
    gx2Arr[i] = 0;
    gy2Arr[i] = 0;
    gz2Arr[i] = 0;
    yaw1 = 0;
    yaw2 = 0;
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
                    
                    oldtime = time;
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
                      az1Arr[i] = az1Arr[i+1];
                      gx1Arr[i] = gx1Arr[i+1];
                      gy1Arr[i] = gy1Arr[i+1];
                      gz1Arr[i] = gz1Arr[i+1];
                      ax2Arr[i] = ax2Arr[i+1];
                      ay2Arr[i] = ay2Arr[i+1];
                      az2Arr[i] = az2Arr[i+1];
                      gx2Arr[i] = gx2Arr[i+1];
                      gy2Arr[i] = gy2Arr[i+1];
                      gz2Arr[i] = gz2Arr[i+1];
                    }
                    ax1Arr[19] = ax1;
                    ay1Arr[19] = ay1;
                    az1Arr[19] = az1;
                    gx1Arr[19] = gx1;
                    gy1Arr[19] = gy1;
                    gz1Arr[19] = gz1;
                    ax2Arr[19] = ax2;
                    ay2Arr[19] = ay2;
                    az2Arr[19] = az2;
                    gx2Arr[19] = gx2;
                    gy2Arr[19] = gy2;
                    gz2Arr[19] = gz2;
                    
                    
                    roll1 = degrees(atan2(ay1, az1));
                    roll2 = degrees(atan2(ay2, az2));
                    pitch1 = degrees(atan2(ax1, sqrt(ay1*ay1 + az1*az1)));
                    pitch2 = degrees(atan2(ax2, sqrt(ay2*ay2 + az2*az2)));
                    
                    
                    yaw1 = degrees(radians(yaw1) + gz1*3.5*(time-oldtime)/1000000)*0.99;
                    yaw2 = degrees(radians(yaw2) + gz2*3.5*(time-oldtime)/1000000)*0.99;
                    
                    
                    //print(id + "\t" + time + "\t");
                    //print(ax1 + "\t" + ay1 + "\t" + az1 + "\t" + gx1 + "\t" + gy1 + "\t" + gz1 + "\t");
                    //print(ax2 + "\t" + ay2 + "\t" + az2 + "\t" + gx2 + "\t" + gy2 + "\t" + gz2 + "\t");
                    //println(f1 + "\t" + f2 + "\t" + f3 + "\t" + f4);
                    println(yaw2);

                }
            }
        }
    }
}

void keyPressed() {
  if (key == ESC) {
    saveTable(table, "rightdata.csv");
    exit();
  }
}


void drawChart(short[] arr, String label, int x, int y) {
  pushMatrix();
  noFill();
  translate(x, y);
  strokeWeight(1);
  stroke(81, 125, 120);
  rect(19, 20, 192, 80);
  stroke(113, 247, 235);
  strokeWeight(3);
  //color(113, 247, 235);
  
  beginShape();
  for(int i = 0; i < 20; ++i){ 
    vertex(20+10*i, 60+map(arr[i], -32768, 32768, -40, 40));
  }
  endShape();
  fill(113, 247, 235);
  text(label, 20, 15);
  popMatrix();
}

void drawCircle(int status, String label, int x, int y) {
  pushMatrix();
  translate(x, y);
  if(status == 0) {
    noFill();
  } else {
    fill(80, 80, 80, 230);
  }
  strokeWeight(1);
  stroke(81, 125, 120);
  ellipse(50, 60, 100, 100);
  fill(113, 247, 235);
  text(label, 0, 0);
  popMatrix();
}


void drawSerialData() {
  pushMatrix();
  translate(20, 650);
  fill(113, 247, 235);
  stroke(113, 247, 235);
  strokeWeight(1);
  text("ID", 0, 0);
  text("Time", 50, 0);
  line(90, -10, 90, 25);
  text("ax1", 100, 0);
  text("ay1", 150, 0);
  text("az1", 200, 0);
  text("gx1", 250, 0);
  text("gy1", 300, 0);
  text("gz1", 350, 0);
  line(390, -10, 390, 25);
  text("ax2", 400, 0);
  text("ay2", 450, 0);
  text("az2", 500, 0);
  text("gx2", 550, 0);
  text("gy2", 600, 0);
  text("gz2", 650, 0);
  line(690, -10, 690, 25);
  text("f1", 700, 0);
  text("f2", 720, 0);
  text("f3", 740, 0);
  text("f4", 760, 0);
  
  translate(0, 25);
  fill(230, 230, 230);
  text(id, 0, 0);
  text(time, 50, 0);
  text(ax1, 100, 0);
  text(ay1, 150, 0);
  text(az1, 200, 0);
  text(gx1, 250, 0);
  text(gy1, 300, 0);
  text(gz1, 350, 0);
  text(ax2, 400, 0);
  text(ay2, 450, 0);
  text(az2, 500, 0);
  text(gx2, 550, 0);
  text(gy2, 600, 0);
  text(gz2, 650, 0);
  text(f1, 700, 0);
  text(f2, 720, 0);
  text(f3, 740, 0);
  text(f4, 760, 0);
  popMatrix();
}

void drawRollPitchYaw(float roll, float pitch, float yaw, String label, int x, int y) {
  pushMatrix();
  translate(x, y);
  strokeWeight(1);
  fill(113, 247, 235);
  text(label, 0, 0);
  stroke(200, 200, 200);
  line(0, 100, 160, 100);
  line(80, 20, 80, 180);
  stroke(113, 247, 235);
  fill(81, 125, 120);
  ellipse(map(yaw, 90, -90, 80, -80)+80, map(pitch, 90, -90, 80, -80)+100, 20, 20);
  strokeWeight(8);
  noFill();
  float rollR = -radians(roll); 
  if(rollR < 0){
    //print(rollR);
    arc(80, 100, 180, 180, PI+HALF_PI, PI+HALF_PI-rollR);
  } else {
    arc(80, 100, 180, 180, PI+HALF_PI-rollR, PI+HALF_PI);
  }
  popMatrix();
}
