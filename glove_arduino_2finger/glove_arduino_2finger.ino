// I2C device class (I2Cdev) demonstration Arduino sketch for MPU6050 class
// 10/7/2011 by Jeff Rowberg <jeff@rowberg.net>
// Updates should (hopefully) always be available at https://github.com/jrowberg/i2cdevlib
//
// Changelog:
//      2013-05-08 - added multiple output formats
//                 - added seamless Fastwire support
//      2011-10-07 - initial release

/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2011 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/

// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"
#include "MPU6050.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 accelgyro1(0x68);
MPU6050 accelgyro2(0x69); // <-- use for AD0 high

int16_t ax1, ay1, az1;
int16_t gx1, gy1, gz1;

int16_t ax2, ay2, az2;
int16_t gx2, gy2, gz2;

int16_t f3, f4;

#define FINGER3 A1 // 無名指
#define FINGER4 A0 // 小指


// uncomment "OUTPUT_READABLE_ACCELGYRO" if you want to see a tab-separated
// list of the accel X/Y/Z and then gyro X/Y/Z values in decimal. Easy to read,
// not so easy to parse, and slow(er) over UART.
//#define OUTPUT_READABLE_ACCELGYRO

// uncomment "OUTPUT_BINARY_ACCELGYRO" to send all 6 axes of data as 16-bit
// binary, one right after the other. This is very fast (as fast as possible
// without compression or data loss), and easy to parse, but impossible to read
// for a human.
#define OUTPUT_BINARY_ACCELGYRO

void setup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    // initialize serial communication
    // (38400 chosen because it works as well at 8MHz as it does at 16MHz, but
    // it's really up to you depending on your project)
    Serial.begin(38400);

    // initialize device
    //Serial.println("Initializing I2C devices...");
    accelgyro1.initialize();
    accelgyro2.initialize();

    // verify connection
    //Serial.println("Testing device connections...");
    
    accelgyro1.testConnection();
    accelgyro2.testConnection();
    //Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

    // use the code below to change accel/gyro offset values
    /*
    Serial.println("Updating internal sensor offsets...");
    // -76	-2359	1688	0	0	0
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1688
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    Serial.print("\n");
    accelgyro.setXGyroOffset(220);
    accelgyro.setYGyroOffset(76);
    accelgyro.setZGyroOffset(-85);
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1688
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    Serial.print("\n");
    */
     // number 0
    accelgyro1.setXAccelOffset(-706);
    accelgyro1.setYAccelOffset(-918);
    accelgyro1.setZAccelOffset(607);
    accelgyro1.setXGyroOffset(10479);
    accelgyro1.setYGyroOffset(1337);
    accelgyro1.setZGyroOffset(-319);

    // number 1
    accelgyro2.setXAccelOffset(-221);
    accelgyro2.setYAccelOffset(377);
    accelgyro2.setZAccelOffset(1531);
    accelgyro2.setXGyroOffset(113);
    accelgyro2.setYGyroOffset(-69);
    accelgyro2.setZGyroOffset(-69);
    // configure Arduino LED pin for output
    //pinMode(LED_PIN, OUTPUT);
    pinMode(FINGER3, INPUT);
    pinMode(FINGER4, INPUT);
}

void loop() {
    // read raw accel/gyro measurements from device
    accelgyro1.getMotion6(&ax1, &ay1, &az1, &gx1, &gy1, &gz1);
    accelgyro2.getMotion6(&ax2, &ay2, &az2, &gx2, &gy2, &gz2);

    f3 = analogRead(FINGER3);
    f4 = analogRead(FINGER4);
    

    // these methods (and a few others) are also available
    //accelgyro.getAcceleration(&ax, &ay, &az);
    //accelgyro.getRotation(&gx, &gy, &gz);

    #ifdef OUTPUT_READABLE_ACCELGYRO
        // display tab-separated accel/gyro x/y/z values
        Serial.print("a/g:\t");
        Serial.print(ax); Serial.print("\t");
        Serial.print(ay); Serial.print("\t");
        Serial.print(az); Serial.print("\t");
        Serial.print(gx); Serial.print("\t");
        Serial.print(gy); Serial.print("\t");
        Serial.println(gz);
    #endif

    #ifdef OUTPUT_BINARY_ACCELGYRO
        Serial.write((uint8_t)'$');
        Serial.write((uint8_t)'2');
        Serial.write((uint8_t)(ax1 >> 8)); Serial.write((uint8_t)(ax1 & 0xFF));
        Serial.write((uint8_t)(ay1 >> 8)); Serial.write((uint8_t)(ay1 & 0xFF));
        Serial.write((uint8_t)(az1 >> 8)); Serial.write((uint8_t)(az1 & 0xFF));
        Serial.write((uint8_t)(gx1 >> 8)); Serial.write((uint8_t)(gx1 & 0xFF));
        Serial.write((uint8_t)(gy1 >> 8)); Serial.write((uint8_t)(gy1 & 0xFF));
        Serial.write((uint8_t)(gz1 >> 8)); Serial.write((uint8_t)(gz1 & 0xFF));
        Serial.write((uint8_t)(ax2 >> 8)); Serial.write((uint8_t)(ax2 & 0xFF));
        Serial.write((uint8_t)(ay2 >> 8)); Serial.write((uint8_t)(ay2 & 0xFF));
        Serial.write((uint8_t)(az2 >> 8)); Serial.write((uint8_t)(az2 & 0xFF));
        Serial.write((uint8_t)(gx2 >> 8)); Serial.write((uint8_t)(gx2 & 0xFF));
        Serial.write((uint8_t)(gy2 >> 8)); Serial.write((uint8_t)(gy2 & 0xFF));
        Serial.write((uint8_t)(gz2 >> 8)); Serial.write((uint8_t)(gz2 & 0xFF));
        Serial.write((uint8_t)(f3 >> 8)); Serial.write((uint8_t)(f3 & 0xFF));
        Serial.write((uint8_t)(f4 >> 8)); Serial.write((uint8_t)(f4 & 0xFF));
        Serial.write((uint8_t)'\r');
        Serial.write((uint8_t)'\r');
        //Serial.write('$');
    #endif

    // blink LED to indicate activity
    //blinkState = !blinkState;
    //digitalWrite(LED_PIN, blinkState);
}
