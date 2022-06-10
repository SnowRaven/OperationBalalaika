-- OKB-17 air tasking and interception system --

local handler = {}
local side = 2 -- BLUFOR

-- enum
local Country = {
	["Iran"] = 34
}
local Mission = {
	["Intercept"] = 0,
	["QRA"] = 1,
	["CAP"] = 2,
	["AMBUSHCAP"] = 3
}
local TypeAlias = {
	["F-14A-135-GR"] = "Tomcat",
	["F-4E"] = "Phantom",
	["F-5E-3"] = "Tiger"
}
local Skill = {
	[0] = "Average",
	[1] = "Good",
	[2] = "High",
	[3] = "Excellent",
	["Rookie"] = "Average",
	["Trained"] = "Good",
	["Veteran"] = "High",
	["Ace"] = "Excellent"
}

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
initializeTrackers()

local function createTrack()

end

---------------------------------------------------------------------------------------------------------------------------

-- define airbases and squadrons under this command
local Airbases = {
	["Bandar Abbas"] = {
		ID = 2,
		Squadrons = {
			["91TFS"] = {
				["name"] = "91st TFS",
				["country"] = Country.Iran,
				["type"] = "F-4E",
				["skill"] = "Veteran",
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
				}
			}
		}
	},
	["Lar"] = {
		ID = 11,
		Squadrons = {
			["23TFS"] = {
				["name"] = "23rd TFS",
				["country"] = Country.Iran,
				["type"] = "F-5E-3",
				["skill"] = "Veteran",
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
						["CAP"] = {
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
				}
			}
		}
	},
	["Shiraz"] = {
		ID = 19,
		Squadrons = {
			["71TFS"] = {
				["name"] = "71st TFS",
				["country"] = Country.Iran,
				["type"] = "F-4E", -- F-4D
				["skill"] = "Veteran",
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
				}
			},
			["72TFS"] = {
				["name"] = "72nd TFS",
				["country"] = Country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "Veteran",
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
				}
			},
			["73TFS"] = {
				["name"] = "73rd TFS",
				["country"] = Country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "Veteran",
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
				}
			}
		}
	}
}

local function launchFlight(airbase, squadron, mission, strength)
	local loadout = {}
	local flightData = {
		["name"] = (squadron.name .. " " .. mission .. " " .. TypeAlias[squadron.type])
	}
	if (mission == Mission.Intercept) then
		if (squadron.loadouts.AA.mission ~= nil) then
			loadout = squadron.loadouts.AA.mission
		else
			loadout = squadron.loadouts.AA.General
		end
		flightData["task"] = "Intercept"
	end
end