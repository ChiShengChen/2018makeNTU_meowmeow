import serial

ser = serial.Serial('/dev/ttyUSB0',38400)
#s = [0,1]
while True:
	read_serial=ser.readline()
	#s[0] = str(int (ser.readline(),16))
	#print s[0]
	print read_serial
