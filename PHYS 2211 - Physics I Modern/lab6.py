
from __future__ import division
from visual import *
scene.width =1024
scene.height = 760

#CONSTANTS
G = 6.7e-11
mEarth = 6e24
mcraft = 15000
mMoon = 7e22
deltat = 60
#Scales
pscale = .5
fscale = 9000
dpscale = 100
TanScale = 9000
PerpScale = 9000

#OBJECTS AND INITIAL VALUES

# Earth
Earth = sphere(pos=vector(0,0,0), radius=6.4e6, color=color.cyan)
scene.center = (2e8,0,0)
scene.range=100*Earth.radius

# Moon
Moon = sphere(pos=vector(4e8,0,0), radius=1.75e6, color=color.white)

# Spacecraft
craft = sphere(pos=vector(-68490000,0,0), radius = 1e6, color=color.yellow)
vcraft = vector(0,3.32e3,0)
pcraft = mcraft * vcraft
pcraft_i = pcraft
Moon.v = vector(0, sqrt(G * mEarth / mag(Moon.pos - Earth.pos)), 0)
Moon.p = mMoon * Moon.v

print(Moon.v)

trail = curve(color=craft.color)    ## craft trail: starts with no points
moonTrail = curve(color=Moon.color)
t = 0
scene.autoscale = 0       ## do not allow camera to zoom in or out

# Arrows
parr = arrow(color=color.green)
farr = arrow(color=color.cyan)
dparr = arrow(color=color.red)
Fnet_tangent_arrow = arrow(color=color.yellow)
Fnet_perp_arrow = arrow(color=color.magenta)

#CALCULATIONS


while true:
    rate(1000)
    
    # Camera
    #scene.center=craft.pos
    #scene.range=craft.radius*60

    rMoonCraft = Moon.pos - craft.pos
    RMoonCraft = mag(rMoonCraft)
    FMoonCraftMag = G*((mMoon*mcraft)/(RMoonCraft**2))
    rhatMoonCraft = rMoonCraft/RMoonCraft
    FMoonCraft = -FMoonCraftMag*rhatMoonCraft
    
    rMoonEarth = Moon.pos - Earth.pos
    RMoonEarth = mag(rMoonEarth)
    FMoonEarthMag = G*((mMoon*mEarth)/(RMoonEarth**2))
    rhatMoonEarth = rMoonEarth/RMoonEarth
    FMoonEarth = -FMoonEarthMag*rhatMoonEarth
    
    FMoon = FMoonCraft + FMoonEarth
    Moon.p = Moon.p + FMoon * deltat
    Moon.pos = Moon.pos + (Moon.p / mMoon) * deltat

    # Force of the Earth on the craft
    rEarth = craft.pos - Earth.pos
    REarth = sqrt(rEarth.x**2 + rEarth.y**2 + rEarth.z**2)
    FEarthMag = G*((mcraft*mEarth)/(REarth**2))
    rhatEarth = rEarth/REarth
    FEarth = -FEarthMag*rhatEarth

    # Force of the Moon on the craft
    rMoon = craft.pos - Moon.pos
    RMoon = sqrt(rMoon.x**2 + rMoon.y**2 + rMoon.z**2)
    FMoonMag = G*((mMoon*mcraft)/(RMoon**2))
    rhatMoon = rMoon/RMoon
    FMoon = -FMoonMag*rhatMoon
    
    # Net Force
    Fnet = FMoon + FEarth

    # Update the Momentum
    p_init = mag(pcraft)
    pcraft = pcraft + Fnet*deltat
    p_final = mag(pcraft)
    deltap = pcraft - pcraft_i
    phat = pcraft/mag(pcraft)

    # Update the Position
    craft.pos = craft.pos + (pcraft/mcraft)*deltat

    # Momentum Arrow
    #parr.pos = craft.pos
    #parr.axis = pcraft * pscale

    # Force Arrow
    farr.pos = craft.pos
    farr.axis = Fnet*fscale

    pcraft_i = pcraft + vector(0,0,0)
    dparr.pos = craft.pos
    dparr.axis = deltap*dpscale

    # Parallel component of Net Force
    Fnet_tangent = ((p_final - p_init)/deltat)*phat
    Fnet_tangent_arrow.pos = craft.pos
    Fnet_tangent_arrow.axis = Fnet_tangent*TanScale

    # Perpendicular Component of Net Force
    Fnet_perp = Fnet - Fnet_tangent
    Fnet_perp_arrow.pos = craft.pos
    Fnet_perp_arrow.axis = Fnet_perp*PerpScale

    # Calculations / Print
    #print('Mag Momentum', mag(pcraft))
    #print('Mag V', (mag(pcraft)/mcraft))
    #print('magFnet_perp', ((mag(pcraft) * (mag(pcraft)/mcraft))/ REarth))
    #print('magSep', (REarth))
    
    # Breaks loop it craft Crashes
    if REarth < Earth.radius:
        break

    if RMoon < Moon.radius:
        break

    # Makes Trail
    trail.append(pos=craft.pos) ## this adds the new position of the spacecraft to the trail
    moonTrail.append(pos=Moon.pos)
    t += deltat

print('Position = ', craft.pos)
print('Velocity = ', pcraft/mcraft)
print('Calculations finished after ',t,'seconds') 
print("Fnet = ", Fnet) 
