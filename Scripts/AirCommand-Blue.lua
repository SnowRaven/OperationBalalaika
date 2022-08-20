-- OKB-17 air tasking and interception system by Arctic Fox --

local handler = {} -- DCS event handler

---------------------------------------------------------------------------------------------------------------------------
-- enum and stuff
-- DCS country IDs
local country = {
	["Iran"] = 34
}
-- generic capability enum
local capability = {
	["None"] = "None",
	["Limited"] = "Limited",
	["Full"] = "Limited"
}
-- enum for formations
-- DCS does not have a default enum for this for some reason
local fixedWingFormation = {
	["LABSClose"] = 65537,
	["LABSOpen"] = 65538,
	["LABSGroupClose"] = 65539,
	["WedgeClose"] = 196609,
	["WedgeOpen"] = 196610,
	["WedgeGroupClose"] = 196611,
}
-- enum for intercept tactics
local interceptTactic = {
	["Lead"] = 1,
	["LeadLow"] = 2,
	["LeadHigh"] = 3,
	["BeamLow"] = 4,
	["SternLow"] = 5
}
-- basic category for each mission type
local missionClass = {
	["Intercept"] = "AA",
	["CAP"] = "AA",
	["QRA"] = "AA"
}
-- names for unit types
local typeAlias = {
	["F-14A-135-GR"] = "Tomcat",
	["F-4E"] = "Phantom",
	["F-5E-3"] = "Tiger"
}
-- DCS categories for unit types
local typeCategory = {
	["F-14A-135-GR"] = Group.Category.AIRPLANE,
	["F-4E"] = Group.Category.AIRPLANE,
	["F-5E-3"] = Group.Category.AIRPLANE
}

---------------------------------------------------------------------------------------------------------------------------
-- faction, squadron and air defense logic data
local side = coalition.side.BLUE

-- table defining preferred tactics for each aircraft type
-- if not defined, will be determined randomly or according to threat (TODO)
local preferredTactic = {
	["F-5E-3"] = "SternLow",
	["F-14A-135-GR"] = "LeadHigh"
}

-- table defining which types constitute high priority threats
local highThreatType = {
	["Su-27"] = true,
	["Su-33"] = true,
	["MiG-29A"] = true,
	["MiG-29S"] = true,
	["MiG-25PD"] = true,
	["MiG-25RBT"] = true,
	["MiG-31"] = true,
	["Su-24M"] = true,
	["Su-24MR"] = true
}

-- range to intercept target in meters at which point the interceptors will activate their radar
-- if range is not defined radar SOP is assumed to be always on
local radarRange = {
	["F-5E3"] = 12000,
	["F-4E"] = 30000
}

-- any zones where interception will not be launched even if in range of a squadron
local ADZExclusion = {
	-- Pakistani Air Force operational area
	[1] = {
		["x"] = 4605,
		["y"] = 248026,
		["radius"] = 150000
	}
}

-- airbases and squadrons
local airbases = {
	["Abbas"] = {
		name = "Bandar Abbas Intl", -- DCS name
		ID = 2,
		Squadrons = {
			["91TFS"] = {
				["name"] = "91st TFS",
				["country"] = country.Iran,
				["type"] = "F-4E",
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = capability.Full,
				["allWeatherAG"] = capability.None,
				["interceptRadius"] = 220000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["CAP"] = true,
					["QRA"] = true
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
								},
								[2] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
								[3] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[6] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[7] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[8] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
								[9] =
								{
									["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
								},
							},
							["fuel"] = "4864",
							["flare"] = 30,
							["chaff"] = 60,
							["gun"] = 100,
						},
						["Short Range"] = {
							["pylons"] =
							{
								[2] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
								[3] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[6] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[7] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[8] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
							},
							["fuel"] = "4864",
							["flare"] = 30,
							["chaff"] = 60,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Toophan",
					"Alvand",
					"Sahand",
					"Alborz",
					"Shahab"
				}
			}
		}
	},
	["Lar"] = {
		name = "Lar", -- DCS name
		ID = 11,
		Squadrons = {
			["23TFS"] = {
				["name"] = "23rd TFS",
				["country"] = country.Iran,
				["type"] = "F-5E-3",
				["skill"] = "High",
				["livery"] = "ir iriaf 43rd tfs",
				["allWeatherAA"] = capability.Limited,
				["allWeatherAG"] = capability.None,
				["interceptRadius"] = 150000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["CAP"] = true,
					["QRA"] = true
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
								},
								[4] =
								{
									["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
								},
								[7] =
								{
									["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
								},
							},
							["fuel"] = 2046,
							["flare"] = 15,
							["ammo_type"] = 2,
							["chaff"] = 30,
							["gun"] = 100,
						},
						["QRA"] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
								},
								[7] =
								{
									["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
								},
							},
							["fuel"] = 2046,
							["flare"] = 15,
							["ammo_type"] = 2,
							["chaff"] = 30,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Palang",
					"Kaman",
					"Paykan"
				}
			}
		}
	},
	["Shiraz"] = {
		name = "Shiraz Intl", -- DCS name
		ID = 19,
		Squadrons = {
			["71TFS"] = {
				["name"] = "71st TFS",
				["country"] = country.Iran,
				["type"] = "F-4E", -- F-4D
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = capability.Full,
				["allWeatherAG"] = capability.None,
				["interceptRadius"] = 300000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["CAP"] = true,
					["QRA"] = true
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
								},
								[2] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
								[3] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[6] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[7] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[8] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
								[9] =
								{
									["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
								},
							},
							["fuel"] = "4864",
							["flare"] = 0,
							["chaff"] = 0,
							["gun"] = 0,
						},
						["QRA"] = {
							["pylons"] =
							{
								[2] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
								[3] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[6] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[7] =
								{
									["CLSID"] = "{AIM-7E}",
								},
								[8] =
								{
									["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
								},
							},
							["fuel"] = "4864",
							["flare"] = 0,
							["chaff"] = 0,
							["gun"] = 0,
						}
					}
				},
				["callsigns"] = {
					"Toophan",
					"Alvand",
					"Sahand",
					"Alborz",
					"Kaman"
				}
			},
			["72TFS"] = {
				["name"] = "72nd TFS",
				["country"] = country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = capability.Full,
				["allWeatherAG"] = capability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
				["interceptRadius"] = 300000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{LAU-138 wtip - AIM-9L}",
								},
								[2] =
								{
									["CLSID"] = "{SHOULDER AIM-7F}",
								},
								[4] =
								{
									["CLSID"] = "{AIM_54A_Mk47}",
								},
								[5] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[6] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[7] =
								{
									["CLSID"] = "{AIM_54A_Mk47}",
								},
								[9] =
								{
									["CLSID"] = "{SHOULDER AIM-7F}",
								},
								[10] =
								{
									["CLSID"] = "{LAU-138 wtip - AIM-9L}",
								},
							},
							["fuel"] = 7348,
							["flare"] = 60,
							["ammo_type"] = 1,
							["chaff"] = 140,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Shahin",
					"Oghab",
					"Toophan"
				}
			},
			["73TFS"] = {
				["name"] = "73rd TFS",
				["country"] = country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = capability.Full,
				["allWeatherAG"] = capability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
				["interceptRadius"] = 300000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{LAU-138 wtip - AIM-9L}",
								},
								[2] =
								{
									["CLSID"] = "{SHOULDER AIM-7F}",
								},
								[4] =
								{
									["CLSID"] = "{AIM_54A_Mk47}",
								},
								[5] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[6] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[7] =
								{
									["CLSID"] = "{AIM_54A_Mk47}",
								},
								[9] =
								{
									["CLSID"] = "{SHOULDER AIM-7F}",
								},
								[10] =
								{
									["CLSID"] = "{LAU-138 wtip - AIM-9L}",
								},
							},
							["fuel"] = 7348,
							["flare"] = 60,
							["ammo_type"] = 1,
							["chaff"] = 140,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Shahin",
					"Oghab",
					"Shahab"
				}
			}
		}
	}
}

---------------------------------------------------------------------------------------------------------------------------
-- helpful functions
-- get distance between two points using the power of Pythagoras
local function getDistance(x1, y1, x2, y2)
	return math.sqrt(((x1 - x2)*(x1 - x2)) + ((y1 - y2)*(y1 - y2)))
end
-- get magnitude from a vector
local function getMagnitude(vector)
	return math.sqrt((vector.x^2 + vector.y^2 + vector.z^2))
end
-- get the size of a given table
local function getTableSize(table)
	local size = 0
	for key in pairs(table) do
		size = size + 1
	end
	return size
end
-- get a randomized skill level from a given baseline
-- TODO: replace with percentage-based tables that can be defined per squadron
local function getSkill(baseline)
	local adjustment = math.random(10)
	if (baseline == "Average") then
		if adjustment > 6 then
			return "Good"
		end
		return "Average"
	end
	if (baseline == "Good") then
		if adjustment <= 2 then
			return "Average"
		elseif adjustment > 6 then
			return "Good"
		end
		return "Good"
	end
	if (baseline == "High") then
		if adjustment <= 2 then
			return "Good"
		elseif adjustment > 6 then
			return "Excellent"
		end
		return "High"
	end
	if (baseline == "Excellent") then
		if adjustment < 5 then
			return "High"
		end
		return "Excellent"
	end
	-- I dunno what's going on if we get here
	env.info("Blue Air Debug: Unit skill assignment broke", 0)
	return "High"
end
-- get aircraft type of a flight
-- since all members of a flight should be the same type, just get the type from one and return
local function getFlightType(flight)
	for key, unit in pairs(flight:getUnits()) do
		if unit:getTypeName() ~= nil then
			return unit:getTypeName()
		end
	end
end
-- get average flight distance from point
local function getFlightDistance(flight, x, y)
	local flightElements = 0
	local distanceTotal = 0
	for key, unit in pairs(flight:getUnits()) do
		flightElements = flightElements + 1
		distanceTotal = distanceTotal + getDistance(unit:getPoint().x, unit: getPoint().z, x, y)
	end
	return (distanceTotal / flightElements)
end
-- get altitude of lowest element in flight
local function getLowestFlightAltitude(flight)
	local lowestAltitude = nil
	for key, unit in pairs(flight:getUnits()) do
		if (lowestAltitude == nil) or (unit:getPoint().y < lowestAltitude) then
			lowestAltitude = unit:getPoint().y
		end
	end
	return lowestAltitude
end
---------------------------------------------------------------------------------------------------------------------------
local trackTimeout = 90 -- amount of time before tracks are timed out
local trackCorrelationDistance = 5000 -- maximum distance in meters between which a target will correlate with a track
local trackCorrelationAltitude = 5000 -- maximum altitude difference in meters between which a target will correlate with a track

local primaryTrackers = {} -- list of primary tracking units: EWRs and search radars
local secondaryTrackers = {} -- list of secondary tracking units: infantry and local air defence
local tracks = {} -- list of airborne target tracks created by the AD system
local nextTrackNumber = 0 -- iterator to prevent track IDs from repeating

-- evaluate whether a unit has the necessary properties then add it to the list of trackers
-- TODO: make sure insurgent units are not counted
-- TODO: add AWACS
-- TODO: add ships
-- TODO: remove SHORAD trackers?
local function addTracker(unit)
	if (unit:hasAttribute("EWR") or unit:hasAttribute("SAM SR")) then
		primaryTrackers[unit:getID()] = unit
		env.info("Blue Air Debug: Added " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " to primary trackers", 0)
	elseif (unit:hasAttribute("Infantry") or unit:hasAttribute("Air Defence")) then
		secondaryTrackers[unit:getID()] = unit
		env.info("Blue Air Debug: Added " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " to secondary trackers", 0)
	end
end

-- remove unit from tracker list
local function removeTracker(unit)
	if (primaryTrackers[unit:getID()]  ~= nil) then
		primaryTrackers[unit:getID()] = nil
		env.info("Blue Air Debug: Removed " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " from primary trackers", 0)
	end

	if (secondaryTrackers[unit:getID()] ~= nil) then
		secondaryTrackers[unit:getID()] = nil
		env.info("Blue Air Debug: Removed " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " from secondary trackers", 0)
	end
end

-- build AD tracker lists at mission start
local function initializeTrackers()
	for key, group in pairs(coalition.getGroups(side, Group.Category.GROUND)) do
		for key, unit in pairs(group:getUnits()) do
			addTracker(unit)
		end
	end
end

-- update track with new data
local function updateTrack(trackID, target)
	tracks[trackID].x = target.object:getPoint().x
	tracks[trackID].y = target.object:getPoint().z
	tracks[trackID].alt = target.object:getPoint().y
	tracks[trackID].extrapolated = false
	if highThreatType[target.object:getTypeName()] == true then
		tracks[trackID].highThreat = true
	end
	tracks[trackID].lastUpdate = timer.getTime()
end

-- update track with new data
local function extrapolateTrack(trackID)
	tracks[trackID].extrapolated = true
end

-- create new track and initialize data
local function createTrack(target)
	tracks[nextTrackNumber] = {}
	updateTrack(nextTrackNumber, target)
	env.info("Blue Air Debug: Created new track ID " .. tostring(nextTrackNumber))
	env.info("Blue Air Debug: Updated track ID " .. tostring(nextTrackNumber) .. " with target " .. target.object:getTypeName() .. " " .. tostring(target.object:getID()), 0)
	nextTrackNumber = nextTrackNumber + 1
end

-- correlate target to existing track
-- currently this should have the effect of merging multiple close contacts which should be desirable for our purposes
-- TODO: Handle very fast targets with heading and speed discrimination
local function correlateTrack(trackID, target)
	if getDistance(tracks[trackID].x, tracks[trackID].y, target.object:getPoint().x, target.object:getPoint().z) < trackCorrelationDistance then
		if math.abs(target.object:getPoint().y - tracks[trackID].alt) < trackCorrelationAltitude then
			return true
		end
	end
	return false
end

-- TODO: Track weapons?
local function detectTargets()
	-- go through list of detected targets by primary tracking units and create or update existing tracks
	for key, tracker in pairs(primaryTrackers) do
		if (tracker:isExist()) then -- check if our tracker still exists
			local targets = tracker:getController():getDetectedTargets(Controller.Detection.RADAR) -- get all targets currently detected by this tracker
			--env.info("Blue Air Debug: " .. tracker:getTypeName() .. " " .. tostring(tracker:getID()) .. " tracking " .. getTableSize(targets) .. " targets", 0)
			for key, target in pairs(targets) do
				if (target.object ~= nil) and (target.object:getCategory() == Object.Category.UNIT) and (target.object:getCoalition() ~= side) then
					local targetCorrelated = false
					-- check if target can be correlated to any existing tracks
					for key, track in pairs(tracks) do
						if correlateTrack(key, target) then
							updateTrack(key, target)
							targetCorrelated = true
							--env.info("Blue Air Debug: Updated track ID " .. tostring(key) .. " with target " .. target.object:getTypeName() .. " " .. tostring(target.object:getID()), 0)
						end
					end
					-- if target can't be correlated to any track, create a new track
					if targetCorrelated == false then
						createTrack(target)
					end
				end
			end
		else  -- if tracker doesn't exist then remove it from the list
			primaryTrackers[key] = nil
			env.info("Blue Air Debug: Removed " .. " " .. tostring(key) .. " from primary trackers", 0)
		end
	end
		-- same for secondary trackers
	for key, tracker in pairs(secondaryTrackers) do
		if (tracker:isExist()) then -- check if our tracker still exists
			local targets = tracker:getController():getDetectedTargets(Controller.Detection.RADAR, Controller.Detection.VISUAL, Controller.Detection.OPTIC, Controller.Detection.IRST) -- get all targets currently detected by this tracker
			-- env.info("Blue Air Debug: " .. tracker:getTypeName() .. " " .. tostring(tracker:getID()) .. " tracking " .. getTableSize(targets) .. " targets", 0)
			for key, target in pairs(targets) do
				if (target.object ~= nil) and (target.object:getCategory() == Object.Category.UNIT) and (target.object:getCoalition() ~= side) then
					local targetCorrelated = false
					-- check if target can be correlated to any existing tracks
					for key, track in pairs(tracks) do
						if correlateTrack(key, target) then
							updateTrack(key, target)
							targetCorrelated = true
							--env.info("Blue Air Debug: Secondary tracker updated track ID " .. tostring(key) .. " with target " .. target.object:getTypeName() .. " " .. tostring(target.object:getID()), 0)
						end
					end
					-- if target can't be correlated to any track, create a new track
					if targetCorrelated == false then
						createTrack(target)
					end
				end
			end
		else  -- if tracker doesn't exist then remove it from the list
			secondaryTrackers[key] = nil
			env.info("Blue Air Debug: Removed " .. " " .. tostring(key) .. " from primary trackers", 0)
		end
	end
	-- extrapolate all old tracks
	for key, track in pairs(tracks) do
		if (track.lastUpdate < timer.getTime() - 5) then
			extrapolateTrack(key)
			env.info("Blue Air Debug: Extrapolating lost track ID " .. tostring(key), 0)
		end
	end
	timer.scheduleFunction(detectTargets, nil, timer.getTime() + 5)
end

-- delete old tracks that have not been updated
local function timeoutTracks()
	for key, track in pairs(tracks) do
		if (track.lastUpdate < timer.getTime() - trackTimeout) then
			tracks[key] = nil
			env.info("Blue Air Debug: Timed out lost track ID " .. tostring(key) .. " after " .. tostring(timer.getTime() - track.lastUpdate) .. " seconds", 0)
		end
	end
	timer.scheduleFunction(timeoutTracks, nil, timer.getTime() + trackTimeout)
end

initializeTrackers()
detectTargets()
timer.scheduleFunction(timeoutTracks, nil, timer.getTime() + trackTimeout)

---------------------------------------------------------------------------------------------------------------------------
local skipResetTime = 60 -- seconds between a failed launch until airfield will be used again
local preparationTime = 1800 -- time in seconds it takes to prepare the next flight from an airbase
local QRARadius = 30000 -- radius in meters for emergency scramble
local commitRange = 50000 -- radius around uncommitted fighter units at which tracks will be intercepted

local activeAirbases = {} -- active airbases
local flights = {} -- currently active flights

-- initialize all active airbases at mission start
local function initializeAirbases()
	for key, airbase in pairs(airbases) do
		local airbaseID = key
		activeAirbases[airbaseID] = {
			["skip"] = false, -- flag for whether the airbase should be skipped in the next round of air tasking
			["readinessTime"] = timer.getTime(), -- time until next aircraft are ready to launch
		}
		env.info("Blue Air Debug: Airbase " .. airbaseID .. " initialized", 0)
	end
end

-- function to sort airbases by their distance to a target
local function sortAirbaseByRange(first, second)
	if first.range < second.range then
		return true
	else
		return false
	end
end

-- sets a given airbase's skip flag to off
local function resetAirbaseSkip(airbaseID)
	activeAirbases[airbaseID].skip = false
end

-- create and spawn aircraft group for tasking
-- TODO: Add air and non-airbase launch options
local function launchFlight(airbase, squadron, mission, flightSize)
	local flightData = {}
	local loadout = {}
	local units = {}
	local route = {}
	-- get airbase coordinates and elevation from game
	local baseLocation = Airbase.getByName(airbase.name):getPoint()
	-- assign callsign
	local callsign = squadron.callsigns[math.random(getTableSize(squadron.callsigns))]
	local flightNumber = math.random(9)
	flightData = {
		["name"] = callsign .. " " .. tostring(flightNumber)
	}
	-- see if mission specific loadout option exists and, if so, select it
	if (squadron.loadouts[missionClass[mission]].mission ~= nil) then
		loadout = squadron.loadouts[missionClass[mission]].mission
	else
		loadout = squadron.loadouts[missionClass[mission]].General -- if specific mission loadout doesn't exist, use generic A-A
	end
	-- select flight options for mission
	if (mission == "Intercept") or (mission == "QRA") then
		flightData["task"] = "Intercept"
	elseif (mission == "CAP") then
		flightData["task"] = "CAP"
	end
	-- add flight members
	for i=1,flightSize do
		units[i] = {
			["name"] = callsign .. " " .. tostring(flightNumber) .. tostring(i),
			["type"] = squadron.type,
			["x"] = baseLocation.x,
			["y"] = baseLocation.z,
			["alt"] = baseLocation.y,
			["alt_type"] = "BARO",
			["speed"] = 0,
			["skill"] = getSkill(squadron.skill),
			["livery_id"] = squadron.livery,
			["payload"] = loadout,
			["callsign"] = {
				[1] = math.random(9),
				[2] = flightNumber,
				[3] = i,
				["name"] = callsign .. tostring(flightNumber) .. tostring(i)
			},
		}
		units[i]["onboard_num"] = tostring(units[i].callsign[1]) .. tostring(units[i].callsign[2]) .. tostring(units[i].callsign[3])
	end
	flightData["units"] = units
	-- add route waypoint for airfield launch
	route = {
		points = {
			[1] = {
				["type"] = "TakeOff",
				["action"] = "From Runway",
				["airdromeId"] = airbase.ID,
				["speed"] = 0,
				["x"] = baseLocation.X,
				["y"] = baseLocation.Z,
				["alt"] = baseLocation.Y,
			}
		}
	}
	flightData["route"] = route
	-- spawn unit and return
	return coalition.addGroup(squadron.country, typeCategory[squadron.type], flightData)
end

-- send flight home
local function returnToBase(missionData)
	local flightID = missionData.flightID
	local targetID = missionData.targetID
	if flights[flightID]:isExist() == true then
		local controller = flights[flightID]:getController()
		-- activate radar in case we get jumped and set return fire
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
		controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
		local baseLocation = Airbase.getByName(airbases[missionData.airbaseID].name):getPoint()
		local task = {
			id = 'Mission',
			params = {
				airborne = true,
				route = {
					points = {
						[1] = {
							type = "Land",
							action = "Fly Over Point",
							airdromeId = airbases[missionData.airbaseID].ID,
							x = baseLocation.x,
							y = baseLocation.z,
							alt = 30000,
							speed = 150,
							task = {
								id = "ComboTask",
								params = {
									tasks = {
									}
								}
							}
						}
					}
				}
			}
		}
		controller:setTask(task)
		env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " RTB to " .. airbases[missionData.airbaseID].name, 0)
	end
end

-- control flight to intercept target track
local function controlIntercept(missionData)
	local flightID = missionData.flightID
	local targetID = missionData.targetID
	-- check if our flight is even still alive
	if flights[flightID]:isExist() == true then
		-- check if target track is still valid for intercept
		if tracks[targetID] ~= nil then
			local controller = flights[flightID]:getController()
			-- check if expected target position is close enough to activate radar
			local targetInSearchRange = false
			if (radarRange[getFlightType(flights[flightID])] ~= nil) then
				for key, unit in pairs(flights[flightID]:getUnits()) do
					if getDistance(unit:getPoint().x, unit:getPoint().z, tracks[targetID].x, tracks[targetID].y) < radarRange[unit:getTypeName()] then
						targetInSearchRange = true
					end
				end
			else
				targetInSearchRange = true
			end
			if targetInSearchRange then
				controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
				env.info("Blue Air Debug: Flight intercepting " .. tostring(targetID) .. " radar active", 0)
			else
				controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.NEVER)
				env.info("Blue Air Debug: Flight intercepting " .. tostring(targetID) .. " radar off", 0)
			end
			-- check if target is detected by onboard sensors before giving permission to engage
			-- we're doing this to prevent magic datalink intercepts
			local targets = controller:getDetectedTargets(Controller.Detection.RADAR, Controller.Detection.VISUAL, Controller.Detection.OPTIC, Controller.Detection.IRST)
			local targetDetected = false
			local interceptTask
			for key, target in pairs(targets) do
				if (target.object ~= nil) and (target.object:getCategory() == Object.Category.UNIT) and (target.object:getCoalition() ~= side) then
					if correlateTrack(targetID, target) then
						env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " target detected", 0)
						targetDetected = true
						updateTrack(targetID, target)
					end
				end
			end
			if targetDetected then
				env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " free to engage", 0)
				controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE)
				interceptTask = {
					id = "ComboTask",
					params = {
						tasks = {
							[1] = {
							id = 'EngageTargetsInZone',
								params = {
									point = {
										tracks[targetID].x,
										tracks[targetID].y
									},
									zoneRadius = 10000,
									targetTypes = {"Air"},
									priority = 0
								}
							}
						}
					}
				}
			else
				env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " holding engagement", 0)
				controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
				interceptTask = {
					id = "ComboTask",
					params = {
						tasks = {
						}
					}
				}
			end
			-- update current intercept path
			-- determine slowest aircraft velocity and incrementally increase intercept speed from that
			local interceptSpeed = 2000
			for key, unit in pairs(flights[flightID]:getUnits()) do
				if getMagnitude(unit:getVelocity()) < interceptSpeed then
					interceptSpeed = getMagnitude(unit:getVelocity())
				end
			end
			interceptSpeed = interceptSpeed + 50
			local task = {
				id = 'Mission',
				params = {
					airborne = true,
					route = {
						points = {
							[1] = {
								type = "Turning Point",
								action = "Fly Over Point",
								x = tracks[targetID].x,
								y = tracks[targetID].y,
								alt = tracks[targetID].alt,
								speed = interceptSpeed,
								task = interceptTask
							}
						}
					}
				}
			}
			controller:setTask(task)
			env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " task updated", 0)
			env.info("Blue Air Debug: Target position is X: " .. tostring(tracks[targetID].x) .. ", Y: " .. tostring(tracks[targetID].y) .. ", altitude: " .. tostring(tracks[targetID].alt), 0)
			-- schedule next update to flight control
			timer.scheduleFunction(controlIntercept, missionData, timer.getTime() + 5)
		else
			env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " track is nil", 0)
			-- find nearest unengaged target to engage
			local nearestTarget
			local nearestTargetDistance
			for key, track in pairs(tracks) do
				-- get range to the nearest unit in the flight
				local distance
				for key, unit in pairs(flights[flightID]:getUnits()) do
					if distance == nil or getDistance(unit:getPoint().x, unit:getPoint().z, track.x, track.y) < distance then
						distance = getDistance(unit:getPoint().x, unit:getPoint().z, track.x, track.y)
					end
				end
				if nearestTargetDistance == nil or distance < nearestTargetDistance then
					nearestTarget = key
					nearestTargetDistance = distance
				end
			end
			if nearestTargetDistance ~= nil and nearestTarget ~= nil and nearestTargetDistance < commitRange then
				tracks[nearestTarget].engaged = true
				local nextMissionData = {
					["mission"] = "Intercept",
					["airbaseID"] = missionData.airbaseID,
					["squadronID"] = missionData.squadronID,
					["targetID"] = nearestTarget,
					["flightID"] = flightID
				}
				env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " retargeting to track " .. nearestTarget, 0)
				controlIntercept(nextMissionData)
			else
				local nextMissionData = {
					["airbaseID"] = missionData.airbaseID,
					["squadronID"] = missionData.squadronID,
					["flightID"] = flightID
				}
				returnToBase(nextMissionData)
			end
		end
	else
		-- group is dead or MIA and is no longer intercepting
		env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " no longer exists", 0)
		if tracks[targetID] ~= nil then
			tracks[targetID].engaged = false
		end
		-- remove flight from list
		flights[flightID] = nil
	end
end

-- prepare flight according to mission parameters then hand off to the appropriate control function
local function assignMission(missionData)
	local flightID = missionData.flightID
	if (missionData.mission == "Intercept" or missionData.mission == "QRA") then
		-- check if whole flight is airborne
		local flightAirborne = true
		for key, unit in pairs(flights[flightID]:getUnits()) do
			if unit:inAir() == false then
				flightAirborne = false
			end
		end
		if flightAirborne then
			local controller = flights[flightID]:getController()
			-- set up flight options according to intercept doctrine
			controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
			controller:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE)
			if (radarRange[getFlightType(flights[flightID])] ~= nil) then
				controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.NEVER)
				env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " radar off", 0)
			else
				controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
				env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " radar active", 0)
			end
			controller:setOption(AI.Option.Air.id.FORMATION, fixedWingFormation.LABSClose)
			controller:setOption(AI.Option.Air.id.ECM_USING, AI.Option.Air.val.ECM_USING.USE_IF_ONLY_LOCK_BY_RADAR)
			controller:setOption(AI.Option.Air.id.PROHIBIT_AG, true)
			controller:setOption(AI.Option.Air.id.MISSILE_ATTACK, AI.Option.Air.val.MISSILE_ATTACK.HALF_WAY_RMAX_NEZ) -- TODO: more complex decision on that
			-- hand off to intercept controller
			env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(missionData.targetID) .. " handed off to intercept controller", 0)
			controlIntercept(missionData)
		else
			-- if flight is not yet airborne, wait until it is before handing off control
			env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(missionData.targetID) .. " still not airborne", 0)
			timer.scheduleFunction(assignMission, missionData, timer.getTime() + 5)
		end
	end
end

-- receive allocated airframes, launch the flight and hand off to aircraft configuration and control
local function launchSortie(missionData)
	-- launch the flight
	local flight = launchFlight(airbases[missionData.airbaseID], airbases[missionData.airbaseID].Squadrons[missionData.squadronID], missionData.mission, missionData.flightSize)
	if flight ~= nil then
		local flightID = flight:getID()
		flights[flightID] = flight
		-- hand off control
		local updatedMissionData = {
			["mission"] = missionData.mission,
			["airbaseID"] = missionData.airbaseID,
			["squadronID"] = missionData.squadronID,
			["targetID"] = missionData.targetID,
			["flightSize"] = missionData.flightSize,
			["flightID"] = flightID
		}
		-- set airfield readiness time
		activeAirbases[missionData.airbaseID].readinessTime = timer.getTime() + preparationTime
		-- the script might crash if we do this right away?
		timer.scheduleFunction(assignMission, updatedMissionData, timer.getTime() + 1)
	else
		-- if our flight didn't launch for whatever reason, try again later
		if tracks[missionData.targetID] ~= nil then
			tracks[missionData.targetID].engaged = false
		end
		-- mark airfield skip so next time we'll try again from a different one
		activeAirbases[missionData.airbaseID].skip = true
		timer.scheduleFunction(skipResetTime, missionData.airbaseID, timer.getTime() + skipResetTime)
	end
end

-- allocate airframes from squadron to the mission and hand it off for preparation
local function allocateAirframes(mission, airbaseID, squadronID, targetID)
	local flightSize -- how many airframes we want to launch
	-- determine how many aircraft to launch
	local rand = math.random(10)
	if rand <= 7 then
		flightSize = 2 -- baseline flight of two
	end
	if rand > 8 then
		flightSize = 3
	end
	-- reduce flight size for high priority squadrons
	if airbases[airbaseID].Squadrons[squadronID].highPriority == true then
		flightSize = flightSize - 1
	end
	-- launch flight and hand off to flight preparation
	local missionData = {
		["mission"] = mission,
		["airbaseID"] = airbaseID,
		["squadronID"] = squadronID,
		["targetID"] = targetID,
		["flightSize"] = flightSize
	}
	launchSortie(missionData)
end

-- main loop for dispatching packages and flights
local function airTaskingOrder()
	-- find unengaged targets and launch interceptors
	for key, track in pairs(tracks) do
		if track.engaged ~= true then
			local trackID = key
			local excluded = false
			-- check if track is in an ADZ exclusion zone
			for key, zone in pairs(ADZExclusion) do
				if getDistance(tracks[trackID].x, tracks[trackID].y, zone.x, zone.y) < zone.radius then
					excluded = true
				end
			end
			if excluded ~= true then
				-- sort airbases by distance to target
				local availableAirbases = {}
				for key, airbase in pairs(activeAirbases) do
					if airbase.skip ~= true and timer.getTime() > airbase.readinessTime then
						local baseLocation = Airbase.getByName(airbases[key].name):getPoint()
						local airbaseData = {
							["airbaseID"] = key,
							["range"] = getDistance(tracks[trackID].x, tracks[trackID].y, baseLocation.x, baseLocation.z)
						}
						table.insert(availableAirbases, airbaseData)
					end
				end
				table.sort(availableAirbases, sortAirbaseByRange)
				-- find an applicable squadron, randomizing from the closest airbases in order
				local interceptAirbase
				local interceptSquadron
				for key, airbaseData in ipairs(availableAirbases) do
					local baseLocation = Airbase.getByName(airbases[airbaseData.airbaseID].name):getPoint()
					local counter = 0
					local squadrons = {}
					-- add up all the squadrons in the airbase and select a random one
					for key, squadron in pairs(airbases[airbaseData.airbaseID].Squadrons) do
						if getDistance(tracks[trackID].x, tracks[trackID].y, baseLocation.x, baseLocation.z) < squadron.interceptRadius then
							-- use high priority squadrons only for high threat tracks
							if tracks[trackID].highThreat == true then
								table.insert(squadrons, key)
								counter = counter + 1
							else
								if squadron.highPriority ~= true then
									table.insert(squadrons, key)
									counter = counter + 1
								end
							end
						end
					end
					if counter > 0 then
						interceptAirbase = airbaseData.airbaseID
						interceptSquadron = squadrons[math.random(counter)]
						break
					end
				end
				-- if we have any squadrons available, launch the intercept
				if interceptSquadron ~= nil then
					tracks[trackID].engaged = true
					-- TODO: Add QRA
					allocateAirframes("Intercept", interceptAirbase, interceptSquadron, trackID)
				end
			end
		end
	end
	timer.scheduleFunction(airTaskingOrder, nil, timer.getTime() + 15)
end

initializeAirbases()
airTaskingOrder()

---------------------------------------------------------------------------------------------------------------------------
-- function handling DCS events
function handler:onEvent(event)
	-- add air defence tracking units when spawned
	if event.id == world.event.S_EVENT_BIRTH then
		if event.initiator:getCategory() == Object.Category.UNIT then
			if event.initiator:getGroup():getCoalition() == side then
				addTracker(event.initiator)
			end
		end
	end
end

world.addEventHandler(handler) -- add DCS event handler