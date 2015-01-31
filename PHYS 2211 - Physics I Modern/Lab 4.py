from visual import *
scene.width =1024
scene.height = 760

#CONSTANTS
G = 6.7e-11
mEarth = 6e24
mcraft = 15000
deltat = 60

#OBJECTS AND INITIAL VALUES
Earth = sphere(pos=vector(0,0,0), radius=6.4e6, color=color.cyan)
scene.range=11*Earth.radius
craft = sphere(pos=vector(-7.448e7, 4.224e6,0), radius=2e6, color=color.yellow)
vcraft = vector(249,2674,0)
pcraft = mcraft*vcraft
r=craft.pos-Earth.pos
rmag=sqrt(r.x**2 +r.y**2 +r.z**2)
rhat=r/rmag

trail = curve(color=craft.color)    ## craft trail: starts with no points
t = 0
scene.autoscale = 0       ## do not allow camera to zoom in or out

Fgrav=((G*mEarth*mcraft)/(rmag**2))*rhat



while t < 2302128:
    r = craft.pos-Earth.pos
    rmag = sqrt(r.x**2 +r.y**2 +r.z**2)
    rhat = r / rmag
    Fmag = -((G*mEarth*mcraft)/(rmag**2))*rhat
    Fnet = Fmag
    pcraft = pcraft + Fnet * deltat
    vcraft = pcraft / mcraft 
    craft.pos= craft.pos + vcraft *deltat
    if rmag < Earth.radius:break
    t = t + deltat

    trail.append(pos=craft.pos)

print 'Calculations finished after ',t,'seconds'
print 'Fgrav', Fgrav
print 'final position of craft=', craft.pos
print 'final velocity of craft=', vcraft
