import processing.serial.*;

Serial port;

short ax1, ay1, az1, gx1, gy1, gz1;
float axg1, ayg1, azg1;
float roll1, yaw1, pitch1;
short ax2, ay2, az2, gx2, gy2, gz2;
float axg2, ayg2, azg2;
float roll2, yaw2, pitch2;
int buff;
byte[] inbuffer = new byte[12];

short[] teapotPacket = new short[28];  // InvenSense Teapot packet
int serialCount = 0;                 // current packet byte position
int aligned = 0;

void setup() {
  println(Serial.list());
  String portName = Serial.list()[3];
  
  port = new Serial(this, portName, 38400);
  //port.buffer(12);
}

void draw() {
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
            } else if (serialCount == 26) {
                if (ch == '\r') aligned++; else aligned = 0;
            } else if (serialCount == 27) {
                if (ch == '\r') aligned++; else aligned = 0;
            }
            println((char)ch + " " + aligned + " " + serialCount);
            serialCount++;
            if (serialCount == 28) serialCount = 0;
        } else {
            if (serialCount > 0 || ch == '$') {
                teapotPacket[serialCount++] = (short)ch;
                if (serialCount == 28) {
                    serialCount = 0; // restart packet byte position
                    
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
                    //ay = (teapotPacket[4] << 8) + teapotPacket[5];
                    //az = (teapotPacket[6] << 8) + teapotPacket[7];
                    //gx = (teapotPacket[8] << 8) + teapotPacket[9];
                    //gy = (teapotPacket[10] << 8) + teapotPacket[11];
                    //gz = (teapotPacket[12] << 8) + teapotPacket[13];
                    
                    print(ax1 + "\t" + ay1 + "\t" + az1 + "\t" + gx1 + "\t" + gy1 + "\t" + gz1 + "\t");
                    println(ax2 + "\t" + ay2 + "\t" + az2 + "\t" + gx2 + "\t" + gy2 + "\t" + gz2);
                    
                    //axg = 0.5 * (ax / 16384.0f) + 0.5 * axg;
                    //ayg = 0.5 * (ay / 16384.0f) + 0.5 * ayg;
                    //azg = 0.5 * (az / 16384.0f) + 0.5 * azg;
                    
                    //pitch = atan2(sqrt(axg*axg+azg*azg), ayg);
                    //roll = atan2(azg, -axg);
                    
                    //pitch = atan2(ayg, sqrt(axg*axg+azg*azg));
                    //roll = atan2(-axg, azg);
                    
                    //println(pitch + "\t" + roll);
                    
                    //// get quaternion from data packet
                    //q[0] = ((teapotPacket[2] << 8) | teapotPacket[3]) / 16384.0f;
                    //q[1] = ((teapotPacket[4] << 8) | teapotPacket[5]) / 16384.0f;
                    //q[2] = ((teapotPacket[6] << 8) | teapotPacket[7]) / 16384.0f;
                    //q[3] = ((teapotPacket[8] << 8) | teapotPacket[9]) / 16384.0f;
                    //for (int i = 0; i < 4; i++) if (q[i] >= 2) q[i] = -4 + q[i];
                    
                    //// set our toxilibs quaternion to new data
                    //quat.set(q[0], q[1], q[2], q[3]);

                }
            }
        }
    }
}



//void serialEvent(Serial port) { 
//    inbuffer = port.readBytes(12);
    
    
//    ax = (inbuffer[0] << 8) + inbuffer[1];
//    ay = (inbuffer[2] << 8) + inbuffer[3];
//    az = (inbuffer[4] << 8) + inbuffer[5];
//    gx = (inbuffer[6] << 8) + inbuffer[7];
//    gy = (inbuffer[8] << 8) + inbuffer[9];
//    gz = (inbuffer[10] << 8) + inbuffer[11];
    
    //buff = port.read();
    //ax = (buff << 8) + port.read();
    //buff = port.read();
    //ay = (buff << 8) + port.read();
    //buff = port.read();
    //az = (buff << 8) + port.read();
    //buff = port.read();
    //gx = (buff << 8) + port.read();
    //buff = port.read();
    //gy = (buff << 8) + port.read();
    //buff = port.read();
    //gz = (buff << 8) + port.read();
//    println(ax + "\t" + ay + "\t" + az + "\t" + gx + "\t" + gy + "\t" + gz);
//} 
