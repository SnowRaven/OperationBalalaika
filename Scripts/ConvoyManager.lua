-- OKB-17 convoy manager script by Arctic Fox --

assert(dct and dct.theater, "DCT not found")

-- enum and stuff
-- DCS country IDs
local countries = {
	["USA"] = 2,
	["Iran"] = 34,
	["Iraq"] = 35,
	["Pakistan"] = 39,
	["USSR"] = 68
}

-- get the size of a given table
local function getTableSize(table)
	local size = 0
	for key in pairs(table) do
		size = size + 1
	end
	return size
end

-- get distance between two points using the power of Pythagoras
local function getDistance(x1, y1, x2, y2)
	return math.sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)))
end

-- see if any player is within a certain distance in meters to a point
local function playerInRange(distance, x, y)
	for key, sideIndex in pairs(coalition.side) do
		for key, player in pairs(coalition.getPlayers(sideIndex)) do
			if getDistance(player:getPoint().x, player:getPoint().z, x, y) < distance then
				return true
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------
local routes = {}

-- function that reverses a route
local function reverseRoute(route)
    local newRoute = {}
    local routeLength = getTableSize(route)
    local pointID = 1
    for i = routeLength, 1, -1 do
        newRoute[pointID] = route[i]
        pointID = pointID + 1
    end
    return newRoute
end

-- define transport routes
-- each route is generated by waypoints from a unit with a group name that starts with "R/"
-- route country is defined by the country defined for the unit
local function initRoutes()
    for coalitionID, coalition in pairs(env.mission.coalition) do
        for countryID, country in pairs(coalition.country) do
            if country.vehicle ~= nil then
                for groupID, group in pairs(country.vehicle.group) do
                    if group.name:sub(1,2) == "R/" then
                        local route = {}
                        for pointID, point in ipairs(group.route.points) do
                            local routePoint = {
                                ["x"] = point.x,
                                ["y"] = point.y
                            }
                            if point.action == "On Road" then
                                routePoint.onRoad = true
                            end
                            route[pointID] = routePoint
                        end
                        if routes[country.id] == nil then
                            routes[country.id] = {}
                        end
                        table.insert(routes[country.id], route)
                        -- add the reverse route
                        table.insert(routes[country.id], reverseRoute(route))
                    end
                end
            end
        end
    end
end

initRoutes()
---------------------------------------------------------------------------------------------------------------------------
-- transport types by country
local transportTypes = {
    [countries.Iran] = {
        [1] = {
            ["type"] = "Ural-375",
            ["livery"] = "desert"
        },
        [2] = {
            ["type"] = "Land_Rover_101_FC",
            ["livery"] = "summer"
        },
        [3] = {
            ["type"] = "GAZ-66",
            ["livery"] = "desert"
        },
        [4] = {
            ["type"] = "ATZ-10",
            ["livery"] = "desert"
        },
        [5] = {
            ["type"] = "ATMZ-5",
            ["livery"] = "desert"
        }
    }
}
-- misc unit types by country
local miscTypes = {
    [countries.Iran] = {
        [1] = {
            ["type"] = "Land_Rover_109_S3",
            ["livery"] = "summer"
        }
    }
}
-- escort types by country
local escortTypes = {
    [countries.Iran] = {
        [1] = {
            ["type"] = "BTR-80",
            ["livery"] = "desert"
        },
        [2] = {
            ["type"] = "M-113",
            ["livery"] = "desert"
        }
    }
}
-- AD types by country
local ADTypes = {
    [countries.Iran] = {
        [1] = {
            ["type"] = "Ural-375 ZU-23",
            ["livery"] = "desert"
        },
        [2] = {
            ["type"] = "Ural-375 ZU-23 Insurgent",
            ["livery"] = "desert"
        }
    }
}
-- heavy unit types by country
local heavyTypes = {
    [countries.Iran] = {
        [1] = {
            ["type"] = "ZSU_57_2",
            ["livery"] = "desert"
        },
        [2] = {
            ["type"] = "ZSU-23-4 Shilka",
            ["livery"] = "desert"
        },
        [3] = {
            ["type"] = "Vulcan",
            ["livery"] = "desert"
        }
    }
}
---------------------------------------------------------------------------------------------------------------------------
-- minimum and maximum time between new convoys being sent out in seconds
local minConvoyTime = 600
local maxConvoyTime = 1200
local unitSkill = "Average"
local destructionThreshold = 0.25 -- percentage of a convoy's transports and misc vehicles below which it is considered destroyed
local cleanupDistance = 30000 -- minimum distance in meters from the nearest player at which a convoy will be cleaned up
-- minimum and maximum amount of vehicles in a convoy
local minTransports = 4
local maxTransports = 8
local minAD = 1
local maxAD = 2
local minMisc = 0
local maxMisc = 2
local minEscorts = 1
local maxEscorts = 3
local maxHeavy = 2
local heavyChance = 30 -- chance for a convoy to include heavy units
-- minimum and maximum speed of a convoy in m/s
local minSpeed = 10
local maxSpeed = 16
local tickets = 2 -- DCT ticket value of a convoy

local nextConvoyID = 1
local convoys = {}

local function createConvoy(country)
    -- select route
    local route = routes[country][math.random(getTableSize(routes[country]))]
    -- figure out the amount of units per category in the convoy, as well as convoy speed
    local transports = math.random(minTransports, maxTransports)
    local miscVehicles = math.random(minMisc, maxMisc)
    local escorts = math.random(minEscorts, maxEscorts)
    -- split escorts between the vanguard and rearguard
    local vanguard = math.ceil(escorts / 2)
    local rearguard = math.floor(escorts / 2)
    local ADVehicles = math.random(minAD, maxAD)
    local heavyVehicles = 0
    if math.random(100) < heavyChance then
        heavyVehicles = math.random(1, maxHeavy)
    end
    local convoySpeed = math.random(minSpeed, maxSpeed)
    env.info("Convoy Manager Debug: Creating convoy " .. tostring(nextConvoyID), 0)
    env.info("Convoy Manager Debug: Transports: " .. tostring(transports), 0)
    env.info("Convoy Manager Debug: Misc Vehicles: " .. tostring(miscVehicles), 0)
    env.info("Convoy Manager Debug: Escorts: " .. tostring(escorts), 0)
    env.info("Convoy Manager Debug: AD: " .. tostring(ADVehicles), 0)
    env.info("Convoy Manager Debug: Heavy Vehicles: " .. tostring(heavyVehicles), 0)
    env.info("Convoy Manager Debug: Speed: " .. tostring(convoySpeed), 0)
    -- generate units
    local units = {}
    for i = 1, vanguard do
        local unitType = escortTypes[country][math.random(getTableSize(escortTypes[country]))]
        local unitData = {
            ["name"] = "Convoy " .. nextConvoyID .. " Vanguard " .. i,
            ["type"] = unitType.type,
            ["livery_id"] = unitType.livery,
            ["skill"] = unitSkill,
            ["x"] = route[1].x,
            ["y"] = route[1].y + (i*6),
            ["heading"] = 0
        }
        table.insert(units, unitData)
    end
    for i = 1, heavyVehicles do
        local unitType = heavyTypes[country][math.random(getTableSize(heavyTypes[country]))]
        local unitData = {
            ["name"] = "Convoy " .. nextConvoyID .. " Heavy Vehicle " .. i,
            ["type"] = unitType.type,
            ["livery_id"] = unitType.livery,
            ["skill"] = unitSkill,
            ["x"] = route[1].x + 12,
            ["y"] = route[1].y + (i*6),
            ["heading"] = 0
        }
        table.insert(units, unitData)
    end
    for i = 1, miscVehicles do
        local unitType = miscTypes[country][math.random(getTableSize(miscTypes[country]))]
        local unitData = {
            ["name"] = "Convoy " .. nextConvoyID .. " Vehicle " .. i,
            ["type"] = unitType.type,
            ["livery_id"] = unitType.livery,
            ["skill"] = unitSkill,
            ["x"] = route[1].x + 24,
            ["y"] = route[1].y + (i*6),
            ["heading"] = 0
        }
        table.insert(units, unitData)
    end
    for i = 1, transports do
        local unitType = transportTypes[country][math.random(getTableSize(transportTypes[country]))]
        local unitData = {
            ["name"] = "Convoy " .. nextConvoyID .. " Transport " .. i,
            ["type"] = unitType.type,
            ["livery_id"] = unitType.livery,
            ["skill"] = unitSkill,
            ["x"] = route[1].x + 36,
            ["y"] = route[1].y + (i*6),
            ["heading"] = 0
        }
        table.insert(units, unitData)
    end
    for i = 1, ADVehicles do
        local unitType = ADTypes[country][math.random(getTableSize(ADTypes[country]))]
        local unitData = {
            ["name"] = "Convoy " .. nextConvoyID .. " AD " .. i,
            ["type"] = unitType.type,
            ["livery_id"] = unitType.livery,
            ["skill"] = unitSkill,
            ["x"] = route[1].x + 48,
            ["y"] = route[1].y + (i*6),
            ["heading"] = 0
        }
        table.insert(units, unitData)
    end
    for i = 1, rearguard do
        local unitType = escortTypes[country][math.random(getTableSize(escortTypes[country]))]
        local unitData = {
            ["name"] = "Convoy " .. nextConvoyID .. " Rearguard " .. i,
            ["type"] = unitType.type,
            ["livery_id"] = unitType.livery,
            ["skill"] = unitSkill,
            ["x"] = route[1].x + 60,
            ["y"] = route[1].y + (i*6),
            ["heading"] = 0
        }
        table.insert(units, unitData)
    end
    -- generate waypoints
    local waypoints = {}
    local waypoint = {} -- out of the loop so we can get the position of the last one
    for pointID, point in ipairs(route) do
        -- we start at waypoint 1 so no need to go there
        if pointID ~= 1 then
            waypoint = {
                ["type"] = "Turning Point",
                ["x"] = point.x,
                ["y"] = point.y,
                ["speed"] = convoySpeed
            }
            if point.onRoad then
                waypoint.action = "On Road"
            else
                waypoint.action = "Off Road"
            end
            waypoints[pointID - 1] = waypoint
        end
    end
    -- generate convoy
    local groupData = {
        ["name"] = "Convoy " .. nextConvoyID,
        ["task"] = "Ground Nothing",
        ["uncontrollable"] = true,
        ["units"] = units,
        ["route"] = {
            ["points"] = waypoints
        }
    }
    local convoyData = {
        ["group"] = coalition.addGroup(country, Group.Category.GROUND, groupData),
        ["country"] = country,
        ["transportStrength"] = transports + miscVehicles, -- original amount of transports and misc vehicles in the group, used to calculate convoy elimination
        ["destinationX"] = waypoint.x,
        ["destinationY"] = waypoint.y
    }
    convoys[nextConvoyID] = convoyData
    -- increment next convoy ID
    nextConvoyID = nextConvoyID + 1
    -- call for next convoy for this country
    timer.scheduleFunction(createConvoy, country, timer.getTime() + math.random(minConvoyTime, maxConvoyTime))
end

-- initialize convoys for all countries with routes
local function initConvoys()
    for countryID, country in pairs(routes) do
        timer.scheduleFunction(createConvoy, countryID, timer.getTime() + maxConvoyTime)
    end
end

local function cleanupConvoy(convoyID)
    convoys[convoyID].group:destroy()
    convoys[convoyID] = nil
    env.info("Convoy Manager Debug: Convoy " .. tostring(convoyID) .. " cleaned up", 0)
end

local function handleTickets(country)
    if dct ~= nil and dct.theater ~= nil then
        local convoyCoalition = coalition.getCountryCoalition(country)
        dct.theater:getTickets():loss(convoyCoalition, tickets)
        if convoyCoalition == coalition.side.BLUE then
            dct.theater:getTickets():reward(coalition.side.RED, tickets)
        elseif convoyCoalition == coalition.side.RED then
            dct.theater:getTickets():reward(coalition.side.BLUE, tickets)
        end
    end
end

-- check for convoy destruction and cleanup
local function handleConvoys()
    for convoyID, convoy in pairs(convoys) do
        -- check if the convoy group is still alive
        if convoy.group:isExist() == true then
            -- make a list of tranport and misc types for this faction we can reference
            local types = {}
            for vehicleID, vehicle in pairs(transportTypes[convoy.country]) do
               types[vehicle.type] = true
            end
            for vehicleID, vehicle in pairs(miscTypes[convoy.country]) do
                types[vehicle.type] = true
            end
            -- sum up group strength and average position
            local groupSize = 0
            local currentTransportStrength = 0
            local totalX = 0
            local totalY = 0
            for unitID, unit in pairs(convoy.group:getUnits()) do
                groupSize = groupSize + 1
                if types[unit:getTypeName()] == true then
                    currentTransportStrength = currentTransportStrength + 1
                end
                totalX = totalX + unit:getPoint().x
                totalY = totalY + unit:getPoint().z
            end
            local x = totalX / groupSize
            local y = totalY / groupSize
            -- check how many transports and misc vehicles are currently alive
            -- check if convoy meets destruction criteria
            if currentTransportStrength < (convoy.transportStrength * destructionThreshold) then
                convoy.destroyed = true
                handleTickets(convoy.country) -- handle DCT tickets
                env.info("Convoy Manager Debug: Convoy " .. tostring(convoyID) .. " destroyed", 0)
                trigger.action.outText("Convoy " .. tostring(convoyID) .. " destroyed", 10)
            end
            -- clean up if the convoy is destroyed or at destination
            if playerInRange(cleanupDistance, x, y) == false then
                if convoy.destroyed then
                    cleanupConvoy(convoyID)
                else
                    if getDistance(x, y, convoy.destinationX, convoy.destinationY) < 600 then
                        cleanupConvoy(convoyID)
                    end
                end
            end
        else
            convoys[convoyID] = nil
            env.info("Convoy Manager Debug: Convoy " .. tostring(convoyID) .. " deleted", 0)
        end
    end
    timer.scheduleFunction(handleConvoys, nil, timer.getTime() + 30)
end

initConvoys()
handleConvoys()