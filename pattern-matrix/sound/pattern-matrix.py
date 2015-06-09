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

def quad_to_int(q):
    return (q[0]<<3 | q[1]<<2 | q[2]<<1 | q[3])

def do_bottom_row(quads):
    ret = [quad_to_int(quads[0]),
           quad_to_int(quads[1]),
           quad_to_int(quads[2]),
           quad_to_int(quads[3]),
           quad_to_int(quads[4])]

    return ret

def read_all():
    a= bus.read_i2c_block_data(0x35,0)[1:6]
    b= bus.read_i2c_block_data(0x33,0)[1:6]
    c= bus.read_i2c_block_data(0x34,0)[1:6]
    d= bus.read_i2c_block_data(0x32,0)[1:6]
    e= bus.read_i2c_block_data(0x36,0)[1:21]
    a.reverse()
    d.reverse()
    e=do_bottom_row(convert_quads(e))
    return a+b+c+d+e



def send_weave_structure(blocks,last):
    weave = blocks

    conv = "(list "
    for n,i in enumerate(weave):
        conv+=str(i)+" "
        if n!=24 and n%5==4: conv+=")\n(list "

    conv+=")"

    if last!=conv:
        last=conv
        print conv
        osc.Message("/eval",["(update \n"+conv+")"]).sendlocal(8000)
    return last

last = ""

while 1:
    last=send_weave_structure(read_all(),last)
    time.sleep(0.1)
