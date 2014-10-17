import pygame
#import driver
import time

# standard lsystem stuff
def run_rule(str,rule):
    ret = ""
    for i in range(0,len(str)):
        if str[i:i+len(rule[0])]==rule[0]:
            ret+=rule[1]
        else:
            ret+=str[i]
    return ret

def explode_lsystem(str,rules,gen):
    for g in range(0, gen):
        for r in rules:
            str = run_rule(str,r)
    return str


# a weave structure kernel

class kernel:
    def __init__(self,structure,w,h):
        self.structure = structure
        self.width = w
        self.height = h

    # return warp or weft, dependant on the position
    def stitch(self, x, y, warp, weft):
        #if x % 2 == y % 2:
        if self.structure[x%self.width+(y%self.height)*self.width]==1:
            return warp
        else:
            return weft


def conv_colour(c):
    if c=="R": return [255,50,100]
    if c=="r": return [255,50,100]
    if c=="B": return [50,200,255]
    return [50,200,255]

pygame.init()
screen = pygame.display.set_mode([1024,768])

thr_warp_thin1 = pygame.image.load("thr-warp-thin.png")
thr_warp_thin1.set_palette_at(1,conv_colour("B"))
thr_warp_fat1 = pygame.image.load("thr-warp-fat.png")
thr_warp_fat1.set_palette_at(1,conv_colour("B"))
thr_weft_thin1 = pygame.image.load("thr-weft-thin.png")
thr_weft_thin1.set_palette_at(1,conv_colour("B"))
thr_weft_fat1 = pygame.image.load("thr-weft-fat.png")
thr_weft_fat1.set_palette_at(1,conv_colour("B"))

thr_warp_thin2 = pygame.image.load("thr-warp-thin.png")
thr_warp_thin2.set_palette_at(1,conv_colour("R"))
thr_warp_fat2 = pygame.image.load("thr-warp-fat.png")
thr_warp_fat2.set_palette_at(1,conv_colour("R"))
thr_weft_thin2 = pygame.image.load("thr-weft-thin.png")
thr_weft_thin2.set_palette_at(1,conv_colour("R"))
thr_weft_fat2 = pygame.image.load("thr-weft-fat.png")
thr_weft_fat2.set_palette_at(1,conv_colour("R"))

rect = thr_warp_thin1.get_rect()
#rectv.left=20

fat_red = 1
thin_red = 2
fat_blue = 4
thin_blue = 8

def lsys_from_code(c):
    if c==fat_red: return "R"
    if c==fat_blue: return "B"
    if c==thin_red: return "r"
    if c==thin_blue: return "b"
    return ""

def rule_from_code(code):
    f = lsys_from_code(code[0])
    t = ""
    for i in range(1,8):
        t+=lsys_from_code(code[i])
    return [f,t]

def lsys_from_blocks(code):
    #axiom
    axiom = ""
    for i in range(0,8):
        axiom+=lsys_from_code(code[i])

    rule1=rule_from_code(code[8:16])
    rule2=rule_from_code(code[16:24])

    print("------")
    print(axiom)
    print(rule1)
    print(rule2)

    if (rule2[0]!=""):
        return explode_lsystem(axiom,[rule1,rule2],3)
    else:
        return explode_lsystem(axiom,[rule1],3)


def sprite_from_yarn(c,warp):
    if warp:
        if c=="B": return thr_warp_fat1
        if c=="R": return thr_warp_fat2
        if c=="r": return thr_warp_thin2
        if c=="b": return thr_warp_thin1
        return thr_warp_fat2
    else:
        if c=="B": return thr_weft_fat1
        if c=="R": return thr_weft_fat2
        if c=="r": return thr_weft_thin2
        if c=="b": return thr_weft_thin1
        return thr_weft_fat2

cell_spacing = 15
weave_width = 60
weave_height = 40

def draw_weave(time,kernel,warp_yarn,weft_yarn):
    for y in range(0,weave_height):
        rect.top=y*cell_spacing
        for x in range(0,weave_width):
            warp_over = kernel.stitch(x,y,True,False)
            rect.left=x*cell_spacing
            warp_sprite = sprite_from_yarn(warp_yarn[x%len(warp_yarn)],True)
            weft_sprite = sprite_from_yarn(weft_yarn[y%len(weft_yarn)],False)

            # draw order depends on weave
            if warp_over:
                if time>y:
                    screen.blit(weft_sprite, rect)
                screen.blit(warp_sprite, rect)
            else:
                screen.blit(warp_sprite, rect)
                if time>y:
                    screen.blit(weft_sprite, rect)

emu = [2,0,0,0,0,0,0,0,
       2,4,0,0,0,0,0,0,
       4,4,8,2,0,0,0,0,
       0,0,0,0,0,0,0,0]


frame = 0

k = kernel([1,0,0,1],2,2)
driver.init()
print(driver.read_all())



while 1:
    yarn = lsys_from_blocks(driver.read_all())
    print(yarn)
    screen.fill([0,0,0])
    draw_weave(frame,k,yarn,yarn)
    pygame.display.flip()
    frame += 1
    if frame>weave_width: frame=0
