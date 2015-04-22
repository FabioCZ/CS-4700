-- Library for setting up a classes
require 'classlib'

-------------- Global simulation constants go here (Don't change them) --------------------
-- Time per move (1 second)
DELTA_TIME = 1.0

-- Starting values for the lander
LANDER_INIT_ALTITUDE = 50.0
LANDER_INIT_VELOCITY = 0.0
LANDER_INIT_FUEL_PLUTO = 10.0
LANDER_INIT_FUEL_MARS = 20.0

-- Lander thruster strength
LANDER_THRUSTER_STRENGTH = 1.0

-- Lander explodes if it reaches the surface going faster than this
MAX_LANDING_VELOCITY = -1.5

-- Planet constants
PLUTO_GRAVITY = 0.5
PLUTO_HEIGHT = 10.0
MARS_GRAVITY = 0.9
MARS_HEIGHT = 1.0
-----------------------------------------------------------------

 --[[--
classLib Usage Notes:
 To construct a new instance:
    myPlanet = Planet("MyPlanet", 0.4, 16)
 To access class members:
    myPlanet.gravity
 To call class methods:
    myPlanet:toString()
 To access members and methods internally:
    self.landingSiteElevation
    self:toString()
--]]--

-- Declare the Planet class which models a Planet, which has a gravity and a landing site elevation height
Planet = class('Planet')

-- Planet class constructor
function Planet:__init(name, gravity, elevation)
  self.name = name
  self.gravity = gravity
  self.landingSiteElevation = elevation
end

-- Returns a string representing the planet
function Planet:toString()
  return self.name .. ", gravity: " .. self.gravity .. ", landing site elevation: " .. self.landingSiteElevation
end

--[[--
-- Lander Class goes here.
 ]]

Lander = class('Lander');

function Lander:__init(velocity, altitude, fuelReserve, thrusterStrength)
    self.velocity = velocity;
    self.altitude = altitude;
    self.fuelReserve = fuelReserve;
    self.thrusterStrength = thrusterStrength;
end

function Lander:toString()
    return "Altitude: " .. self.altitude .. ", Velocity: " .. self.velocity .. ""
end

-- Uncomment below once you have your code in place to run your simulation
--[[-- 
local pluto = Planet("Pluto", PLUTO_GRAVITY, PLUTO_HEIGHT)
local plutoLander = Lander(LANDER_INIT_VELOCITY, LANDER_INIT_ALTITUDE, LANDER_INIT_FUEL_PLUTO, LANDER_THRUSTER_STRENGTH)
local plutoSimulation = Simulation(plutoLander, pluto, strategy)
plutoSimulation:run()
--]]--

-- Uncomment below if you want to try for the Mars landing extra credit
--[[-- 
local mars = Planet("Mars", MARS_GRAVITY, MARS_HEIGHT)
local marsLander = Lander(LANDER_INIT_VELOCITY, LANDER_INIT_ALTITUDE, LANDER_INIT_FUEL_MARS, LANDER_THRUSTER_STRENGTH)
marsSimulation = Simulation(marsLander, mars, strategy)
marsSimulation:run()
--]]--

