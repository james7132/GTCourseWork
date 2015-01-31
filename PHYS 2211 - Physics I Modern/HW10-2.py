
from __future__ import division                 ## treat integers as real numbers in division
from visual import *
scene.width=600
scene.height = 760


## constants and data
g = 9.8
mball = .1
L0 = 0.3
ks = 12
epsilon = 0.2263
mball = 0.3676


## objects
ceiling = box(pos=(0,0,0), size = (0.2, 0.01, 0.2))
ball = sphere(pos=(-0.1488, -0.0399, 0), radius=0.025, color=color.orange)
spring = helix(pos=ceiling.pos, color=color.cyan, thickness=.003, coils=40, radius=0.015)
spring.axis = ball.pos - ceiling.pos
trail  = curve(color=ball.color)

## initial values
ball.p = mball*vector(-0.175, -0.387, 0)

#time
t = 0
deltat = 5e-5


## improve the display
scene.autoscale = 1             ## don't let camera zoom in and out as ball moves
scene.center = vector(0,-L0,0)   ## move camera down to improve display visibility

## calculation loop

while t < 6.80005:
    rate(10000)
## calculate force on ball by spring (note: requires calculation of L_vector)
    S = mag(spring.axis) - L0
    F_spring = -(ks * S + epsilon * S ** 3) * norm(spring.axis)




    
## calculate net force on ball (note: has two contributions)

    Fgrav=mball*g*vector(0,-1,0)

    Fnet=Fgrav + F_spring

## apply momentum principle (compute the magnitude of the components of the net force)
    ball.p_i = mag(ball.p)
    ball.p=ball.p+Fnet*deltat
    ball.dp = mag(ball.p) - ball.p_i
    ball.phat = ball.p / mag(ball.p)
    ball.Fnet_tangent = ball.dp / deltat * ball.phat
    ball.Fnet_perp = Fnet - ball.Fnet_tangent

## update position

    ball.pos=ball.pos+ball.p/mball * deltat 

## update axis of spring

    spring.axis=ball.pos-ceiling.pos
    trail.append(pos=ball.pos)

## update time   
    t = t + deltat

print("Ball Position: ", ball.pos)
print("Velocity: ", ball.p / mball)
print("Magnitude of parrallel component of net force: ", mag(ball.Fnet_tangent))
print("Magnitude of perpindicular component of net force: ", mag(ball.Fnet_perp))
