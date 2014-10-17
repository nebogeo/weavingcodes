import driver
import mcturtle
import time

PSH = 1
DUP = 2
JMP = 3
JMZ = 4
ADD = 5
SUB = 6
FWD = 7
TNL = 8
TNR = 9
TNU = 10
TND = 11
MAT = 12

class machine:

    def __init__(self):
        self.stack=[]
        self.pc=0
        self.turtle = mcturtle.turtle()

    def incpc(self):
        self.pc=(self.pc+1)%32

    def pop_stack(self):
        ret = self.stack[0]
        self.stack=self.stack[1:]
        return ret

    def step(self):
        v = driver.read_addr(self.pc)
        self.incpc()

        if v==PSH:
            self.stack.insert(0,driver.read_addr(self.pc))
            self.incpc()
        elif v==DUP:
            self.stack.insert(0,self.stack[0])
        elif v==FWD:
            if len(self.stack)==0:
                self.turtle.forward(1)
            else:
                self.turtle.forward(self.pop_stack())
        elif v==TNL:
            self.turtle.left()
        elif v==TNR:
            self.turtle.right()
        elif v==TNU:
            self.turtle.up()
        elif v==TND:
            self.turtle.down()
        elif v==ADD:
            self.stack.insert(0,self.pop_stack()+self.pop_stack())
        elif v==SUB:
            a = self.pop_stack()
            b = self.pop_stack()
            self.stack.insert(0,b-a)
            print(self.stack[0])
        elif v==JMP:
            self.pc=driver.read_addr(self.pc)
        elif v==JMZ:
            if len(self.stack)>0 and self.stack[0]!=0:
                newpc = driver.read_addr(self.pc)
                self.pc = newpc
            else:
                self.incpc()
        

driver.init()
mcturtle.bulldoze(100)

time.sleep(10)

print(driver.read_all())
m = machine()

while 1:
    m.step()
    time.sleep(0.1)
