-- OKB-17 air tasking and interception system by Arctic Fox --

local handler = {} -- DCS event handler

---------------------------------------------------------------------------------------------------------------------------
-- enum and stuff
-- DCS country IDs
local country = {
	["Iran"] = 34,
	["USSR"] = 68
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
local rotaryFormation = {
	["Wedge"] = 8,
	["FrontRightClose"] = 655361,
	["FrontRightOpen"] = 655362,
	["FrontLeftClose"] = 655617,
	["FrontLeftOpen"] = 655618
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
	["QRA"] = "AA",
	["CAP"] = "AA",
	["Escort"] = "AA",
	["HAVCAP"] = "AA",
	["Tanker"] = "Logistics"
}
-- names for unit types
local typeAlias = {
	["F-14A-135-GR"] = "Tomcat",
	["F-4E"] = "Phantom",
	["F-5E-3"] = "Tiger",
	["AH-1W"] = "Cobra",
	["KC-135"] = "KC-707",
	["KC135MPRS"] = "KC-707",
	["MiG-31"] = "Foxhound",
	["IL-78M"] = "Midas"
}
-- DCS categories for unit types
local typeCategory = {
	["F-14A-135-GR"] = Group.Category.AIRPLANE,
	["F-4E"] = Group.Category.AIRPLANE,
	["F-5E-3"] = Group.Category.AIRPLANE,
	["KC-135"] = Group.Category.AIRPLANE,
	["KC135MPRS"] = Group.Category.AIRPLANE,
	["AH-1W"] = Group.Category.HELICOPTER,
	["MiG-31"] = Group.Category.AIRPLANE,
	["IL-78M"] = Group.Category.AIRPLANE
}

-- DCS categories for weapon types
local weaponTypes = {
	["GuidedWeapon"] = 268402702
}

---------------------------------------------------------------------------------------------------------------------------
-- faction, squadron and air defense logic data
local side = coalition.side.BLUE

-- general cruise speed and altitude unless defined otherwise
local standardAltitude = 7620
local returnAltitude = 10973 -- RTB altitude
local standardSpeed = 250

-- altitude and speeds used for tanker operations
local tankerParameters = {
	["KC-135"] = {
		altitude = 6096,
		speed = 211
	},
	["KC135MPRS"] = {
		altitude = 6096,
		speed = 211
	}
}

-- table defining preferred tactics for each aircraft type
-- if not defined, will be determined randomly or according to threat (TODO)
local preferredTactic = {
	["F-5E-3"] = interceptTactic.SternLow,
	["F-14A-135-GR"] = interceptTactic.LeadHigh
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
	["F-4E"] = 60000
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

local tankerOrbits = {
	["Shiraz"] = {
		[1] = {
			["x"] = 340121,
			["y"] = -205223
		},
		[2] = {
			["x"] = 287224,
			["y"] = -150008
		}
	},
	["Abbas"] = {
		[1] = {
			["x"] = 226045,
			["y"] = -48664
		},
		[2] = {
			["x"] = 175307,
			["y"] = 25752
		}
	}
}

-- airbases and squadrons
local airbases = {
	["Abbas"] = {
		name = "Bandar Abbas Intl", -- DCS name
		takeoffHeading = 0.488, -- in radians
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
					["QRA"] = true,
					["CAP"] = true,
					["Escort"] = true,
					["HAVCAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.AIRPLANE
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
			},
			["82TFS"] = {
				["name"] = "82nd TFS",
				["country"] = country.Iran,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = capability.Full,
				["allWeatherAG"] = capability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
				["interceptRadius"] = 220000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true,
					["HAVCAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.AIRPLANE
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
			}
		}
	},
	["Lar"] = {
		name = "Lar", -- DCS name
		takeoffHeading = 1.576, -- in radians
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
					["QRA"] = true,
					["CAP"] = true,
					["Escort"] = true,
					["HAVCAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.AIRPLANE
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
		takeoffHeading = 2.037, -- in radians
		Squadrons = {
			["71TFS"] = {
				["name"] = "71st TFS",
				["country"] = country.Iran,
				["type"] = "F-4E", -- F-4D
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = capability.Full,
				["allWeatherAG"] = capability.None,
				["interceptRadius"] = 350000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true,
					["CAP"] = true,
					["Escort"] = true,
					["HAVCAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.AIRPLANE
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
				["interceptRadius"] = 350000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true,
					["HAVCAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.AIRPLANE
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
				["interceptRadius"] = 350000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true,
					["HAVCAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.AIRPLANE
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
			},
			["11TS"] = {
				["name"] = "11th TS",
				["country"] = country.Iran,
				["type"] = "KC135MPRS", -- KC-707
				["skill"] = "High",
				["livery"] = "IRIAF (2)",
				["missions"] = {
					["Tanker"] = true
				},
				["loadouts"] = {
					["Logistics"] = {
						["General"] = {
							["pylons"] =
							{
							},
							["fuel"] = 90700,
							["flare"] = 0,
							["chaff"] = 0,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Karoon",
					"Paykan",
					"Nahid",
					"Mahtab"
				}
			}
		}
	},
	["Kahnuj FB"] = {
		name = "Kahnuj FB", -- DCS name
		takeoffHeading = 0.436, -- in radians
		Squadrons = {
			["3CSG"] = {
				["name"] = "3rd CSG",
				["country"] = country.Iran,
				["type"] = "AH-1W", -- AH-1J
				["skill"] = "Excellent",
				["livery"] = "I.R.I.A.A",
				["allWeatherAA"] = capability.None,
				["allWeatherAG"] = capability.None,
				["interceptRadius"] = 40000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true,
					["CAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.HELICOPTER
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] = 
							{
								[1] = 
								{
									["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
								}, -- end of [1]
								[4] = 
								{
									["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
								}, -- end of [4]
							}, -- end of ["pylons"]
							["fuel"] = "1250.0",
							["flare"] = 30,
							["chaff"] = 30,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Oghab",
					"Sahand",
					"Shahin",
					"Babr"
				}
			}
		}
	},
	["Sirjan FB"] = {
		name = "Sirjan FB", -- DCS name
		takeoffHeading = 1.047, -- in radians
		Squadrons = {
			["3CSG"] = {
				["name"] = "3rd CSG",
				["country"] = country.Iran,
				["type"] = "AH-1W", -- AH-1J
				["skill"] = "Excellent",
				["livery"] = "I.R.I.A.A",
				["allWeatherAA"] = capability.None,
				["allWeatherAG"] = capability.None,
				["interceptRadius"] = 40000, -- radius of action around the airbase for interceptors from this squadron in meters
				["missions"] = {
					["Intercept"] = true,
					["QRA"] = true,
					["CAP"] = true
				},
				["targetCategories"] = {
					[1] = Unit.Category.HELICOPTER
				},
				["loadouts"] = {
					["AA"] = {
						["General"] = {
							["pylons"] = 
							{
								[1] = 
								{
									["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
								}, -- end of [1]
								[4] = 
								{
									["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
								}, -- end of [4]
							}, -- end of ["pylons"]
							["fuel"] = "1250.0",
							["flare"] = 30,
							["chaff"] = 30,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					"Oghab",
					"Sahand",
					"Shahin",
					"Babr"
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
local trackTimeout = 120 -- amount of time before tracks are timed out
local trackCorrelationDistance = 8000 -- maximum distance in meters between which a target will correlate with a track
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
	tracks[nextTrackNumber].category = target.object:getDesc().category
	updateTrack(nextTrackNumber, target)
	env.info("Blue Air Debug: Created new track ID " .. tostring(nextTrackNumber) .. ". Category: " .. tracks[nextTrackNumber].category)
	env.info("Blue Air Debug: Updated track ID " .. tostring(nextTrackNumber) .. " with target " .. target.object:getTypeName() .. " " .. tostring(target.object:getID()), 0)
	nextTrackNumber = nextTrackNumber + 1
end

-- correlate target to existing track
-- currently this should have the effect of merging multiple close contacts which should be desirable for our purposes
-- TODO: Handle very fast targets with heading and speed discrimination
local function correlateTrack(trackID, target)
	if tracks[trackID].category ~= target.object:getDesc().category then
		return false
	end
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
local groundStartRadius = 30000 -- radius around an airfield where if a player is present, a flight will ground instead of air start
local skipResetTime = 60 -- seconds between a failed launch until airfield will be used again
local minPackageTime = 1800 -- minimum number of seconds before the package ATO reactivates
local maxPackageTime = 5400 -- maximum number of seconds before the package ATO reactivates
local preparationTime = 1500 -- time in seconds it takes to prepare the next interceptors from an airbase
local QRARadius = 60000 -- radius in meters for emergency scramble
local commitRange = 60000 -- radius in meters around which uncommitted fighters will intercept tracks
local escortCommitRange = 60000 -- radius in meters around uncommitted escort units at which targets will be intercepted

local tankerChance = 100 -- chance to launch a tanker mission
local CAPChance = 30 -- chance to launch a CAP mission

local activeAirbases = {} -- active airbases
local flights = {} -- currently active flights
local packages = {} -- currently active packages
local nextPackageID = 1000 -- next package ID

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

local function allowedTargetCategrory(squadron, targetCategory)
	for key, category in pairs(squadron.targetCategories) do
		if category == targetCategory then
			return true
		end
	end
	return false
end

-- create and spawn aircraft group for tasking
-- TODO: Fix helipad spawns
local function launchFlight(airbase, squadron, mission, flightSize, groundStart)
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
	if (squadron.loadouts[missionClass[mission]][mission] ~= nil) then
		loadout = squadron.loadouts[missionClass[mission]][mission]
	else
		if mission == "QRA" and squadron.loadouts[missionClass[mission]].Intercept ~= nil then
			loadout = squadron.loadouts[missionClass[mission]].Intercept -- if QRA loadout doesn't exist use intercept loadout
		elseif mission == "HAVCAP" and squadron.loadouts[missionClass[mission]].Escort ~= nil then
			loadout = squadron.loadouts[missionClass[mission]].Escort
		else
			loadout = squadron.loadouts[missionClass[mission]].General -- if specific mission loadout doesn't exist, use generic A-A
		end
	end
	-- select flight options for mission
	if mission == "Intercept" or mission == "QRA" then
		flightData["task"] = "Intercept"
	end
	if mission == "CAP" then
		flightData["task"] = "CAP"
	end
	if mission == "Escort" or mission == "HAVCAP" then
		flightData["task"] = "Escort"
	end
	if mission == "Tanker" then
		flightData["task"] = "Refueling"
	end
	-- add flight members
	for i=1,flightSize do
		local name
		if mission == "Tanker" and flightSize == 1 then
			name = callsign .. " " .. tostring(flightNumber)
		else
			name = callsign .. " " .. tostring(flightNumber) .. tostring(i)
		end
		units[i] = {
			["name"] = name,
			["type"] = squadron.type,
			["x"] = baseLocation.x,
			["y"] = baseLocation.z - ((i - 1) * 35),
			["alt"] = (baseLocation.y + 100),
			["heading"] = airbase.takeoffHeading,
			["alt_type"] = "BARO",
			["speed"] = 100,
			["skill"] = getSkill(squadron.skill),
			["livery_id"] = squadron.livery,
			["payload"] = loadout,
			["callsign"] = {
				[1] = math.random(9),
				[2] = flightNumber,
				[3] = i,
				["name"] = name
			},
		}
		units[i]["onboard_num"] = tostring(units[i].callsign[1]) .. tostring(units[i].callsign[2]) .. tostring(units[i].callsign[3])
	end
	flightData["units"] = units
	-- force ground start if players are close enough to see
	local waypointType
	local waypointAction
	if groundStart or playerInRange(groundStartRadius, baseLocation.x, baseLocation.z) then
		if Airbase.getByName(airbase.name):getDesc().category == Airbase.Category.HELIPAD then
			waypointType = "TakeOffGroundHot"
			waypointAction = "From Ground Area Hot"
		else
			waypointType = "TakeOffParkingHot"
			waypointAction = "From Parking Area Hot"
		end
	else
		waypointType = "Turning Point"
		waypointAction = "Turning Point"
	end
	-- add route waypoint for airfield launch
	route = {
		points = {
			[1] = {
				["type"] = waypointType,
				["action"] = waypointAction,
				["airdromeId"] = Airbase.getByName(airbase.name):getID(),
				["speed"] = 100,
				["x"] = baseLocation.x,
				["y"] = baseLocation.z,
				["alt"] = (baseLocation.y + 100),
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
	-- check if our flight even exists or isn't on the ground already
	local flightInAir = false
	if flights[flightID]:isExist() ~= false then
		for key, unit in pairs(flights[flightID]:getUnits()) do
			if unit:inAir() == true then
				flightInAir = true
				break
			end
		end
	end
	if flightInAir then
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
							action = "Landing",
							airdromeId = Airbase.getByName(airbases[missionData.airbaseID].name):getID(),
							x = baseLocation.x,
							y = baseLocation.z,
							alt = returnAltitude,
							speed = standardSpeed,
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

local function packageAbort(packageID)
	for key, flight in pairs(packages[packageID].flights) do
		returnToBase(flight)
	end
	packages[packageID] = nil
end

-- control flight to intercept target track
local function controlIntercept(missionData)
	local flightID = missionData.flightID
	local targetID = missionData.targetID
	local flightCategory = typeCategory[airbases[missionData.airbaseID].Squadrons[missionData.squadronID].type]
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
				controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_CONTINUOUS_SEARCH)
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
			-- special F-4 exception, since they apparently can't detect targets to save their life
			for key, unit in pairs(flights[flightID]:getUnits()) do
				if unit:getTypeName() == "F-4E" and targetInSearchRange and tracks[targetID].alt > 3000 then
					targetDetected = true
					env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " target detected by F-4 exception", 0)
				end
				break
			end
			-- if target detected then engage
			if targetDetected then
				env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(targetID) .. " free to engage", 0)
				-- just in case
				if flightCategory == Group.Category.HELICOPTER then
					controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.WEAPON_FREE)
				else
					controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE)
				end
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
			local interceptSpeed = 2000
			if tracks[targetID].alt > 3000 then
				for key, unit in pairs(flights[flightID]:getUnits()) do
					if unit:getPoint().y < 3000 then
						interceptSpeed = 250
					end
					if unit:getPoint().y < (tracks[targetID].alt - 500) then
						interceptSpeed = 350
					end
				end
			end
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
	local flightCategory = typeCategory[airbases[missionData.airbaseID].Squadrons[missionData.squadronID].type]

	if missionData.mission == "Intercept" or missionData.mission == "QRA" then
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
			if flightCategory == Group.Category.HELICOPTER then
				controller:setOption(AI.Option.Air.id.FORMATION, rotaryFormation.FrontRightClose)
			else
				controller:setOption(AI.Option.Air.id.FORMATION, fixedWingFormation.LABSClose)
			end
			controller:setOption(AI.Option.Air.id.ECM_USING, AI.Option.Air.val.ECM_USING.USE_IF_ONLY_LOCK_BY_RADAR)
			controller:setOption(AI.Option.Air.id.PROHIBIT_AG, true)
			if flightCategory == Group.Category.HELICOPTER then
				controller:setOption(AI.Option.Air.id.MISSILE_ATTACK, AI.Option.Air.val.MISSILE_ATTACK.MAX_RANGE) -- TODO: more complex decision on that
			else
				controller:setOption(AI.Option.Air.id.MISSILE_ATTACK, AI.Option.Air.val.MISSILE_ATTACK.RANDOM_RANGE) -- TODO: more complex decision on that
			end
			controller:setOption(AI.Option.Air.id.JETT_TANKS_IF_EMPTY, true)
			-- hand off to intercept controller
			env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(missionData.targetID) .. " handed off to intercept controller", 0)
			controlIntercept(missionData)
		else
			-- if flight is not yet airborne, wait until it is before handing off control
			env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " intercepting " .. tostring(missionData.targetID) .. " still not airborne", 0)
			timer.scheduleFunction(assignMission, missionData, timer.getTime() + 5)
		end
	end

	if missionData.mission == "Tanker" then
		local controller = flights[flightID]:getController()
		-- set up flight options
		controller:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.ALLOW_ABORT_MISSION)

		local tankerAltitude = tankerParameters[airbases[missionData.airbaseID].Squadrons[missionData.squadronID].type].altitude
		local tankerSpeed =  tankerParameters[airbases[missionData.airbaseID].Squadrons[missionData.squadronID].type].speed
		local orbitID = missionData.targetID
		local baseLocation = Airbase.getByName(airbases[missionData.airbaseID].name):getPoint()
		env.info("Blue Air Debug: Tanker flight " .. tostring(flightID) .. " launching", 0)
		env.info("Blue Air Debug: Altitude: " .. tostring(tankerAltitude) .. " Speed: " .. tostring(tankerSpeed), 0)
		env.info("Blue Air Debug: Point 1: " .. tostring(tankerOrbits[orbitID][1].x) .. " " .. tostring(tankerOrbits[orbitID][1].y), 0)
		env.info("Blue Air Debug: Point 2: " .. tostring(tankerOrbits[orbitID][2].x) .. " " .. tostring(tankerOrbits[orbitID][2].y), 0)
		local task = {
			id = "Mission",
			params = {
				airborne = true,
				route = {
					points = {
						[1] = {
							type = "Turning Point",
							action = "Fly Over Point",
							x = tankerOrbits[orbitID][1].x,
							y = tankerOrbits[orbitID][1].y,
							alt = tankerAltitude,
							speed = tankerSpeed,
							task = {
								id = "ComboTask",
								params = {
									tasks = {
										[1] = {
										id = "Tanker",
											params = {
											}
										},
										[2] = {
											id = "Orbit",
											params = {
												pattern = "Race-Track",
												point = {
													x = tankerOrbits[orbitID][1].x,
													y = tankerOrbits[orbitID][1].y
												},
												point2 = {
													x = tankerOrbits[orbitID][2].x,
													y = tankerOrbits[orbitID][2].y
												},
												altitude = tankerAltitude,
												speed = tankerSpeed
											}
										}
									}
								}
							}
						},
						[2] = {
							type = "Land",
							action = "Fly Over Point",
							airdromeId = Airbase.getByName(airbases[missionData.airbaseID].name):getID(),
							x = baseLocation.x,
							y = baseLocation.z,
							alt = tankerAltitude,
							speed = tankerSpeed,
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
	end

	if missionData.mission == "Escort" or missionData.mission == "HAVCAP" then
		local controller = flights[flightID]:getController()
		-- set up flight options
		controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
		controller:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE)
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
		if flightCategory == Group.Category.HELICOPTER then
			controller:setOption(AI.Option.Air.id.FORMATION, rotaryFormation.FrontRightClose)
		else
			controller:setOption(AI.Option.Air.id.FORMATION, fixedWingFormation.LABSClose)
		end
		controller:setOption(AI.Option.Air.id.ECM_USING, AI.Option.Air.val.ECM_USING.USE_IF_ONLY_LOCK_BY_RADAR)
		controller:setOption(AI.Option.Air.id.PROHIBIT_AG, true)
		if flightCategory == Group.Category.HELICOPTER then
			controller:setOption(AI.Option.Air.id.MISSILE_ATTACK, AI.Option.Air.val.MISSILE_ATTACK.MAX_RANGE) -- TODO: more complex decision on that
		else
			controller:setOption(AI.Option.Air.id.MISSILE_ATTACK, AI.Option.Air.val.MISSILE_ATTACK.RANDOM_RANGE) -- TODO: more complex decision on that
		end
		controller:setOption(AI.Option.Air.id.JETT_TANKS_IF_EMPTY, false)

		local targetLocation
		if packages[missionData.packageID].mission == "Tanker" then
			targetLocation = tankerOrbits[packages[missionData.packageID].targetID][1]
		end
		local escortTargetID = missionData.targetID
		local baseLocation = Airbase.getByName(airbases[missionData.airbaseID].name):getPoint()
		env.info("Blue Air Debug: Escort flight " .. tostring(flightID) .. " launching", 0)
		env.info("Blue Air Debug: Escorting flight: " .. tostring(escortTargetID), 0)
		local task = {
			id = "Mission",
			params = {
				airborne = true,
				route = {
					points = {
						[1] = {
							type = "Turning Point",
							action = "Turning Point",
							x = targetLocation.x,
							y = targetLocation.y,
							alt = standardAltitude,
							speed = standardSpeed,
							task = {
								id = "ComboTask",
								params = {
									tasks = {
										[1] = {
											id = "Escort",
											params = {
												groupId = escortTargetID, -- should already be the same as the in-game ID
												engagementDistMax = escortCommitRange,
												pos = {
													["x"] = 0,
													["y"] = 500,
													["z"] = 1000
												},
												targetTypes = {
													[1] = "Planes"
												},
												noTargetTypes = {
													[1] = "Helicopters"
												},
												lastWptIndexFlag = true,
												lastWptIndex = 10
											}
										},
										[2] = {
											id = "Refueling",
											params = {
											}
										}
									}
								}
							}
						},
						[2] = {
							type = "Land",
							action = "Turning Point",
							airdromeId = Airbase.getByName(airbases[missionData.airbaseID].name):getID(),
							x = baseLocation.x,
							y = baseLocation.z,
							alt = standardAltitude,
							speed = standardSpeed,
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
	end
end

-- receive allocated airframes, launch the flight and hand off to aircraft configuration and control
local function launchSortie(missionData)
	-- launch the flight
	-- force ground start for non-intercepts
	local groundStart = true
	if missionData.mission == "Intercept" or missionData.mission == "QRA" then
		groundStart = false
	end
	local flight = launchFlight(airbases[missionData.airbaseID], airbases[missionData.airbaseID].Squadrons[missionData.squadronID], missionData.mission, missionData.flightSize, groundStart)
	if flight ~= nil then
		local flightID = flight:getID()
		flights[flightID] = flight
		-- if handed nil target data, find the main flight in the package and make that the target (for escort purposes)
		local targetID = missionData.targetID
		if targetID == nil then
			for key, packageFlight in pairs(packages[missionData.packageID].flights) do
				if packageFlight.mission == "Tanker" then
					targetID = packageFlight.flightID
				end
			end
		end
		-- hand off control
		local updatedMissionData = {
			["mission"] = missionData.mission,
			["packageID"] = missionData.packageID,
			["airbaseID"] = missionData.airbaseID,
			["squadronID"] = missionData.squadronID,
			["targetID"] = targetID,
			["flightSize"] = missionData.flightSize,
			["flightID"] = flightID
		}
		-- set airfield readiness time for next intercept
		if missionData.mission == "Intercept" or missionData.mission == "QRA" then
			activeAirbases[missionData.airbaseID].readinessTime = timer.getTime() + preparationTime
		end
		-- update package with flight data
		if missionData.packageID ~= nil then
			table.insert(packages[missionData.packageID].flights, updatedMissionData)
		end
		-- the script might crash if we do this right away?
		timer.scheduleFunction(assignMission, updatedMissionData, timer.getTime() + 1)
	else
		-- if our flight didn't launch for whatever reason, try again later
		if missionData.mission == "Intercept" or missionData.mission == "QRA" then
			if tracks[missionData.targetID] ~= nil then
				tracks[missionData.targetID].engaged = false
			end
		end
		-- mark airfield skip so next time we'll try again from a different one
		activeAirbases[missionData.airbaseID].skip = true
		timer.scheduleFunction(resetAirbaseSkip, missionData.airbaseID, timer.getTime() + skipResetTime)
	end
end

-- allocate airframes from squadron to the mission and hand it off for preparation
local function allocateAirframes(mission, airbaseID, squadronID, targetID, packageID)
	-- TODO: Set base flight size by squadron
	local flightSize -- how many airframes we want to launch
	-- determine how many aircraft to launch
	if mission ~= "Tanker" then
		local rand = math.random(10)
		if rand <= 8 then
			flightSize = 2 -- baseline flight of two
		end
		if rand > 8 then
			flightSize = 3
		end
		-- reduce flight size for high priority squadrons
		if airbases[airbaseID].Squadrons[squadronID].highPriority == true or typeCategory[airbases[airbaseID].Squadrons[squadronID].type] == Group.Category.HELICOPTER then
			flightSize = flightSize - 1
		end
	else
		-- only need one tanker
		flightSize = 1
	end
	-- launch flight and hand off to flight preparation
	local missionData = {
		["mission"] = mission,
		["packageID"] = packageID, -- nil for intercepts
		["airbaseID"] = airbaseID,
		["squadronID"] = squadronID,
		["targetID"] = targetID,
		["flightSize"] = flightSize
	}
	launchSortie(missionData)
end

local function assignHAVCAP(packageID)
	local escortSquadrons = {}
	-- determine whether it's regular escort or HAVCAP
	local mission = "Escort"
	if packages[packageID].mission == "Tanker" then
		mission = "HAVCAP"
	end
	for airbaseID, airbaseData in pairs(activeAirbases) do
		-- add up all the squadrons in the airbase and select a random one
		for squadronID, squadron in pairs(airbases[airbaseID].Squadrons) do
			if squadron.missions[mission] == true then
				local squadronData = {
					["airbaseID"] = airbaseID,
					["squadronID"] = squadronID
				}
				table.insert(escortSquadrons, squadronData)
			end
		end
	end
	if getTableSize(escortSquadrons) > 0 then
		local squadronIndex = math.random(getTableSize(escortSquadrons))
		local airbaseID = escortSquadrons[squadronIndex].airbaseID
		local squadronID = escortSquadrons[squadronIndex].squadronID
		
		allocateAirframes(mission, airbaseID, squadronID, nil, packageID)
	end
end

-- main loop for dispatching interceptors
local function interceptATO()
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
						if squadron.missions["Intercept"] == true and allowedTargetCategrory(squadron, tracks[trackID].category) then
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
					-- check if target is close enough for QRA intercept
					local mission
					local baseLocation = Airbase.getByName(airbases[interceptAirbase].name):getPoint()
					if getDistance(tracks[trackID].x, tracks[trackID].y, baseLocation.x, baseLocation.z) < QRARadius then
						mission = "QRA"
					else
						mission = "Intercept"
					end
					allocateAirframes(mission, interceptAirbase, interceptSquadron, trackID, nil)
				end
			end
		end
	end
	timer.scheduleFunction(interceptATO, nil, timer.getTime() + 15)
end

-- loop for assigning non-intercept packages
local function logisticsATO()
	-- refresh HAVCAP or clean up tanker packages
	for packageID, package in pairs(packages) do
		if package.mission == "Tanker" then
			for key, flight in pairs(package.flights) do
				if flight.mission == "Tanker" then
					if flights[flight.flightID]:isExist() == false then
						packageAbort(packageID)
						env.info("Blue Air Debug: Tanker package: " .. tostring(packageID) .. " disbanded", 0)
					else
						local flightAirborne = true
						for key, unit in pairs(flights[flight.flightID]:getUnits()) do
							if unit:inAir() == false then
								flightAirborne = false
							end
						end
						if flightAirborne ~= true then
							packageAbort(packageID)
							env.info("Blue Air Debug: Tanker package: " .. tostring(packageID) .. " disbanded", 0)
						end
					end
				end
				if flight.mission == "HAVCAP" then
					if flights[flight.flightID]:isExist() == false then
						timer.scheduleFunction(assignHAVCAP, packageID, timer.getTime() + 60) -- need to delay it otherwise we go into infinite loop
						env.info("Blue Air Debug: Refreshing HAVCAP for package " .. tostring(packageID), 0)
					else
						local flightAirborne = true
						for key, unit in pairs(flights[flight.flightID]:getUnits()) do
							if unit:inAir() == false then
								flightAirborne = false
							end
						end
						if flightAirborne ~= true then
							timer.scheduleFunction(assignHAVCAP, packageID, timer.getTime() + 60) -- need to delay it otherwise we go into infinite loop
							env.info("Blue Air Debug: Refreshing HAVCAP for package " .. tostring(packageID), 0)
						end
					end
				end
			end
		end
	end

	-- dispatch tanker missions
	if math.random(100) < tankerChance then
		local orbitID
		-- find all unoccupied orbits available and pick one at random
		local openOrbits = {}
		for orbitID, orbit in pairs(tankerOrbits) do
			local assigned = false
			for packageID, package in pairs(packages) do
				if package.mission == "Tanker" and package.targetID == orbitID then
					assigned = true
				end
			end
			if assigned == false then
				table.insert(openOrbits, orbitID)
			end
		end
		if getTableSize(openOrbits) > 0 then
			orbitID = openOrbits[math.random(getTableSize(openOrbits))]
			-- pick random squadron to dispatch
			local tankerSquadrons = {}
			for airbaseID, airbaseData in pairs(activeAirbases) do
				-- add up all the squadrons in the airbase and select a random one
				for squadronID, squadron in pairs(airbases[airbaseID].Squadrons) do
					if squadron.missions["Tanker"] == true then
						local squadronData = {
							["airbaseID"] = airbaseID,
							["squadronID"] = squadronID
						}
						table.insert(tankerSquadrons, squadronData)
					end
				end
			end
			if getTableSize(tankerSquadrons) > 0 then
				local squadronIndex = math.random(getTableSize(tankerSquadrons))
				local airbaseID = tankerSquadrons[squadronIndex].airbaseID
				local squadronID = tankerSquadrons[squadronIndex].squadronID
				
				-- assemble the package
				local packageID = nextPackageID
				nextPackageID = nextPackageID + 1
				packages[packageID] = {
					["mission"] = "Tanker",
					["targetID"] = orbitID,
					["flights"] = {}
				}
				-- launch tanker
				allocateAirframes("Tanker", airbaseID, squadronID, orbitID, packageID)
				-- assign HAVCAP
				timer.scheduleFunction(assignHAVCAP, packageID, timer.getTime() + 60)
			end
		end
	end

	timer.scheduleFunction(logisticsATO, nil, timer.getTime() + math.random(minPackageTime, maxPackageTime))
end
-- math.random(minPackageTime, maxPackageTime)
initializeAirbases()
interceptATO()
timer.scheduleFunction(logisticsATO, nil, timer.getTime() + math.random(minPackageTime))

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