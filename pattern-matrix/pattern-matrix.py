import smbus
import time
import osc

bus = smbus.SMBus(1)

def read_all():

    return bus.read_i2c_block_data(0x35,0)[1:6]+\
        bus.read_i2c_block_data(0x33,0)[1:6]+\
        bus.read_i2c_block_data(0x34,0)[1:6]+\
        bus.read_i2c_block_data(0x32,0)[1:6]+\
        bus.read_i2c_block_data(0x36,0)[1:6]


def send_weave_structure(blocks,last):
    weave = blocks

    conv = ""
    for n,i in enumerate(weave):
        conv+=str(i)+" "
        if n%5==4: conv+="\n"

    print conv

    if last!=conv:
        last=conv
        osc.Message("/eval",["(update! (list "+conv+"))"]).sendlocal(8000)
    return last

last = ""

while 1:
    last=send_weave_structure(read_all(),last)
    time.sleep(0.5)
