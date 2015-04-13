import smbus
import time
# for RPI version 1, use "bus = smbus.SMBus(0)"
bus = smbus.SMBus(1)

print bus
# This is the address we setup in the Arduino Program
address = 0x32

for i in range(0,10):
    print ("writing: "+str(address)+" "+str(i)+" to "+str(i*i))
    bus.write_byte_data(address, i, i*i)
    time.sleep(0.1)

print(bus.read_i2c_block_data(address,0))
print(bus.read_i2c_block_data(address,54))

#for i in range(0,10):
#    print("reading:"+str(i))
#    print(bus.read_byte_data(address,i))
#    time.sleep(0.1)

