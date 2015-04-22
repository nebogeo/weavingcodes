import smbus
import time
import osc

bus = smbus.SMBus(1)

def read_all():

    a= bus.read_i2c_block_data(0x35,0)[1:6]
    b= bus.read_i2c_block_data(0x33,0)[1:6]
    c= bus.read_i2c_block_data(0x34,0)[1:6]
    d= bus.read_i2c_block_data(0x32,0)[1:6]
    e= bus.read_i2c_block_data(0x36,0)[1:6]

    a.reverse()
    d.reverse()
    e.reverse()
    return a+b+c+d+[e[1],e[0],e[2],e[3],e[4]]

def send_weave_structure(blocks,last):
    weave = blocks

    conv = ""
    for n,i in enumerate(weave):
        if i==0: conv+="0 "
        else: conv+="1 "
        if n%5==4: conv+="\n"

    #print conv

    if last!=conv:
        last=conv
        osc.Message("/eval",["(update! (list \n"+conv+"))"]).sendlocal(8000)
    return last

last = ""

while 1:
    last=send_weave_structure(read_all(),last)
    time.sleep(0.1)
