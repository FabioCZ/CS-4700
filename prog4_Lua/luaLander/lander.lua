--CS 4700 Spring 2015, Lua Programming assignment: Lua Lander
--Fabio Gottlicher, A01647928
--Tested on Windows 8.1 x64 using Lua 5.1.4

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
--]] --

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

--Constructor for lander
function Lander:__init(velocity, altitude, fuelReserve, thrusterStrength)
    self.velocity = velocity;
    self.altitude = altitude;
    self.fuelReserve = fuelReserve;
    self.thrusterStrength = thrusterStrength;
end

--Print altitude, velocity and fuel remaining of a lander
function Lander:toString()
    return "Altitude: " .. self.altitude .. ", Velocity: " .. self.velocity .. ", Fuel: " .. self.fuelReserve;
end

--[[--
-- Simulation Class goes here.
 ]]

Simulation = class('Simulation');

--Constructor for simulation. creates the needed coroutine
function Simulation:__init(lander, planet, strategy)
    self.lander = lander;
    self.planet = planet;
    self.strategy = coroutine.create(strategy);
end

--updates lander fields - fuel, altitude and velocity
function Simulation:updateLander(burnRate)
    if burnRate > self.lander.fuelReserve then
        burnRate = self.lander.fuelReserve;
    end

    --make sure no negative values are passed in
    if burnRate < 0 then
        burnRate = 0;
    end


    self.lander.altitude = self.lander.altitude + (self.lander.velocity * DELTA_TIME);
    self.lander.velocity = self.lander.velocity + (((self.lander.thrusterStrength * burnRate) - self.planet.gravity) * DELTA_TIME);
    self.lander.fuelReserve = self.lander.fuelReserve - burnRate;
end

--returns true if reached surface (whether safely or not), false if still above surface
function Simulation:reachedSurface()
    if (self.lander.altitude <= self.planet.landingSiteElevation) then
        return true;
    else
        return false;
    end
end

--Only call after reached Surface.
--return true if landing velocity was within specified bounds, false if not (==crashed)
function Simulation:landed()
    if self:reachedSurface() and self.lander.velocity >= MAX_LANDING_VELOCITY and self.lander.velocity < 0 then
        return true;
    else
        return false;
    end
end

--return formatted position string. "|" represents landing target, "*" represents lander, " " represents space between
-- planet's sea level, landing target and lander.
function Simulation:positionString()
    local surfaceDiff = self.planet.landingSiteElevation;
    local altitudeDiff = self.lander.altitude - surfaceDiff;
    -- Debug line: print("surf: ", surfaceDiff, "alt: ", altitudeDiff);
    local surfaceSpacing = "";
    local altitudeSpacing = "";
    for ct = 0, surfaceDiff do
        surfaceSpacing = surfaceSpacing .. " ";
    end

    for ct = 0, altitudeDiff do
        altitudeSpacing = altitudeSpacing .. " ";
    end

    print(surfaceSpacing .. "|" .. altitudeSpacing .. "*");
end

--runs the simulation, printing position string throughout and evaluation result at the end.
function Simulation:run()
    print("Starting new landing sequence.");
    print("The planet conditions are: " .. self.planet:toString());


    while (not self:reachedSurface()) do
        self:positionString();
        local status, burnRate = coroutine.resume(self.strategy, self.planet, self.lander);
        -- Debug line: print("vel: ", self.lander.velocity, " alt: ", self.lander.altitude," fuel: ", self.lander.fuelReserve, " burn: ", burnRate );
        self:updateLander(burnRate);
    end

    print(self.lander:toString());
    if self:landed() then
        print("Congratulations, you have landed safely on " .. self.planet.name .. ".");
    else
        print("You have crashed into " .. self.planet.name .. ".");
    end
end

--My implemented strategy, works for both Mars and Pluto.
function strategy(planet, lander)
    while true do
        local altRem = lander.altitude - planet.landingSiteElevation;
        local burn;
        if(planet.name == "Pluto") then
            if(altRem > 20) then
                burn = 0.2;
            elseif (altRem > 15) then
                burn = 0.5;
            elseif (altRem > 10) then
                burn = 0.8;
            elseif (altRem > 5) then
                burn = 1.2;
            else
                burn = 1;
            end
        elseif(planet.name == "Mars") then
            if(altRem > 20) then
                burn = 0.6;
            elseif (altRem > 15) then
                burn = 0.8;
            elseif (altRem > 10) then
                burn = 1.5;
            elseif (altRem > 5) then
                burn = 1.7;
            else
                burn = 1.9;
            end
        end
        coroutine.yield(burn)
    end
end


-- Uncomment below once you have your code in place to run your simulation

local pluto = Planet("Pluto", PLUTO_GRAVITY, PLUTO_HEIGHT)
local plutoLander = Lander(LANDER_INIT_VELOCITY, LANDER_INIT_ALTITUDE, LANDER_INIT_FUEL_PLUTO, LANDER_THRUSTER_STRENGTH)
local plutoSimulation = Simulation(plutoLander, pluto, strategy)
plutoSimulation:run()


-- Uncomment below if you want to try for the Mars landing extra credit

local mars = Planet("Mars", MARS_GRAVITY, MARS_HEIGHT)
local marsLander = Lander(LANDER_INIT_VELOCITY, LANDER_INIT_ALTITUDE, LANDER_INIT_FUEL_MARS, LANDER_THRUSTER_STRENGTH)
marsSimulation = Simulation(marsLander, mars, strategy)
marsSimulation:run()


