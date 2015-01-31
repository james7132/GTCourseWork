from __future__ import division                 ## treat integers as real numbers in division
from visual import *
from visual.graph import *
scene.width=600
scene.height = 760


## Setup graphing windows
gdisplay(width=500, height=250, x=600, y=1)
ygraph = gcurve(color=color.yellow)
gdisplay(width=500, height=250, x=600, y=300)
pgraph = gcurve(color=color.yellow)
pscale=0.1
fscale=.02500


## constants and data
g = 9.8
mball = 0.3288  ## change this to the Mass you used in the lab for the oscillation experiments
L0 = .3    ## use the relaxed length from your previous lab
ks = 12     ## change this to the spring constant you measured (in N/m)
deltat = 1e-3  ## change this to be about 1/1000 of your measured period when you used Mass 2

t = 0       ## start counting time at zero

## objects
ceiling = box(pos=(0,0,0), size = (0.2, 0.01,   0.2))         ## origin is at ceiling
ball = sphere(pos=(-0.2253,-0.0645,-0.2175), radius=0.025, color=color.orange) ## note: spring initially compressed
spring = helix(pos=ceiling.pos, color=color.cyan, thickness=.003, coils=40, radius=0.015) ## change the color to be your spring color
spring.axis = ball.pos - ceiling.pos

## initial values
ball.p = mball*vector(0.316,0.441,0.247)


## improve the display
##scene.autoscale = 0             ## don't let camera zoom in and out as ball moves
##scene.center = vector(0,-L0,0)   ## move camera down to improve display visibility

pArrow=arrow(color=color.cyan)
fArrow=arrow(color=color.yellow)
gArrow=arrow(color=color.green)
sArrow=arrow(color=color.red)
trail = curve(color=ball.color)


## calculation loop

while t < 8.14:
    
    rate(500)
    s= mag(spring.axis)- L0
    ## make this short to read period off graph
    Fspring= -s*ks*norm(spring.axis) 
## calculate force on ball by spring (note: requires calculation of L_vector)
    Fnet= Fspring+ vector(0,-mball*g,0)
## calculate net force on ball (note: has two contributions)
    ball.p += Fnet*deltat
## apply momentum principle
    ball.pos= ball.pos + (ball.p/mball)*deltat
## update position
    spring.axis = ball.pos - ceiling.pos
## update axis of spring
## update time
    fArrow.pos=ball.pos
    fArrow.axis=Fnet*fscale
    pArrow.pos=ball.pos
    pArrow.axis=ball.p*fscale
    gArrow.pos=ball.pos
    gArrow.axis= vector(0,-(mball*g),0)*fscale
    sArrow.pos=ball.pos
    sArrow.axis=Fspring*fscale
    t = t + deltat
    trail.append(pos=ball.pos)
    ygraph.plot(pos=(t, ball.pos.y))
    pgraph.plot(pos=(t, ball.p.y))
        
p_init = ball.p
ball.p = ball.p+Fnet*deltat
p_final = ball.p

Fnet_parallel =((mag(p_final)-mag(p_init))*norm(ball.p))/deltat
Fnet_perpendicular=Fnet - Fnet_parallel
vball=ball.p/mball
R=(mag(ball.p)*mag(vball))/(mag(Fnet_perpendicular))
    
print 'final position:', ball.pos
print 'final velocity:', ball.p/mball
print 'F parallel=', Fnet_parallel
print 'F perpendicular=', Fnet_perpendicular
print 'magnitude, parallel=', mag(Fnet_parallel)
print 'magnitude, perpendicular=', mag(Fnet_perpendicular)
print 'kissing circle radius=', R
