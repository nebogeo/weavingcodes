import math

class point:
    def __init__(self,x,y,z):
        self.x=x
        self.y=y
        self.z=z

class mat44:

        def __init__(self):
            self.zero();
            self.m[0][0]=1
            self.m[1][1]=1
            self.m[2][2]=1
            self.m[3][3]=1;

        def zero(self):
            self.m=[[0,0,0,0],
                    [0,0,0,0],
                    [0,0,0,0],
                    [0,0,0,0]]

        def mul(self,rhs):
            t=mat44()
            for i in range(0,4):
                for j in range(0,4):
                    t.m[i][j]=self.m[i][0]*rhs.m[0][j]+self.m[i][1]*rhs.m[1][j]+self.m[i][2]*rhs.m[2][j]+self.m[i][3]*rhs.m[3][j];
            return t

        def translate(self, x, y, z):
            t=mat44()
            t.m[3][0]=x;
            t.m[3][1]=y;
            t.m[3][2]=z;
            self.m=self.mul(t).m

        def rotxyz(self, x, y, z):
            if x!=0:
                t=mat44()
                x*=0.017453292
                sx=math.sin(x)
                cx=math.cos(x)
    		t.m[1][1]=cx
    		t.m[2][1]=-sx
                t.m[1][2]=sx
                t.m[2][2]=cx
                self.m=self.mul(t).m
            if y!=0:
                t=mat44()
                y*=0.017453292
                sy=math.sin(y)
                cy=math.cos(y)
                t.m[0][0]=cy
	    	t.m[2][0]=sy
                t.m[0][2]=-sy
                t.m[2][2]=cy
                self.m=self.mul(t).m
            if z!=0:
                t=mat44()
    		z*=0.017453292
		sz=math.sin(z)
		cz=math.cos(z)
    		t.m[0][0]=cz
    		t.m[1][0]=-sz
                t.m[0][1]=sz
                t.m[1][1]=cz
	    	self.m=self.mul(t).m

        def scale(self, x, y, z):
            t = mat44()
            t.m[0][0]=x
            t.m[1][1]=y
            t.m[2][2]=z
            self.m=self.mul(t).m


        def transform(self,p):
            t = point(0,0,0)
            t.x=p.x*self.m[0][0] + p.y*self.m[1][0] + p.z*self.m[2][0]
            t.y=p.x*self.m[0][1] + p.y*self.m[1][1] + p.z*self.m[2][1]
            t.z=p.x*self.m[0][2] + p.y*self.m[1][2] + p.z*self.m[2][2]
            return t

def test():
    m = mat44()
    print m.m


    m.rotxyz(0,90,0)
    print(m.m)

    p = point(1,0,0)
    pp = m.transform(p)
    print (pp.x,pp.y,pp.z)

test()
