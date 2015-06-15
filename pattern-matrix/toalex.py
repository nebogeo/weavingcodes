import smbus
import time
import osc

bus = smbus.SMBus(1)

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

    #print "///////////"
    #print out[4][0], out[4][1]
    #print out[4][3], out[4][2]

    return out

class block_state:
    def __init__(self):
        self.last_decision = 0
        self.last_bot_left_value = [0,0,0,0,0]
        self.strength = 0

        
def do_colour_change(v,state):
    decision = 0
    dec=""
    if are_eq(v,[0,0,0,1]):
        decision = 1
        dec="a"
    elif are_eq(v,[0,0,1,0]):
        decision = 2
        dec="b"
    elif are_eq(v,[0,1,0,0]):
        decision = 3
        dec="c"
    elif are_eq(v,[1,0,0,0]):
        decision = 4
        dec="d"
    elif are_eq(v,[0,1,1,1]):
        decision = 5
        dec="e"

    if decision>0 and decision==state.last_decision:
        state.strength+=1

        if state.strength>10:
            print "COLOUR SHIFT",dec
            osc.Message("/eval",["(play-now (mul (adsr 0 0.1 1 0.1)"+
                                 "(sine (mul (sine 30) 800))) 0)"+
                                 "(set-warp-yarn! loom warp-yarn-"+dec+")"+
                                 "(set-weft-yarn! loom weft-yarn-"+dec+")"]).sendlocal(8000)
            state.strength=-100000

    else: state.strength=0

    state.last_decision = decision
        
def quad_to_int(q):
    return (q[0]<<3 | q[1]<<2 | q[2]<<1 | q[3])

def do_bottom_row(quads,state):
    ret = [quad_to_int(quads[0]),
           quad_to_int(quads[1]),
           quad_to_int(quads[2]),
           quad_to_int(quads[3]),
           quad_to_int(quads[4])]

    return ret

def read_all(state):
    a= bus.read_i2c_block_data(0x35,0)[1:6]
    b= bus.read_i2c_block_data(0x33,0)[1:6]
    c= bus.read_i2c_block_data(0x34,0)[1:6]
    d= bus.read_i2c_block_data(0x32,0)[1:6]
    e= bus.read_i2c_block_data(0x36,0)[1:21]
    a.reverse()
    d.reverse()
    e=do_bottom_row(convert_quads(e),state)

    

    return a+b+c+d+e

def send_weave_structure(blocks,last):
    weave = blocks

    conv = ""
    for n,i in enumerate(weave):
        conv+=str(i)+" "
        if n%5==4: conv+="\n"


    if last!=conv:
        print conv
        last=conv
        try:
            osc.Message("/matrix",blocks).sendto("192.168.0.2",8000)
        except Exception:
            pass
    return last



last = ""

state = block_state()

while 1:
    last=send_weave_structure(read_all(state),last)
    time.sleep(0.1)
