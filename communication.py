import socket
import serial
import json
import syslog,time,sys
import time
port = '/dev/ttyACM0'
UDP_IP = "your network IP"  #######change here########
UDP_PORT = 5005

sock = socket.socket(socket.AF_INET,
		     socket.SOCK_DGRAM)
sock.bind((UDP_IP,UDP_PORT))

def main(port):
    ard = serial.Serial(port,9600)

    send =""
    time.sleep(1)
    while (1):
	data,addr = sock.recvfrom(1024)
	print time.time()
	send = data
        ard.flush()
	print "data send"
        print (send)
        ard.write(send)

        msg = ard.readline().strip('\n') #ard.read(ard.inWaiting()).strip('\n\r') 
	print "data receive"
        try:
            key = ['result','data']
            value = msg.split('-',2)
            data = dict(zip(key,value))
        except:
            print 'ERROR!'
        print msg


    else:
        print "Exiting"
    exit()

if __name__ == '__main__':
    try:
        main(sys.argv[1] if len(sys.argv) > 1 else port )
    except KeyboardInterrupt:
        ser.close()
