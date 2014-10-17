import pygame

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



pygame.init()
screen = pygame.display.set_mode([640,480])

thr_warp_thin = pygame.image.load("thr-warp-thin.png")
thr_warp_fat = pygame.image.load("thr-warp-fat.png")
thr_weft_thin = pygame.image.load("thr-weft-thin.png")
thr_weft_fat = pygame.image.load("thr-weft-fat.png")
rect = thr_warp_thin.get_rect()
#rectv.left=20

def conv_colour(c):
    if c=="A": return [155,128,255]
    if c=="B": return [155,200,255]
    if c=="C": return [100,100,100]
    return [255,255,255]

def sprite_from_yarn(c,warp):
    if warp:
        if c=="A": return thr_warp_thin
        if c=="B": return thr_warp_fat
        return thr_warp_fat
    else:
        if c=="A": return thr_weft_thin
        if c=="B": return thr_weft_fat
        return thr_weft_fat

cell_spacing = 15

def draw_weave(time,kernel,warp_colours,weft_colours,warp_yarn,weft_yarn):
    for y in range(0,len(weft_colours)):
        rect.top=y*cell_spacing
        for x in range(0,len(warp_colours)):
            warp_over = kernel.stitch(x,y,True,False)
            rect.left=x*cell_spacing
            warp_sprite = sprite_from_yarn(warp_yarn[x%len(warp_yarn)],True)
            weft_sprite = sprite_from_yarn(weft_yarn[y%len(weft_yarn)],False)
            warp_sprite.set_palette_at(1,conv_colour(warp_colours[x]))
            weft_sprite.set_palette_at(1,conv_colour(weft_colours[y]))

            # draw order depends on weave
            if warp_over:
                if time>y:
                    screen.blit(weft_sprite, rect)
                screen.blit(warp_sprite, rect)
            else:
                screen.blit(warp_sprite, rect)
                if time>y:
                    screen.blit(weft_sprite, rect)

ls_boxes = [["A", "ABA"],["B","BA"]]

threads = explode_lsystem("A",[["A", "ABC"],["B","ABC"]],3)

frame = 0
#k= kernel([1,0,0,0,1,0,1,0,
#           0,1,0,0,0,1,0,1,
#           0,0,1,0,1,0,1,1,
#           0,0,0,1,0,1,1,0,
#           1,0,1,0,1,1,1,0,
#           0,1,0,1,1,1,0,1,
#           1,0,1,0,1,0,1,1,
#           0,1,0,1,0,1,1,1],8,8)

k = kernel([1,0,0,1],2,2)


while 1:


    #draw_weave(frame*0.2,k,
     #          explode_lsystem("Z",[["Z","AAAABBBBCCCCZ"]],6),
    #           explode_lsystem("Z",[["Z","AAAABBBBZ"]],6),
    ##           explode_lsystem("Z",[["Z","BABBBBBBAZ"]],6),
     #          explode_lsystem("Z",[["Z","BAAABBBBZ"]],6))

    draw_weave(frame*0.2,k,
               explode_lsystem("AC",[["AC","ACBBBBC"],["BC","CABBBB"]],3),
               explode_lsystem("AC",[["AC","ACBC"],["BC","CCABBBB"]],3),
               "AAAABBBB",
               "BBBBAAAA")

    pygame.display.flip()
    frame += 1
