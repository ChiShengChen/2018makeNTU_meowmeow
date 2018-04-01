import socket
import serial
import json
import syslog,time,sys
import time              

UDP_IP = XXX
UDP_PORT = XXX

sock = socket.socket(socket.AF_INET,
		     socket.SOCK_DGRAM)
sock.bind((UDP_IP,UDP_PORT))

s = socket.socket()                    
s.connect((UDP_IP, UDP_PORT))
while (1):
	data,addr = sock.recvfrom(1024)
	print time.time()
	send = data
	print(send)
s.close()