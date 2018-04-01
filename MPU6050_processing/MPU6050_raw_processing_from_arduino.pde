import processing.serial.*;

Serial port;

short ax, ay, az, gx, gy, gz;
float axg, ayg, azg;
float roll, yaw, pitch;
int buff;
byte[] inbuffer = new byte[12];

short[] teapotPacket = new short[16];  // InvenSense Teapot packet
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
            } else if (serialCount == 14) {
                if (ch == '\r') aligned++; else aligned = 0;
            } else if (serialCount == 15) {
                if (ch == '\r') aligned++; else aligned = 0;
            }
            //println((char)ch + " " + aligned + " " + serialCount);
            serialCount++;
            if (serialCount == 16) serialCount = 0;
        } else {
            if (serialCount > 0 || ch == '$') {
                teapotPacket[serialCount++] = (short)ch;
                if (serialCount == 16) {
                    serialCount = 0; // restart packet byte position
                    
                    ax = (short)((teapotPacket[2] << 8) + teapotPacket[3]);
                    ay = (short)((teapotPacket[4] << 8) + teapotPacket[5]);
                    az = (short)((teapotPacket[6] << 8) + teapotPacket[7]);
                    gx = (short)((teapotPacket[8] << 8) + teapotPacket[9]);
                    gy = (short)((teapotPacket[10] << 8) + teapotPacket[11]);
                    gz = (short)((teapotPacket[12] << 8) + teapotPacket[13]);
                    //ay = (teapotPacket[4] << 8) + teapotPacket[5];
                    //az = (teapotPacket[6] << 8) + teapotPacket[7];
                    //gx = (teapotPacket[8] << 8) + teapotPacket[9];
                    //gy = (teapotPacket[10] << 8) + teapotPacket[11];
                    //gz = (teapotPacket[12] << 8) + teapotPacket[13];
                    
                    //println(ax + "\t" + ay + "\t" + az + "\t" + gx + "\t" + gy + "\t" + gz);
                    
                    axg = 0.5 * (ax / 16384.0f) + 0.5 * axg;
                    ayg = 0.5 * (ay / 16384.0f) + 0.5 * ayg;
                    azg = 0.5 * (az / 16384.0f) + 0.5 * azg;
                    
                    //pitch = atan2(sqrt(axg*axg+azg*azg), ayg);
                    //roll = atan2(azg, -axg);
                    
                    pitch = atan2(ayg, sqrt(axg*axg+azg*azg));
                    roll = atan2(-axg, azg);
                    
                    println(pitch + "\t" + roll);
                    
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
