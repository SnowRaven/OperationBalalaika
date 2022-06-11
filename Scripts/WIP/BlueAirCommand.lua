-- OKB-17 air tasking and interception system by Arctic Fox --

local handler = {} -- DCS event handler

-- enum and stuff
local country = {
	["Iran"] = 34
}
local missionClass = {
	["Intercept"] = "AA",
	["CAP"] = "AA",
	["QRA"] = "AA"
}
local typeAlias = {
	["F-14A-135-GR"] = "Tomcat",
	["F-4E"] = "Phantom",
	["F-5E-3"] = "Tiger"
}
local typeCategory = {
	["F-14A-135-GR"] = Group.Category.AIRPLANE,
	["F-4E"] = Group.Category.AIRPLANE,
	["F-5E-3"] = Group.Category.AIRPLANE
}

---------------------------------------------------------------------------------------------------------------------------
-- Faction and squadron data
local side = 2 -- BLUFOR

local airbases = {
	["Bandar Abbas"] = {
		name = "Bandar Abbas Intl", -- DCS name
		ID = 2,
		Squadrons = {
			["91TFS"] = {
				["name"] = "91st TFS",
				["country"] = country.Iran,
				["type"] = "F-4E",
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
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
					"Sword",
					"Scimitar",
					"Rapier",
					"Lion"
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
					"Sword",
					"Scimitar",
					"Rapier",
					"Lion"
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
					"Sword",
					"Scimitar",
					"Rapier",
					"Lion"
				}
			},
			["72TFS"] = {
				["name"] = "72nd TFS",
				["country"] = country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "Rogue Nation(Top Gun - Maverick)",
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
					"Sword",
					"Scimitar",
					"Rapier",
					"Lion"
				}
			},
			["73TFS"] = {
				["name"] = "73rd TFS",
				["country"] = country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "Rogue Nation(Top Gun - Maverick)",
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
					"Sword",
					"Scimitar",
					"Rapier",
					"Lion"
				}
			}
		}
	}
}

---------------------------------------------------------------------------------------------------------------------------
-- helpful functions
-- get the size of a given table
local function getTableSize(table)
	local size = 0
	for _ in pairs(table) do
		size = size + 1
	end
	return size
end
-- get a randomized skill level from a given baseline
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
	return "Excellent"
end

---------------------------------------------------------------------------------------------------------------------------
local primaryTrackers = {} -- list of primary tracking units: EWRs and search radars
local secondaryTrackers = {} -- list of secondary tracking units: infantry and local air defence
local tracks = {} -- list of airborne target tracks created by the AD system

-- evaluate whether a unit has the necessary properties then add it to the list of trackers
-- TODO: make sure insurgent units are not counted
local function addTracker(unit)
	if (unit:hasAttribute("EWR") or unit:hasAttribute("SAM SR")) then
		primaryTrackers[unit:getID()] = unit
		env.info("Blue Air Debug: Added " .. tostring(unit:getID()) .. " to primary trackers", 0)
	elseif (unit:hasAttribute("Infantry") or unit:hasAttribute("Air Defence")) then
		secondaryTrackers[unit:getID()] = unit
		env.info("Blue Air Debug: Added " .. tostring(unit:getID()) .. " to secondary trackers", 0)
	end
end

-- remove unit from tracker list
local function removeTracker(unit)
	if (primaryTrackers[unit:getID()]  ~= nil) then
		primaryTrackers[unit:getID()] = nil
		env.info("Blue Air Debug: Removed " .. tostring(unit:getID()) .. " from primary trackers", 0)
	end

	if (secondaryTrackers[unit:getID()] ~= nil) then
		secondaryTrackers[unit:getID()] = nil
		env.info("Blue Air Debug: Removed " .. tostring(unit:getID()) .. " from secondary trackers", 0)
	end
end

-- build AD tracker lists at mission start
local function initializeTrackers()
	for _, group in pairs(coalition.getGroups(side, GROUND)) do
		for _, unit in pairs(group:getUnits()) do
			addTracker(unit)
		end
	end
end

initializeTrackers()

local function createTrack()

end

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
			["name"] = callsign .. tostring(i),
			["type"] = squadron.type,
			["x"] = baseLocation.X,
			["y"] = baseLocation.Z,
			["alt"] = baseLocation.Y,
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
launchFlight(airbases.Shiraz, airbases.Shiraz.Squadrons["72TFS"], "Intercept", 2)

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