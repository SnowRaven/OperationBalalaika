-- OKB-17 air tasking and interception system by Arctic Fox --

local handler = {} -- DCS event handler

---------------------------------------------------------------------------------------------------------------------------
-- enum and stuff
-- DCS country IDs
local country = {
	["Iran"] = 34
}
-- all weather/night capability enum
local allWeatherCapability = {
	["None"] = 0,
	["Limited"] = 1,
	["Full"] = 2
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
				["allWeatherAA"] = allWeatherCapability.Full,
				["allWeatherAG"] = allWeatherCapability.None,
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
				["allWeatherAA"] = allWeatherCapability.Limited,
				["allWeatherAG"] = allWeatherCapability.None,
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
									["CLSID"] = "{PTB-150GAL}",
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
				["allWeatherAA"] = allWeatherCapability.Full,
				["allWeatherAG"] = allWeatherCapability.None,
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
				["allWeatherAA"] = allWeatherCapability.Full,
				["allWeatherAG"] = allWeatherCapability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
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
				["allWeatherAA"] = allWeatherCapability.Full,
				["allWeatherAG"] = allWeatherCapability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
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

---------------------------------------------------------------------------------------------------------------------------
local trackTimeout = 90 -- amount of time before tracks are timed out
local trackCorrelationDistance = 10000 -- maximum distance in meters between which a target will correlate with a track
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
		env.info("Blue Air Debug: Removed " .. " " .. unit:getTypeName() .. tostring(unit:getID()) .. " from primary trackers", 0)
	end

	if (secondaryTrackers[unit:getID()] ~= nil) then
		secondaryTrackers[unit:getID()] = nil
		env.info("Blue Air Debug: Removed " .. " " .. unit:getTypeName() .. tostring(unit:getID()) .. " from secondary trackers", 0)
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
local function updateTrack(track, target)
	track["x"] = target.object:getPoint().x
	track["y"] = target.object:getPoint().z
	track["alt"] = target.object:getPoint().y
--	track["speed"] = target.object:getVelocity()
--	if (target.type) then
--		track["type"] = target.object:getTypeName()
--	end
	track["extrapolated"] = false
	track["lastUpdate"] = timer.getTime()
end

-- update track with new data
local function extrapolateTrack(track)
	track["extrapolated"] = true
end

-- create new track and initialize data
local function createTrack(target)
	tracks[nextTrackNumber] = {}
	updateTrack(tracks[nextTrackNumber], target)
	env.info("Blue Air Debug: Created new track ID " .. tostring(nextTrackNumber))
	env.info("Blue Air Debug: Updated track ID " .. tostring(nextTrackNumber) .. " with target " .. target.object:getTypeName() .. " " .. tostring(target.object:getID()), 0)
	nextTrackNumber = nextTrackNumber + 1
end

-- correlate target to existing track
-- currently this should have the effect of merging multiple close contacts which should be desirable for our purposes
-- TODO: Handle very fast targets with heading and speed discrimination
local function correlateTrack(track, target)
	if getDistance(track.x, track.y, target.object:getPoint().x, target.object:getPoint().z) < trackCorrelationDistance then
		if math.abs(target.object:getPoint().y - track["alt"]) < trackCorrelationAltitude then
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
			env.info("Blue Air Debug: " .. tracker:getTypeName() .. " " .. tostring(tracker:getID()) .. " tracking " .. getTableSize(targets) .. " targets", 0)
			for key, target in pairs(targets) do
				if (target.object:getCategory() == Object.Category.UNIT) and (target.object:getCoalition() ~= side) then
					local targetCorrelated = false
					-- check if target can be correlated to any existing tracks
					for key, track in pairs(tracks) do
						if correlateTrack(track, target) then
							updateTrack(track, target)
							targetCorrelated = true
							env.info("Blue Air Debug: Updated track ID " .. tostring(key) .. " with target " .. target.object:getTypeName() .. " " .. tostring(target.object:getID()), 0)
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
	-- extrapolate all old tracks
	for key, track in pairs(tracks) do
		if (track.lastUpdate < timer.getTime() - 5) then
			extrapolateTrack(track)
			env.info("Blue Air Debug: Extrapolating lost track ID " .. tostring(key), 0)
		end
	end
	timer.scheduleFunction(detectTargets, {}, timer.getTime() + 15)
end

-- delete old tracks that have not been updated
local function timeoutTracks()
	for key, track in pairs(tracks) do
		if (track.lastUpdate < timer.getTime() - trackTimeout) then
			tracks[key] = nil
			env.info("Blue Air Debug: Timed out lost track ID " .. tostring(key) .. " after " .. tostring(timer.getTime() - track.lastUpdate) .. " seconds", 0)
		end
	end
	timer.scheduleFunction(timeoutTracks, {}, timer.getTime() + trackTimeout)
end

initializeTrackers()
detectTargets()
timer.scheduleFunction(timeoutTracks, {}, timer.getTime() + trackTimeout)

---------------------------------------------------------------------------------------------------------------------------
-- create and spawn aircraft group for tasking
-- TODO: Add air and non-airbase launch options
local function launchFlight(airbase, squadron, mission, strength)
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
	for i=1,strength do
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
-- launchFlight(airbases.Abbas, airbases.Abbas.Squadrons["91TFS"], "Intercept", 3)

-- main loop for dispatching packages and flights
local function airTaskingOrder()
	timer.scheduleFunction(airTaskingOrder, {}, timer.getTime() + 15)
end

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

	-- remove air defence tracking units when killed or despawned
	if event.id == world.event.S_EVENT_DEAD then
		if event.initiator:getCategory() == Object.Category.UNIT then
			removeTracker(event.initiator)
		end
	end
end

world.addEventHandler(handler) -- add DCS event handler