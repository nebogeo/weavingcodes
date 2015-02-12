import driver
import time
import osc

driver.init()

print(driver.read_all())

def send_weave_structure(blocks,last):
    weave = [blocks[0],blocks[1],blocks[2],blocks[3],
             blocks[8],blocks[9],blocks[10],blocks[11],
             blocks[16],blocks[17],blocks[18],blocks[19],
             blocks[24],blocks[25],blocks[26],blocks[27]]
    conv = reduce(lambda r,e: r+"0 " if e==0 else r+"1 ",
                  weave,"")

    if last!=conv:
        last=conv
        osc.Message("/eval",["(with-primitive warp \n  (set-draft! \n    warp-draft-start \n      (list "+conv+")))\n"+
                         "(with-primitive weft \n  (set-draft! \n    weft-draft-start \n      (list "+conv+")))"]).sendlocal(8000)
    return last

last = ""

while 1:
    last=send_weave_structure(driver.read_all(),last)
    time.sleep(0.5)
