import smbus
import time
import osc
import os

bus = 0

def init_i2c():
    global bus
    if bus==0:
        try:
            bus = smbus.SMBus(1)
        except:
            print("cannot reach row controllers, check connections")
            bus = 0

def are_eq(a,b):
    return a[0]==b[0] and\
        a[1]==b[1] and\
        a[2]==b[2] and \
        a[3]==b[3]

def are_same(a):
    return a[0]==a[1]==a[2]==a[3]

def convert_quads(data):
    # group into 5 sets of 4
    out = []
    group = []
    for c,i in enumerate(data):
        bit = c%4
        group.append(i)
        if bit==3:
            out.append(group)
            group=[]    
    # reorder
    out = [out[3], out[4], out[2], out[1], out[0]]
    # flip bits
    out = map(lambda i: [1-i[0],i[1],1-i[3],i[2]], out)
    return out

class block_state:
    def __init__(self):
        self.last_decision = 0
        self.last_halt_decision = 0
        self.last_bot_left_value = [0,0,0,0,0]
        self.last_bot_right_value = [0,0,0,0,0]
        self.strength = 0
        self.halt_strength = 0

        
def do_colour_change(v,state):
    decision = 0
    dec=""
    if are_eq(v,[1,0,0,0]):
        decision = 1
        dec="a"
    elif are_eq(v,[0,1,0,0]):
        decision = 2
        dec="b"
    elif are_eq(v,[0,0,1,0]):
        decision = 3
        dec="c"
    elif are_eq(v,[0,0,0,1]):
        decision = 4
        dec="d"
    if are_eq(v,[0,1,1,1]):
        decision = 5
        dec="e"
    elif are_eq(v,[1,0,1,1]):
        decision = 6
        dec="f"
    elif are_eq(v,[1,1,0,1]):
        decision = 7
        dec="g"
    elif are_eq(v,[1,1,1,0]):
        decision = 8
        dec="h"

    if decision>0 and decision==state.last_decision:
        state.strength+=1

        if state.strength>10:
            print "COLOUR SHIFT",dec
            osc.Message("/eval",["(play-now (mul (adsr 0 0.1 1 0.1)"+
                                 "(sine (mul (sine 30) 800))) 0)"+
                                 "(set-warp-yarn! loom warp-yarn-"+dec+")"+
                                 "(set-weft-yarn! loom weft-yarn-"+dec+")"]).sendlocal(8000)
            state.strength=-9999999999999

    else: state.strength=0

    state.last_decision = decision

def do_halt(v,state):
    decision = 0
    if are_eq(v,[1,0,0,0]): decision = 1
    elif are_eq(v,[0,1,0,0]): decision = 2
    elif are_eq(v,[0,0,1,0]): decision = 3
    elif are_eq(v,[0,0,0,1]): decision = 4
    if are_eq(v,[0,1,1,1]): decision = 5
    elif are_eq(v,[1,0,1,1]): decision = 6
    elif are_eq(v,[1,1,0,1]): decision = 7
    elif are_eq(v,[1,1,1,0]): decision = 8

    if decision==1 and decision==state.last_halt_decision:
        state.halt_strength+=1
        print("SHUTDOWN BLOCK DETECTED: "+str((300-state.halt_strength)/10)+" SECONDS")
        
        if state.halt_strength>300:
            # we are running as root...
            os.system("halt")
            print("SHUTDOWN")

    else: state.halt_strength=0

    state.last_halt_decision = decision
        
def quad_to_int(q):
    return (q[0]<<3 | q[1]<<2 | q[2]<<1 | q[3])

def do_bottom_row_raw(quads,state):
    ret = [quad_to_int(quads[0]),
           quad_to_int(quads[1]),
           quad_to_int(quads[2]),
           quad_to_int(quads[3]),
           quad_to_int(quads[4])]

    return ret


def do_bottom_row(quads,state):
    ret = [quads[0][1],
           quads[1][1],
           quads[2][1],
           quads[3][1],
           quads[4][1]]

    # has it changed?
    if not are_eq(quads[4],state.last_bot_left_value):
        # is not all same?
        if not are_same(quads[4]):
            do_colour_change(quads[4],state)
            ret = [quads[0][1],
                   quads[1][1],
                   quads[2][1],
                   quads[3][1],
                   state.last_bot_left_value[1]]
        else:
            state.last_bot_left_value = quads[4]

    if not are_eq(quads[0],state.last_bot_right_value):
        # is not all same?
        if not are_same(quads[0]):
            do_halt(quads[0],state)
        else:
            state.last_bot_right_value = quads[0]

    return ret

def read_all(state):
    try:
        a= bus.read_i2c_block_data(0x35,0)[1:6]
        b= bus.read_i2c_block_data(0x33,0)[1:6]
        c= bus.read_i2c_block_data(0x34,0)[1:6]
        d= bus.read_i2c_block_data(0x32,0)[1:6]
        e= bus.read_i2c_block_data(0x36,0)[1:21]
    except:
        print("can't reach row controllers, check connections...")
        return []

    a.reverse()
    d.reverse()
    e=do_bottom_row(convert_quads(e),state)
    return a+b+c+d+e

def read_all_raw(state):
    try:
        a= bus.read_i2c_block_data(0x35,0)[1:6]
        b= bus.read_i2c_block_data(0x33,0)[1:6]
        c= bus.read_i2c_block_data(0x34,0)[1:6]
        d= bus.read_i2c_block_data(0x32,0)[1:6]
        e= bus.read_i2c_block_data(0x36,0)[1:21]
    except:
        print("can't reach row controllers, check connections...")
        return []
    a.reverse()
    d.reverse()
    e=do_bottom_row_raw(convert_quads(e),state)
    return a+b+c+d+e


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
        osc.Message("/eval",["(loom-update! loom (list \n"+conv+"))"]).sendlocal(8000)


        try:
            osc.Message("/matrix",blocks).sendto("192.168.0.2",8000)
        except Exception:
            pass

    return last

def send_weave_structure_raw(blocks,last):
    weave = blocks

    conv = ""
    for n,i in enumerate(weave):
        if i==0: conv+="0 "
        else: conv+="1 "
        if n%5==4: conv+="\n"

    #print conv

    if last!=conv:
        last=conv

        try:
            print("sending to alex:",blocks)
            osc.Message("/matrix",blocks).sendto("192.168.0.2",8000)
        except Exception:
            pass

    return last



last = ""
last_raw = ""

state = block_state()

while 1:
    init_i2c()
    last=send_weave_structure(read_all(state),last)
    last_raw=send_weave_structure_raw(read_all_raw(state),last_raw)

    time.sleep(0.1)
