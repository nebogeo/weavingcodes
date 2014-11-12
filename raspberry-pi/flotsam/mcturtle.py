# Copyright (C) 2014 Dave Griffiths for dBsCode
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# Minecraft API wrapper for dBsCode taster course

import sys

# locate api so we can run frm anywhere
sys.path.append("/home/pi/mcpi/api/python/mcpi")

import minecraft
from block import *
import math
import random
from vec3 import Vec3

mc = minecraft.Minecraft.create()
point = Vec3



def debug(msg):
	mc.postToChat(str(msg))

def my_pos():
	t = mc.player.getPos()
	return point(t.x,t.y,t.z)

def move_me_to(p):
	mc.player.setPos(p)

def read_block(p):
	mc.getBlock(p)

def write_block(blocktype,p):
	mc.setBlock(p.x,p.y,p.z,blocktype)

def box(t,pos,size):
	mc.setBlocks(pos.x,pos.y,pos.z,
				pos.x+size.x-1,pos.y+size.y-1,
				pos.z+size.z-1,
				t)
	#for y in reversed(range(0,int(size.y))):
	#	for z in range(0, int(size.z)):
	#		for x in range(0, int(size.x)):
	#			write_block(t,point(pos.x+x,pos.y+y,pos.z+z))

def sphere(t,pos,radius):
	radius=int(radius)
	for y in range(-radius, radius):
		for z in range(-radius, radius):
			for x in range(-radius, radius):
				if math.sqrt(x*x+y*y+z*z)<radius:
					write_block(t,point(pos.x+x,pos.y+y,pos.z+z))

def cylinder(t,pos,radius,height):
	radius=int(radius)
	height=int(height)
	for y in range(0, height):
		for z in range(-radius, radius):
			for x in range(-radius, radius):
				if math.sqrt(x*x+z*z)<radius:
					write_block(t,point(pos.x+x,pos.y+y,pos.z+z))

def cone(t,pos,radius,height):
	radius=int(radius)
	height=int(height)
	for y in range(0, height):
		for z in range(-radius, radius):
			for x in range(-radius, radius):
				if math.sqrt(x*x+z*z)<(radius*(1-y/float(height))):
					write_block(t,point(pos.x+x,pos.y+y,pos.z+z))


def toblerone(t,pos,size):
	for y in reversed(range(0,int(size.y))):
		for z in range(0, int(size.z)):
			for x in range(0, int(size.x)):
				a = size.x*(1-y/float(size.y))*0.5
				if x>size.x/2.0-a and x<a+size.x/2.0:
					write_block(t,point(pos.x+x,pos.y+y,pos.z+z))


def mag(p):
	return math.sqrt(p.x*p.x+p.y*p.y+p.z*p.z)

def distance(a,b):
	return mag(a-b)

def random_point(a,b):
	return point(random.randrange(a.x,b.x),
				 random.randrange(a.y,b.y),
				 random.randrange(a.z,b.z))

def random_range(a,b):
	return random.randint(a,b)

def choose_one(*argv):
	return argv[random.randint(0,len(argv)-1)]

def i_am_lost():
	move_me_to(point(0,20,0))

def bulldoze(size):
	height=100
	print("bulldozing")
	mc.setBlocks(-size/2,0,-size/2,size/2,height,size/2,AIR)
	box(GRASS,point(-size/2,-1,-size/2),point(size,1,size))
	print("finished bulldozing")

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



##########################################################
# turtle stuff
class turtle:

	def __init__(self):
		self.reset()

	def reset(self):
		print("reset...")
		self.m_pos = point(0,0,0)
		self.m_dir = mat44()
		self.m_material = MELON

	def material(this,m):
		this.m_material=m

	def forward(this,distance):
		dir = this.m_dir.transform(point(0,0,1))
		dir.x=round(dir.x)
		dir.y=round(dir.y)
		dir.z=round(dir.z)
		print(dir.x,dir.y,dir.z)
		box(this.m_material,this.m_pos,dir*distance) 
		this.m_pos+=dir*distance
	
	def roty(this,a):
		this.m_dir.rotxyz(0,a,0)

	def rotx(this,a):
		this.m_dir.rotxyz(a,0,0)

	def left(this):
		this.roty(90)

	def right(this):
		this.roty(-90)

	def up(this):
		this.rotx(90)

	def down(this):
		this.rotx(-90)
