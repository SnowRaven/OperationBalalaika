-- OKB-17 air tasking and interception system by Arctic Fox --

local handler = {} -- DCS event handler

---------------------------------------------------------------------------------------------------------------------------
-- enum and stuff
-- DCS country IDs
local country = {
	["USA"] = 2,
	["Iran"] = 34,
	["Iraq"] = 35,
	["Pakistan"] = 39,
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
	["Pure"] = 1,
	["Lead"] = 2,
	["LeadLow"] = 3,
	["LeadHigh"] = 4,
	["Beam"] = 5,
	["Stern"] = 6
}
-- basic category for each mission type
local missionClass = {
	["Intercept"] = "AA",
	["QRA"] = "AA",
	["CAP"] = "AA",
	["AMBUSHCAP"] = "AA",
	["Escort"] = "AA",
	["HAVCAP"] = "AA",
	["Tanker"] = "Logistics"
}
-- names for unit types
local typeAlias = {
	["F-14A-135-GR"] = "Tomcat",
	["F-14B"] = "Tomcat",
	["F-4E"] = "Phantom",
	["F-5E-3"] = "Tiger",
	["F-16C_50"] = "Falcon",
	["AH-1W"] = "Cobra",
	["KC-135"] = "KC-707",
	["KC135MPRS"] = "KC-707",
	["Su-27"] = "Flanker",
	["MiG-31"] = "Foxhound",
	["IL-78M"] = "Midas"
}
-- DCS categories for unit types
local typeCategory = {
	["F-14A-135-GR"] = Group.Category.AIRPLANE,
	["F-14B"] = Group.Category.AIRPLANE,
	["F-4E"] = Group.Category.AIRPLANE,
	["F-5E-3"] = Group.Category.AIRPLANE,
	["F-16C_50"] = Group.Category.AIRPLANE,
	["KC-135"] = Group.Category.AIRPLANE,
	["KC135MPRS"] = Group.Category.AIRPLANE,
	["AH-1W"] = Group.Category.HELICOPTER,
	["Su-27"] = Group.Category.AIRPLANE,
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
local maxAltitude = 9144
local standardAltitude = 7620
local returnAltitude = 9144
local ambushAltitude = 183
local standardSpeed = 250
local ambushSpeed = 200

-- altitude and speeds used for tanker operations
local tankerParameters = {
	["KC-135"] = {
		altitude = 6096.1,
		speed = 211.1
	},
	["KC135MPRS"] = {
		altitude = 6096.1,
		speed = 211.1
	}
}

-- table defining preferred tactics for each aircraft type
local preferredTactic = {
	["F-5E-3"] = interceptTactic.Stern,
	["F-4E"] = interceptTactic.Beam,
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
	-- Kerman area
	[1] = {
		["x"] = 565076,
		["y"] = 260427,
		["radius"] = 300000
	},
	-- Pakistani Air Force operational area
	[2] = {
		["x"] = 4605,
		["y"] = 248026,
		["radius"] = 150000
	},
	-- USN operational area
	[3] = {
		["x"] = -226960,
		["y"] = 67881,
		["radius"] = 250000
	}
}

local CAPZones = {
	[1] = {
		["origin"] = {
			["x"] = 330907,
			["y"] = -74878
		},
		["radius"] = 80000,
		["reference"] = {
			["x"] = 454234,
			["y"] = 71048
		}
	},
	[2] = {
		["origin"] = {
			["x"] = 195156,
			["y"] = 60845
		},
		["radius"] = 80000,
		["reference"] = {
			["x"] = 282753,
			["y"] = 141520
		}
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
							["fuel"] = 4864,
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
							["fuel"] = 4864,
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
				["interceptRadius"] = 60000, -- radius of action around the airbase for interceptors from this squadron in meters
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
							["fuel"] = 4864,
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
							["fuel"] = 4864,
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
					--["CAP"] = true
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
								},
								[4] =
								{
									["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
								},
							},
							["fuel"] = 1250,
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
					--["CAP"] = true
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
								},
								[4] =
								{
									["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
								},
							},
							["fuel"] = 1250,
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
-- get 2D magnitude from a velocity vector
local function getVelocityMagnitude(vector)
	return math.sqrt((vector.x^2) + (vector.z^2))
end

-- get distance between two points using the power of Pythagoras
local function getDistance(x1, y1, x2, y2)
	return math.sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)))
end

-- get a point on a line between two points at a certain distance from the first point
local function getPointOnLine(a, b, distance)
	local distanceRatio = getDistance(a.x, a.y, b.x, b.y) / distance
	local x = a.x + ((b.x - a.x) / distanceRatio)
	local y = a.y + ((b.y - a.y) / distanceRatio)
	local point = {
		["x"] = x,
		["y"] = y
	}
	return point
end

-- get two points perpendicular to a line at a certain distance from point a
local function getPerpendicularPoints(a, b, distance)
	local angle = math.atan2(b.y - a.y, b.x - a.x)
	local p1 = {
		["x"] = a.x + (math.cos(angle + (math.pi / 2)) * distance),
		["y"] = a.y + (math.sin(angle + (math.pi / 2)) * distance)
	}
	local p2 = {
		["x"] = a.x + (math.cos(angle - (math.pi / 2)) * distance),
		["y"] = a.y + (math.sin(angle - (math.pi / 2)) * distance)
	}
	return {p1, p2}
end


-- get two points a certain distance abeam an object with a given heading
local function getBeamPoints(position, heading, distance)
	local p1 = {
		["x"] = position.x + (math.cos(heading + (math.pi / 2)) * distance),
		["y"] = position.y + (math.sin(heading + (math.pi / 2)) * distance)
	}
	local p2 = {
		["x"] = position.x + (math.cos(heading - (math.pi / 2)) * distance),
		["y"] = position.y + (math.sin(heading - (math.pi / 2)) * distance)
	}
	return {p1, p2}
end

-- get a point directly behind an object at a given distance
local function getSternPoint(position, heading, distance)
	local point = {
		["x"] = position.x + (math.cos(-heading) * distance),
		["y"] = position.y + (math.sin(-heading) * distance)
	}
	return point
end

-- get absolute angle from a position and heading to a point
local function getAbsoluteAngle(position, point)
	local angle = math.atan2(point.y - position.y, point.x - position.x)
	return angle
end

-- get aspect angle from a position and heading to a point
local function getAspectAngle(heading, position, point)
	local angle = math.atan2(point.y - position.y, point.x - position.x)
	return (angle - heading)
end

-- get a random point inside a radius from a given point
local function getRandomPoint(origin, radius)
	local distance = math.sqrt(math.random()) * radius
	local angle = math.random() * (2 * math.pi)
	local x = origin.x + (math.sin(angle) * distance)
	local y = origin.y + (math.cos(angle) * distance)
	local point = {
		["x"] = x,
		["y"] = y
	}
	return point
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
	if baseline == "Average" then
		if adjustment > 6 then
			return "Good"
		end
		return "Average"
	elseif baseline == "Good" then
		if adjustment <= 2 then
			return "Average"
		elseif adjustment > 6 then
			return "Good"
		end
		return "Good"
	elseif baseline == "High" then
		if adjustment <= 2 then
			return "Good"
		elseif adjustment > 6 then
			return "Excellent"
		end
		return "High"
	elseif baseline == "Excellent" then
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
local function getAircraftType(flight)
	for key, unit in pairs(flight:getUnits()) do
		if unit:getTypeName() ~= nil then
			return unit:getTypeName()
		end
	end
end

-- get average flight position
local function getFlightPosition(flight)
	local flightElements = 0
	local totalX = 0
	local totalY = 0
	for key, unit in pairs(flight:getUnits()) do
		flightElements = flightElements + 1
		totalX = totalX + unit:getPoint().x
		totalY = totalY + unit:getPoint().z
	end
	local position = {
		["x"] = totalX / flightElements,
		["y"] = totalY / flightElements
	}
	return position
end

-- get average flight distance from point
local function getFlightDistance(flight, x, y)
	local flightElements = 0
	local distanceTotal = 0
	for key, unit in pairs(flight:getUnits()) do
		flightElements = flightElements + 1
		distanceTotal = distanceTotal + getDistance(unit:getPoint().x, unit:getPoint().z, x, y)
	end
	return (distanceTotal / flightElements)
end

-- get distance from closest element in a flight
local function getClosestFlightDistance(flight, x, y)
	local closestDistance
	for key, unit in pairs(flight:getUnits()) do
		local unitDistance = getDistance(unit:getPoint().x, unit:getPoint().z, x, y)
		if closestDistance == nil or unitDistance < closestDistance then
			closestDistance = unitDistance
		end
	end
	return closestDistance
end

-- get closest distance from any flight in package
local function getPackageDistance(package, x, y)
	local closestDistance
	for key, flight in pairs(package.flights) do
		if flight.flightGroup:isExist() ~= false then
			local flightDistance = getClosestFlightDistance(flight.flightGroup, x, y)
			if closestDistance == nil or flightDistance < closestDistance then
				closestDistance = flightDistance
			end
		end
	end
	return closestDistance
end

-- get speed of the fastest member of a flight
local function getFlightSpeed(flight)
	local highestSpeed
	for key, unit in pairs(flight:getUnits()) do
		local unitSpeed = getVelocityMagnitude(unit:getVelocity())
		if highestSpeed == nil or unitSpeed < highestSpeed then
			highestSpeed = unitSpeed
		end
	end
	return highestSpeed
end

-- get altitude of lowest element in flight
local function getLowestFlightAltitude(flight)
	local lowestAltitude = nil
	for key, unit in pairs(flight:getUnits()) do
		if lowestAltitude == nil or unit:getPoint().y < lowestAltitude then
			lowestAltitude = unit:getPoint().y
		end
	end
	return lowestAltitude
end

-- get lowest fuel state in flight
local function getFuelState(flight)
	local fuelState
	for key, unit in pairs(flight:getUnits()) do
		if fuelState == nil or unit:getFuel() < fuelState then
			fuelState = unit:getFuel()
		end
	end
	return fuelState
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
local trackTimeout = 60 -- amount of time before tracks are timed out
local trackCorrelationDistance = 8000 -- maximum distance in meters between which a target will correlate with a track
local trackCorrelationAltitude = 5000 -- maximum altitude difference in meters between which a target will correlate with a track

local primaryTrackers = {} -- list of primary tracking units: EWRs and search radars
local secondaryTrackers = {} -- list of secondary tracking units: infantry and local air defence
local tracks = {} -- list of airborne target tracks created by the AD system
local nextTrackNumber = 0 -- iterator to prevent track IDs from repeating

local primaryTrackerAttributes = {
	["EWR"] = true,
	["SAM SR"] = true,
	["Aircraft Carriers"] = true,
	["Cruisers"] = true,
	["Destroyers"] = true,
	["Frigates"] = true,
	["AWACS"] = true
}

local secondaryTrackerAttributes = {
	["Infantry"] = true,
	["Air Defence"] = true,
	["Armed ships"] = true
}

-- evaluate whether a unit has the necessary properties then add it to the list of trackers
local function addTracker(unit)
	-- don't add units that are in ADZ exclusion zones
	for zoneKey, zone in pairs(ADZExclusion) do
		if getDistance(unit:getPoint().x, unit:getPoint().z, zone.x, zone.y) < zone.radius then
			env.info("Blue Air Debug: Unit " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " excluded from ADZ", 0)
			return
		end
	end
	-- check if unit can be a primary tracker
	local primaryTrackerAttribute = false
	for attribute, value in pairs(primaryTrackerAttributes) do
		if unit:hasAttribute(attribute) then
			primaryTrackerAttribute = true
			break
		end
	end
	if primaryTrackerAttribute then
		primaryTrackers[unit:getID()] = unit
		env.info("Blue Air Debug: Added " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " to primary trackers", 0)
	else
		-- if not, check if unit can be a secondary tracker
		local secondaryTrackerAttribute = false
		for attribute, value in pairs(secondaryTrackerAttributes) do
			if unit:hasAttribute(attribute) then
				primaryTrackerAttribute = true
				break
			end
		end
		if secondaryTrackerAttribute then
			secondaryTrackers[unit:getID()] = unit
			env.info("Blue Air Debug: Added " .. " " .. unit:getTypeName() .. " " .. tostring(unit:getID()) .. " to secondary trackers", 0)
		end
	end
end

-- build AD tracker lists at mission start
local function initializeTrackers()
	for key, group in pairs(coalition.getGroups(side)) do
		for key, unit in pairs(group:getUnits()) do
			addTracker(unit)
		end
	end
end

-- update track with new data
local function updateTrack(trackID, target)
	if tracks[trackID].lastUpdate == nil or timer.getTime() > tracks[trackID].lastUpdate + 1 then
		if tracks[trackID].x == nil or tracks[trackID].y == nil then
			-- if a track was just created we don't know velocity and heading
			tracks[trackID].velocity = 0
			tracks[trackID].heading = 0
		else
			-- calculate track velocity based on previous position data
			local distance = getDistance(tracks[trackID].x, tracks[trackID].y, target.object:getPoint().x, target.object:getPoint().z)
			tracks[trackID].velocity = distance / (timer.getTime() - tracks[trackID].lastUpdate)
			tracks[trackID].heading = math.atan2(target.object:getPoint().z - tracks[trackID].y, target.object:getPoint().x - tracks[trackID].x)
			env.info("Blue Air Debug: Track ID " .. tostring(trackID) .. " heading: " .. tracks[trackID].heading)
			env.info("Blue Air Debug: Track ID " .. tostring(trackID) .. " velocity: " .. tracks[trackID].velocity .. "m/s")
		end
	end
	tracks[trackID].x = target.object:getPoint().x
	tracks[trackID].y = target.object:getPoint().z
	tracks[trackID].alt = target.object:getPoint().y
	if highThreatType[target.object:getTypeName()] == true then
		tracks[trackID].highThreat = true
	end
	tracks[trackID].lastUpdate = timer.getTime()
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
local function correlateTrack(trackID, target)
	if tracks[trackID].category ~= target.object:getDesc().category then
		return false
	end
	local distance = getDistance(tracks[trackID].x, tracks[trackID].y, target.object:getPoint().x, target.object:getPoint().z)
	if distance < trackCorrelationDistance then
		if math.abs(target.object:getPoint().y - tracks[trackID].alt) < trackCorrelationAltitude then
			return true
		end
	end
	local targetPoint = {
		["x"] = target.object:getPoint().x,
		["y"] = target.object:getPoint().z
	}
	if math.abs(getAspectAngle(tracks[trackID].heading, tracks[trackID], targetPoint)) < 0.785398 then
		local trackMotionPotential = (tracks[trackID].velocity * (timer.getTime() - tracks[trackID].lastUpdate)) * 1.5
		if distance < trackMotionPotential and math.abs(target.object:getPoint().y - tracks[trackID].alt) < trackCorrelationAltitude then
			return true
		end
	end
	return false
end

-- TODO: Track weapons?
local function detectTargets()
	-- go through list of detected targets by primary tracking units and create or update existing tracks
	for key, tracker in pairs(primaryTrackers) do
		-- check if our tracker still exists
		if (tracker:isExist()) then
			-- get all targets currently detected by this tracker
			local targets = tracker:getController():getDetectedTargets(Controller.Detection.RADAR)
			for key, target in pairs(targets) do
				if (target.object ~= nil) and (target.object:getCategory() == Object.Category.UNIT) and (target.object:getCoalition() ~= side) then
					local targetCorrelated = false
					-- check if target can be correlated to any existing tracks
					for key, track in pairs(tracks) do
						if correlateTrack(key, target) then
							updateTrack(key, target)
							targetCorrelated = true
						end
					end
					-- if target can't be correlated to any track, create a new track
					if targetCorrelated == false then
						createTrack(target)
					end
				end
			end
		else
			-- if tracker doesn't exist then remove it from the list
			primaryTrackers[key] = nil
			env.info("Blue Air Debug: Removed " .. " " .. tostring(key) .. " from primary trackers", 0)
		end
	end
	-- same for secondary trackers
	for key, tracker in pairs(secondaryTrackers) do
		-- check if our tracker still exists
		if (tracker:isExist()) then
			-- get all targets currently detected by this tracker
			local targets = tracker:getController():getDetectedTargets(Controller.Detection.RADAR, Controller.Detection.VISUAL, Controller.Detection.OPTIC, Controller.Detection.IRST)
			for key, target in pairs(targets) do
				if (target.object ~= nil) and (target.object:getCategory() == Object.Category.UNIT) and (target.object:getCoalition() ~= side) then
					local targetCorrelated = false
					-- check if target can be correlated to any existing tracks
					for key, track in pairs(tracks) do
						if correlateTrack(key, target) then
							updateTrack(key, target)
							targetCorrelated = true
						end
					end
					-- if target can't be correlated to any track, create a new track
					if targetCorrelated == false then
						createTrack(target)
					end
				end
			end
		else
			-- if tracker doesn't exist then remove it from the list
			secondaryTrackers[key] = nil
			env.info("Blue Air Debug: Removed " .. " " .. tostring(key) .. " from primary trackers", 0)
		end
	end

	timer.scheduleFunction(detectTargets, nil, timer.getTime() + 5)
end

-- delete old tracks that have not been updated
local function timeoutTracks()
	for trackID, track in pairs(tracks) do
		if track.lastUpdate < (timer.getTime() - trackTimeout) then
			tracks[trackID] = nil
			env.info("Blue Air Debug: Timed out lost track ID " .. tostring(trackID) .. " after " .. tostring(timer.getTime() - track.lastUpdate) .. " seconds", 0)
		end
	end
	timer.scheduleFunction(timeoutTracks, nil, timer.getTime() + 10)
end

-- get current or future extrapolated track position
local function getTrackPosition(trackID, time)
	local distance
	if time == nil then
		distance = (timer.getTime() - tracks[trackID].lastUpdate) * tracks[trackID].velocity
	else
		distance = (timer.getTime() - tracks[trackID].lastUpdate + time) * tracks[trackID].velocity
	end
	local position = {
		["x"] = tracks[trackID].x + (math.cos(tracks[trackID].heading) * distance),
		["y"] = tracks[trackID].y + (math.sin(tracks[trackID].heading) * distance)
	}
	return position
end

-- returns the position for a lead intercept vector
local function getInterceptVector(trackID, interceptorGroup)
	local interceptPoint
	local interceptorPosition = getFlightPosition(interceptorGroup)
	local distance = getDistance(interceptorPosition.x, interceptorPosition.y, tracks[trackID].x, tracks[trackID].y)
	local angle = getAbsoluteAngle(tracks[trackID], interceptorPosition)
	local relativeVelocityVector = {
		["x"] = tracks[trackID].velocity * math.cos(angle),
		["z"] = tracks[trackID].velocity * math.sin(angle) -- actually Y but this is easier
	}
	local relativeVelocity = getVelocityMagnitude(relativeVelocityVector) + getFlightSpeed(interceptorGroup)
	-- iterate to find a good approximation of the intercept point
	local time
	for i = 1, 2 do
		time = distance / relativeVelocity
		interceptPoint = getTrackPosition(trackID, time)
		distance = getDistance(interceptorPosition.x, interceptorPosition.y, interceptPoint.x, interceptPoint.y)
	end
	interceptPoint = getTrackPosition(trackID, time)
	return interceptPoint
end

initializeTrackers()
detectTargets()
timer.scheduleFunction(timeoutTracks, nil, timer.getTime() + 10)

---------------------------------------------------------------------------------------------------------------------------
local groundStartRadius = 30000 -- radius around an airfield where if a player is present, a flight will ground instead of air start
local skipResetTime = 60 -- seconds between a failed launch until airfield will be used again
local takeoffCleanupTime = 1800 -- seconds after a flight is spawned when it will be cleaned up if not in the air
local landingCleanupTime = 1200 -- seconds after a flight has landed when it will be cleaned up
local minPackageTime = 3600 -- minimum number of seconds before the package ATO reactivates
local maxPackageTime = 7200 -- maximum number of seconds before the package ATO reactivates
local preparationTime = 1800 -- time in seconds it takes to prepare the next interceptors from an airbase
local tankerChance = 20 -- chance to launch a tanker mission
local CAPChance = 80 -- chance to launch a CAP mission
local AMBUSHChance = 60 -- chance for a CAP tasking to be an AMBUSHCAP

local QRARadius = 60000 -- radius in meters for emergency scramble
local CAPTrackLength = 30000 -- length of CAP racetracks in meters
local commitRange = 180000 -- radius in meters around which uncommitted fighters will intercept tracks
local escortCommitRange = 60000 -- radius in meters around uncommitted escort units at which targets will be intercepted
local ambushCommitRange = 90000 -- radius in meters around uncommitted escort units at which targets will be intercepted
local emergencyCommitRange = 30000 -- radius in meters around a flight to emergency intercept a track regardless of whether it's targeted by others
local bingoLevel = 0.25 -- fuel level (in fraction from full internal) for a flight to RTB

local nextPackageID = 1000 -- next package ID
local packages = {} -- currently active packages
local activeAirbases = {} -- active airbases
local cleanupList = {} -- list of flights to be cleaned up if failed to take off or landed

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
	if squadron.targetCategories ~= nil then
		for key, category in pairs(squadron.targetCategories) do
			if category == targetCategory then
				return true
			end
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
	local flightName = callsign .. " " .. tostring(flightNumber)
	-- need to check if our callsign is in use so we don't delete another flight
	while Group.getByName(flightName) ~= nil and Group.getByName(flightName):isExist() == true do
		flightNumber = flightNumber + 1
		flightName = callsign .. " " .. tostring(flightNumber)
	end
	flightData = {
		["name"] = flightName
	}
	-- see if mission specific loadout option exists and, if so, select it
	if (squadron.loadouts[missionClass[mission]][mission] ~= nil) then
		loadout = squadron.loadouts[missionClass[mission]][mission]
	else
		if mission == "QRA" and squadron.loadouts[missionClass[mission]].Intercept ~= nil then
			loadout = squadron.loadouts[missionClass[mission]]
				.Intercept -- if QRA loadout doesn't exist use intercept loadout
		elseif mission == "HAVCAP" and squadron.loadouts[missionClass[mission]].Escort ~= nil then
			loadout = squadron.loadouts[missionClass[mission]].Escort
		elseif mission == "AMBUSHCAP" and squadron.loadouts[missionClass[mission]].CAP ~= nil then
			loadout = squadron.loadouts[missionClass[mission]].CAP
		else
			loadout = squadron.loadouts[missionClass[mission]]
				.General -- if specific mission loadout doesn't exist, use generic A-A
		end
	end
	-- select flight options for mission
	if mission == "Intercept" or mission == "QRA" then
		flightData["task"] = "Intercept"
	end
	if mission == "CAP" or mission == "AMBUSHCAP" then
		flightData["task"] = "CAP"
	end
	if mission == "Escort" or mission == "HAVCAP" then
		flightData["task"] = "Escort"
	end
	if mission == "Tanker" then
		flightData["task"] = "Refueling"
	end
	-- add flight members
	for i = 1, flightSize do
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
		units[i]["onboard_num"] = tostring(units[i].callsign[1]) ..
			tostring(units[i].callsign[2]) .. tostring(units[i].callsign[3])
	end
	flightData["units"] = units
	-- force ground start if players are close enough to see
	local waypointType
	local waypointAction
	local airStart = true
	if groundStart or playerInRange(groundStartRadius, baseLocation.x, baseLocation.z) then
		if Airbase.getByName(airbase.name):getDesc().category == Airbase.Category.HELIPAD then
			waypointType = "TakeOffGroundHot"
			waypointAction = "From Ground Area Hot"
		else
			waypointType = "TakeOffParkingHot"
			waypointAction = "From Parking Area Hot"
		end
		airStart = false
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
	local group = coalition.addGroup(squadron.country, typeCategory[squadron.type], flightData)
	-- if doing a ground start, add the group to the takeoff list
	if airStart ~= true and group:isExist() then
		local data = {
			["flightGroup"] = group,
			["cleanupTime"] = timer.getTime() + takeoffCleanupTime
		}
		cleanupList[group:getID()] = data
	end
	return group
end

-- send flight home
local function returnToBase(flightData)
	local flightGroup = flightData.flightGroup
	local controller = flightGroup:getController()

	-- activate radar in case we get jumped and set return fire
	controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
	controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
	local baseLocation = {
		["x"] = Airbase.getByName(airbases[flightData.airbaseID].name):getPoint().x,
		["y"] = Airbase.getByName(airbases[flightData.airbaseID].name):getPoint().z
	}
	local descentPoint = getPointOnLine(baseLocation, getFlightPosition(flightGroup), 40000)
	local task = {
		id = 'Mission',
		params = {
			airborne = true,
			route = {
				points = {
					[1] = {
						type = "Turning Point",
						action = "Fly Over Point",
						x = descentPoint.x,
						y = descentPoint.y,
						alt = returnAltitude,
						speed = standardSpeed,
						task = {
							id = "ComboTask",
							params = {
								tasks = {
								}
							}
						}
					},
					[2] = {
						type = "Land",
						action = "Landing",
						airdromeId = Airbase.getByName(airbases[flightData.airbaseID].name):getID(),
						x = baseLocation.x,
						y = baseLocation.y,
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
end

-- prepare flight to intercept
local function assignInterceptTask(flightData)
	local flightGroup = flightData.flightGroup
	local flightCategory = typeCategory[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type]
	local controller = flightGroup:getController()

	-- set up flight options according to intercept doctrine
	controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
	controller:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE)
	if radarRange[getAircraftType(flightGroup)] ~= nil then
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.NEVER)
	else
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
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
	controller:setOption(AI.Option.Air.id.RTB_ON_BINGO, false)
end

-- prepare tanker flight
local function assignTankerTask(flightData)
	local flightGroup = flightData.flightGroup
	local controller = flightGroup:getController()

	-- set up flight options
	controller:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.ALLOW_ABORT_MISSION)
	controller:setOption(AI.Option.Air.id.RTB_ON_BINGO, false)
	local tankerAltitude = tankerParameters[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type]
		.altitude
	local tankerSpeed = tankerParameters[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type].speed
	local baseLocation = Airbase.getByName(airbases[flightData.airbaseID].name):getPoint()
	local task = {
		id = "Mission",
		params = {
			airborne = true,
			route = {
				points = {
					[1] = {
						type = "Turning Point",
						action = "Fly Over Point",
						x = tankerOrbits[flightData.tankerOrbit][1].x,
						y = tankerOrbits[flightData.tankerOrbit][1].y,
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
												x = tankerOrbits[flightData.tankerOrbit][1].x,
												y = tankerOrbits[flightData.tankerOrbit][1].y
											},
											point2 = {
												x = tankerOrbits[flightData.tankerOrbit][2].x,
												y = tankerOrbits[flightData.tankerOrbit][2].y
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
						airdromeId = Airbase.getByName(airbases[flightData.airbaseID].name):getID(),
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

-- prepare escort flight
local function assignEscortTask(flightData)
	local flightGroup = flightData.flightGroup
	local flightCategory = typeCategory[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type]
	local controller = flightGroup:getController()

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
	controller:setOption(AI.Option.Air.id.RTB_ON_BINGO, false)
	local escortLocation = tankerOrbits[flightData.tankerOrbit][1] -- TODO: Push Point
	local baseLocation = Airbase.getByName(airbases[flightData.airbaseID].name):getPoint()
	local task = {
		id = "Mission",
		params = {
			airborne = true,
			route = {
				points = {
					[1] = {
						type = "Turning Point",
						action = "Turning Point",
						x = escortLocation.x,
						y = escortLocation.y,
						alt = standardAltitude,
						speed = standardSpeed,
						task = {
							id = "ComboTask",
							params = {
								tasks = {
								}
							}
						}
					},
					[2] = {
						type = "Turning Point",
						action = "Turning Point",
						x = escortLocation.x,
						y = escortLocation.y,
						alt = standardAltitude,
						speed = standardSpeed,
						task = {
							id = "ComboTask",
							params = {
								tasks = {
									[1] = {
										id = "Escort",
										params = {
											groupId = flightData.escortTarget:getID(),
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
									}
								}
							}
						}
					},
					[3] = {
						type = "Land",
						action = "Turning Point",
						airdromeId = Airbase.getByName(airbases[flightData.airbaseID].name):getID(),
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

-- prepare CAP flight
local function assignCAPTask(flightData)
	local flightGroup = flightData.flightGroup
	local flightCategory = typeCategory[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type]
	local controller = flightGroup:getController()

	-- set up flight options
	controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.RETURN_FIRE)
	controller:setOption(AI.Option.Air.id.REACTION_ON_THREAT, AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE)
	if flightData.mission == "AMBUSHCAP" then
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.NEVER)
	else
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)
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
	controller:setOption(AI.Option.Air.id.JETT_TANKS_IF_EMPTY, false)
	controller:setOption(AI.Option.Air.id.RTB_ON_BINGO, false)
	local baseLocation = Airbase.getByName(airbases[flightData.airbaseID].name):getPoint()
	local altType
	local altitude
	local speed
	if flightData.mission == "CAP" then
		altType = "BARO"
		altitude = standardAltitude
		speed = standardSpeed
	else
		altType = "RADIO"
		altitude = ambushAltitude
		speed = ambushSpeed
	end

	local task = {
		id = "Mission",
		params = {
			airborne = true,
			route = {
				points = {
					[1] = {
						type = "Turning Point",
						action = "Fly Over Point",
						x = flightData.patrolArea[2].x,
						y = flightData.patrolArea[2].y,
						alt_type = altType,
						alt = altitude,
						speed = speed,
						task = {
							id = "ComboTask",
							params = {
								tasks = {
								}
							}
						}
					},
					[2] = {
						type = "Turning Point",
						action = "Fly Over Point",
						x = flightData.patrolArea[1].x,
						y = flightData.patrolArea[1].y,
						alt_type = altType,
						alt = altitude,
						speed = speed,
						task = {
							id = "ComboTask",
							params = {
								tasks = {
									[1] = {
										id = "Orbit",
										params = {
											pattern = "Race-Track",
											point = {
												x = flightData.patrolArea[1].x,
												y = flightData.patrolArea[1].y
											},
											point2 = {
												x = flightData.patrolArea[2].x,
												y = flightData.patrolArea[2].y
											},
											altitude = altitude,
											speed = speed
										}
									}
								}
							}
						}
					},
					[3] = {
						type = "Land",
						action = "Fly Over Point",
						airdromeId = Airbase.getByName(airbases[flightData.airbaseID].name):getID(),
						x = baseLocation.x,
						y = baseLocation.z,
						alt_type = "BARO",
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
end


-- prepare flight according to mission parameters then hand off to the appropriate control function
local function assignMission(missionData)
	-- assign target to flight and hand off to intercept controller
	packages[missionData.packageID].flights[missionData.flightID].interceptTarget = packages[missionData.packageID].interceptTarget
	packages[missionData.packageID].flights[missionData.flightID].patrolArea = packages[missionData.packageID].patrolArea
	packages[missionData.packageID].flights[missionData.flightID].tankerOrbit = packages[missionData.packageID].tankerOrbit
	if packages[missionData.packageID].flights[missionData.flightID].mission == "Escort" or packages[missionData.packageID].flights[missionData.flightID].mission == "HAVCAP" then
		for flightKey, flightData in pairs(packages[missionData.packageID].flights) do
			if flightData.mission == "Tanker" then
				packages[missionData.packageID].flights[missionData.flightID].escortTarget = flightData.flightGroup
				break
			end
		end
	end
	local flightData = packages[missionData.packageID].flights[missionData.flightID]

	if flightData.mission == "Intercept" or flightData.mission == "QRA" then
		assignInterceptTask(flightData)
		if flightData.mission == "QRA" then
			env.info("Blue Air Debug: QRA flight " .. tostring(missionData.flightID) .. " assigned", 0)
		else
			env.info("Blue Air Debug: Intercept flight " .. tostring(missionData.flightID) .. " assigned", 0)
		end
		env.info("Blue Air Debug: Target track: " .. tostring(flightData.interceptTarget), 0)
		return
	end

	if flightData.mission == "Tanker" then
		assignTankerTask(flightData)
		env.info("Blue Air Debug: Tanker flight " .. tostring(missionData.flightID) .. " assigned", 0)
		env.info(
			"Blue Air Debug: Point 1: " ..
			tostring(tankerOrbits[flightData.tankerOrbit][1].x) ..
			" " .. tostring(tankerOrbits[flightData.tankerOrbit][1].y), 0)
		env.info(
			"Blue Air Debug: Point 2: " ..
			tostring(tankerOrbits[flightData.tankerOrbit][2].x) ..
			" " .. tostring(tankerOrbits[flightData.tankerOrbit][2].y), 0)
		return
	end

	if flightData.mission == "Escort" or flightData.mission == "HAVCAP" then
		assignEscortTask(flightData)
		env.info("Blue Air Debug: Escort flight " .. tostring(missionData.flightID) .. " assigned", 0)
		env.info("Blue Air Debug: Escorting flight: " .. tostring(flightData.escortTarget), 0)
		return
	end

	if flightData.mission == "CAP" or flightData.mission == "AMBUSHCAP" then
		assignCAPTask(flightData)
		if flightData.mission == "AMBUSHCAP" then
			env.info("Blue Air Debug: AMBUSHCAP flight " .. tostring(missionData.flightID) .. " assigned", 0)
		else
			env.info("Blue Air Debug: CAP flight " .. tostring(missionData.flightID) .. " assigned", 0)
		end
		env.info(
			"Blue Air Debug: CAP point 1: " ..
			tostring(flightData.patrolArea[1].x) .. " " .. tostring(flightData.patrolArea[1].y), 0)
		env.info(
			"Blue Air Debug: CAP point 2: " ..
			tostring(flightData.patrolArea[2].x) .. " " .. tostring(flightData.patrolArea[2].y), 0)
		return
	end

	if flightData.mission == "RTB" then
		returnToBase(flightData)
		return
	end
end

-- receive allocated airframes, launch the flight and hand off to aircraft configuration and control
local function launchSortie(mission, airbaseID, squadronID, packageID)
	-- TODO: Set base flight size by squadron
	local flightSize -- how many airframes we want to launch
	-- determine how many aircraft to launch
	if mission ~= "Tanker" then
		local rand = math.random(10)
		if rand <= 9 then
			flightSize = 2 -- baseline flight of two
		end
		if rand > 9 then
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
	-- launch the flight
	-- force ground start for non-intercepts
	local groundStart = true
	if mission == "Intercept" or mission == "QRA" then
		groundStart = false
	end
	local flight = launchFlight(airbases[airbaseID], airbases[airbaseID].Squadrons[squadronID], mission, flightSize, groundStart)
	if flight ~= nil then
		local flightID = flight:getID()
		-- assemble flight data
		local flightData = {
			["flightGroup"] = flight,
			["mission"] = mission,
			["airbaseID"] = airbaseID,
			["squadronID"] = squadronID,
		}
		-- update package with flight data
		packages[packageID].flights[flightID] = flightData
		-- set airfield readiness time for next intercept
		if mission == "Intercept" or mission == "QRA" then
			activeAirbases[airbaseID].readinessTime = timer.getTime() + preparationTime
		end
		-- hand off to mission assignment and control
		local missionData = {
			["packageID"] = packageID,
			["flightID"] = flightID
		}
		timer.scheduleFunction(assignMission, missionData, timer.getTime() + 1) -- the script might crash if we do this right away?
	else
		-- if our flight didn't launch for whatever reason, mark airfield skip so next time we'll try again from a different one
		activeAirbases[airbaseID].skip = true
		timer.scheduleFunction(resetAirbaseSkip, airbaseID, timer.getTime() + skipResetTime)
	end
end

-- launch escort flight
local function launchEscort(packageID)
	-- check if our package has been disbanded already
	if packages[packageID] == nil then
		return
	end
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

		launchSortie(mission, airbaseID, squadronID, packageID)
	end
end

-- launch interceptor flight
local function launchIntercept(trackID)
	local trackPosition = getTrackPosition(trackID)
	-- sort airbases by distance to target
	local availableAirbases = {}
	for airbaseID, airbase in pairs(activeAirbases) do
		if airbase.skip ~= true and timer.getTime() > airbase.readinessTime then
			local baseLocation = Airbase.getByName(airbases[airbaseID].name):getPoint()
			local airbaseData = {
				["airbaseID"] = airbaseID,
				["range"] = getDistance(trackPosition.x, trackPosition.y, baseLocation.x, baseLocation.z)
			}
			table.insert(availableAirbases, airbaseData)
		end
	end
	table.sort(availableAirbases, sortAirbaseByRange)
	-- find an applicable squadron, randomizing from the closest airbases in order
	local airbaseID
	local squadronID
	for airbaseKey, airbaseData in ipairs(availableAirbases) do
		local baseLocation = Airbase.getByName(airbases[airbaseData.airbaseID].name):getPoint()
		local interceptSquadrons = {}
		-- add up all the squadrons in the airbase and select a random one
		for key, squadron in pairs(airbases[airbaseData.airbaseID].Squadrons) do
			if squadron.missions["Intercept"] == true and allowedTargetCategrory(squadron, tracks[trackID].category) then
				if getDistance(trackPosition.x, trackPosition.y, baseLocation.x, baseLocation.z) < squadron.interceptRadius then
					-- use high priority squadrons only for high threat tracks
					if tracks[trackID].highThreat == true then
						table.insert(interceptSquadrons, key)
					else
						if squadron.highPriority ~= true then
							table.insert(interceptSquadrons, key)
						end
					end
				end
			end
		end
		if getTableSize(interceptSquadrons) > 0 then
			airbaseID = airbaseData.airbaseID
			squadronID = interceptSquadrons[math.random(getTableSize(interceptSquadrons))]
			break
		end
	end
	-- if we have any squadrons available, launch the intercept
	if squadronID ~= nil then
		-- check if target is close enough for QRA intercept
		local mission
		local baseLocation = Airbase.getByName(airbases[airbaseID].name):getPoint()
		if getDistance(trackPosition.x, trackPosition.y, baseLocation.x, baseLocation.z) < QRARadius then
			mission = "QRA"
		else
			mission = "Intercept"
		end
		-- assemble the package
		local packageID = nextPackageID
		nextPackageID = nextPackageID + 1
		packages[packageID] = {
			["mission"] = mission,
			["interceptTarget"] = trackID,
			["flights"] = {}
		}
		launchSortie(mission, airbaseID, squadronID, packageID)
	end
end

-- loop for assigning air patrol packages
local function patrolATO()
	-- dispatch CAP missions
	if math.random(100) < CAPChance then
		local mission = "CAP"
		local patrolArea
		-- select CAP type and zone
		local zone = CAPZones[math.random(getTableSize(CAPZones))]
		local patrolCenter = getRandomPoint(zone.origin, zone.radius)
		-- build patrol track points
		-- regular CAP faces the reference point, AMBUSHCAP runs perpendicular
		if math.random(100) > AMBUSHChance then
			local p1 = getPointOnLine(patrolCenter, zone.reference, CAPTrackLength / 2)
			local p2 = getPointOnLine(patrolCenter, zone.reference, -(CAPTrackLength / 2))
			patrolArea = { p1, p2 }
		else
			mission = "AMBUSHCAP"
			patrolArea = getPerpendicularPoints(patrolCenter, zone.reference, CAPTrackLength / 2)
		end
		-- pick random squadron to dispatch
		local CAPSquadrons = {}
		for airbaseID, airbaseData in pairs(activeAirbases) do
			-- add up all the squadrons in the airbase and select a random one
			for squadronID, squadron in pairs(airbases[airbaseID].Squadrons) do
				if squadron.missions["CAP"] == true then
					local squadronData = {
						["airbaseID"] = airbaseID,
						["squadronID"] = squadronID
					}
					table.insert(CAPSquadrons, squadronData)
				end
			end
		end
		if getTableSize(CAPSquadrons) > 0 then
			local squadronIndex = math.random(getTableSize(CAPSquadrons))
			local airbaseID = CAPSquadrons[squadronIndex].airbaseID
			local squadronID = CAPSquadrons[squadronIndex].squadronID
			-- assemble the package
			local packageID = nextPackageID
			nextPackageID = nextPackageID + 1
			packages[packageID] = {
				["mission"] = mission,
				["patrolArea"] = patrolArea,
				["flights"] = {}
			}
			-- launch CAP
			launchSortie(mission, airbaseID, squadronID, packageID)
		end
	end

	timer.scheduleFunction(patrolATO, nil, timer.getTime() + math.random(minPackageTime, maxPackageTime))
end

-- loop for assigning logistics packages
local function logisticsATO()
	-- dispatch tanker missions
	if math.random(100) <= tankerChance then
		local orbitID
		-- find all unoccupied orbits available and pick one at random
		local openOrbits = {}
		for orbitID, orbit in pairs(tankerOrbits) do
			local assigned = false
			for packageID, package in pairs(packages) do
				if package.mission == "Tanker" and package.tankerOrbit == orbitID then
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
					["tankerOrbit"] = orbitID,
					["flights"] = {}
				}
				-- launch tanker
				launchSortie("Tanker", airbaseID, squadronID, packageID)
			end
		end
	end

	timer.scheduleFunction(logisticsATO, nil, timer.getTime() + math.random(minPackageTime, maxPackageTime))
end

-- main loop for dispatching interceptors
local function interceptATO()
	-- find unengaged targets and launch interceptors
	for trackID, track in pairs(tracks) do
		-- check if track is in an ADZ exclusion zone or engaged by other interceptors
		local excluded = false
		local engaged = false
		for zoneKey, zone in pairs(ADZExclusion) do
			if getDistance(track.x, track.y, zone.x, zone.y) < zone.radius then
				excluded = true
			end
		end
		for packageID, package in pairs(packages) do
			for flightID, flightData in pairs(package.flights) do
				if flightData.interceptTarget == trackID then
					engaged = true
				end
			end
		end
		-- find any available escort or CAP flight for intercept before scrambling
		if excluded ~= true then
			for packageID, package in pairs(packages) do
				for flightID, flightData in pairs(package.flights) do
					if flightData.interceptTarget == nil and flightData.flightGroup:isExist() ~= false then
						local flightAirborne = true
						for key, unit in pairs(flightData.flightGroup:getUnits()) do
							if unit:inAir() == false then
								flightAirborne = false
							end
						end
						if flightAirborne and allowedTargetCategrory(airbases[flightData.airbaseID].Squadrons[flightData.squadronID], tracks[trackID].category) then
							local targetRange
							local targetInRange = false
							if flightData.mission == "Escort" or flightData.mission == "HAVCAP" then
								targetRange = getPackageDistance(package, track.x, track.y)
								if targetRange < escortCommitRange then
									targetInRange = true
								end
							elseif flightData.mission == "CAP" then
								targetRange = getClosestFlightDistance(flightData.flightGroup, track.x, track.y)
								if targetRange < commitRange then
									targetInRange = true
								end
							elseif flightData.mission == "AMBUSHCAP" then
								targetRange = getClosestFlightDistance(flightData.flightGroup, track.x, track.y)
								if targetRange < ambushCommitRange then
									targetInRange = true
								end
							end
							if engaged ~= true and targetInRange then
								env.info("Blue Air Debug: CAP/Escort flight " .. tostring(flightData.flightGroup:getID()) .. " intercepting " .. tostring(trackID), 0)
								packages[packageID].flights[flightID].interceptTarget = trackID
								assignInterceptTask(packages[packageID].flights[flightID])
								engaged = true
							-- if target is extremely close, intercept regardless of whether it's engaged already
							elseif targetRange ~= nil and targetRange < emergencyCommitRange then
								env.info("Blue Air Debug: Flight " .. tostring(flightData.flightGroup:getID()) .. " emergency intercept " .. tostring(trackID), 0)
								packages[packageID].flights[flightID].interceptTarget = trackID
								assignInterceptTask(packages[packageID].flights[flightID])
								engaged = true
							end
						end
					end
				end
			end
			-- if CAP isn't engaging, launch interceptors
			if engaged ~= true then
				launchIntercept(trackID)
			end
		end
	end
	timer.scheduleFunction(interceptATO, nil, timer.getTime() + 15)
end

-- control flight to intercept target track
local function controlIntercept(flightData)
	local flightGroup = flightData.flightGroup
	local interceptTarget = flightData.interceptTarget
	local flightCategory = typeCategory[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type]
	local controller = flightGroup:getController()
	local trackPosition = getTrackPosition(interceptTarget)
	local distance = getClosestFlightDistance(flightGroup, trackPosition.x, trackPosition.y)
	-- check if we're trying to stern or beam convert or engage
	local convert = false
	if flightData.tactic == interceptTactic.Stern or flightData.tactic == interceptTactic.Beam then
		env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " attempting conversion", 0)
		convert = true
	end
	local engaging = false
	-- check if expected target position is close enough to activate radar
	local targetInSearchRange = false
	if radarRange[getAircraftType(flightGroup)] ~= nil then
		if distance < radarRange[getAircraftType(flightGroup)] then
			targetInSearchRange = true
		end
	else
		targetInSearchRange = true
	end
	if targetInSearchRange and convert ~= true then
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_CONTINUOUS_SEARCH)
		env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " radar active", 0)
	else
		controller:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.NEVER)
		env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " radar off", 0)
	end
	-- check if target is detected by onboard sensors before giving permission to engage
	-- we're doing this to prevent magic datalink intercepts
	local targets = controller:getDetectedTargets(Controller.Detection.RADAR, Controller.Detection.VISUAL, Controller.Detection.OPTIC, Controller.Detection.IRST)
	local targetDetected = false
	local interceptTask
	for key, target in pairs(targets) do
		if target.object ~= nil and target.object:getCategory() == Object.Category.UNIT and target.object:getCoalition() ~= side then
			if correlateTrack(interceptTarget, target) then
				env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " target detected", 0)
				targetDetected = true
				updateTrack(interceptTarget, target)
			end
		end
	end
	-- special F-4 exception, since they apparently can't detect targets to save their life
	-- also special general excepction in case the interceptors are really close but blind because of altitude difference and can't climb
	if convert ~= true then
		if getAircraftType(flightGroup) == "F-4E" and targetInSearchRange and tracks[interceptTarget].alt > 3000 then
			targetDetected = true
			env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " target detected by F-4 exception", 0)
		elseif distance < 5000 and math.abs(tracks[interceptTarget].alt - getLowestFlightAltitude(flightGroup)) > 5000 then
			targetDetected = true
			env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " target detected by altitude exception", 0)
		end
	end
	-- if target detected and we're not beam or stern converting then engage
	if targetDetected and convert ~= true then
		env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " free to engage", 0)
		controller:setOption(AI.Option.Air.id.ROE, AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE)
		interceptTask = {
			id = "ComboTask",
			params = {
				tasks = {
					[1] = {
						id = 'EngageTargetsInZone',
						params = {
							point = {
								trackPosition.x,
								trackPosition.y
							},
							zoneRadius = trackCorrelationDistance,
							targetTypes = { "Air" },
							priority = 0
						}
					}
				}
			}
		}
		engaging = true
	else
		env.info("Blue Air Debug: Flight " .. tostring(flightGroup:getID()) .. " intercepting " .. tostring(interceptTarget) .. " holding engagement", 0)
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
	local path = getInterceptVector(interceptTarget, flightGroup)
	local altType = "BARO"
	path.alt = tracks[interceptTarget].alt
	local aspectAngle = getAspectAngle(tracks[interceptTarget].heading, trackPosition, getFlightPosition(flightGroup))
	-- decide intercept vector based on tactic in use
	if convert then
		-- if we're far enough away lead for beam points directly
		if distance > 60000 or (flightCategory == Group.Category.HELICOPTER and distance > 10000) then
			local beamDistance = 50000
			if flightCategory == Group.Category.HELICOPTER then
				beamDistance = 5000
			end
			local beamPoints = getBeamPoints(path, tracks[interceptTarget].heading, 50000)
			if getFlightDistance(flightGroup, beamPoints[1].x, beamPoints[1].y) < getFlightDistance(flightGroup, beamPoints[2].x, beamPoints[2].y) then
				path = beamPoints[1]
			else
				path = beamPoints[2]
			end
			path.alt = tracks[interceptTarget].alt * 0.6
		-- once we're close to the beam drive to stern conversion if needed
		elseif flightData.tactic == interceptTactic.Stern and math.abs(aspectAngle) > 0.698132 then
			path = getSternPoint(getTrackPosition(interceptTarget), tracks[interceptTarget].heading, 2500)
			path.alt = tracks[interceptTarget].alt * 0.6
		-- if we're close and they're facing us notch to the beam or stern
		else
			local conversionPoints = getPerpendicularPoints(getFlightPosition(flightGroup), path, 30000)
			if getFlightDistance(flightGroup, conversionPoints[1].x, conversionPoints[1].y) < getFlightDistance(flightGroup, conversionPoints[2].x, conversionPoints[2].y) then
				path = conversionPoints[1]
			else
				path = conversionPoints[2]
			end
			path.alt = tracks[interceptTarget].alt * 0.6
		end
	else
		if flightData.tactic == interceptTactic.LeadHigh then
			if flightCategory ~= Group.Category.HELICOPTER and maxAltitude > tracks[interceptTarget].alt then
				path.alt = maxAltitude
			end
		elseif flightData.tactic == interceptTactic.LeadLow then
			path.alt = tracks[interceptTarget].alt * 0.6
		end
	end
	-- if we're far away go high
	if flightData.mission == "AMBUSHCAP" and distance > 20000 then
		path.alt = ambushAltitude
	elseif distance > 120000 then
		if flightCategory ~= Group.Category.HELICOPTER then
			path.alt = maxAltitude
		end
	end
	local flightAltitude = getLowestFlightAltitude(flightGroup)
	if flightAltitude < (path.alt - 2000) and engaging ~= true and getTableSize(flightGroup:getUnits()) > 1 then
		interceptSpeed = 320
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
						x = path.x,
						y = path.y,
						alt = path.alt,
						alt_type = altType,
						speed = interceptSpeed,
						task = interceptTask
					}
				}
			}
		}
	}
	controller:setTask(task)
end

local function flightAbort(packageID, flightID)
	local flightData = packages[packageID].flights[flightID]
	env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " RTB", 0)
	local updatedFlightData = {
		["flightGroup"] = flightData.flightGroup,
		["mission"] = "RTB",
		["airbaseID"] = flightData.airbaseID,
		["squadronID"] = flightData.squadronID
	}
	packages[packageID].flights[flightID] = updatedFlightData
	returnToBase(updatedFlightData)
end

local function packageAbort(packageID)
	packages[packageID].mission = "RTB"
	for flightID, flightData in pairs(packages[packageID].flights) do
		flightAbort(packageID, flightID)
	end
end

-- retask interceptor flight that has no target to a CAP tasking in the nearest CAP zone
local function retaskInterceptors(packageID, flightID)
	local flightGroup = packages[packageID].flights[flightID].flightGroup
	local distance
	local patrolZone
	for key, zone in pairs(CAPZones) do
		if distance == nil or getFlightDistance(flightGroup, zone.origin.x, zone.origin.y) < distance then
			distance = getFlightDistance(flightGroup, zone.origin.x, zone.origin.y)
			patrolZone = zone
		end
	end
	if patrolZone == nil then
		flightAbort(packageID, flightID)
	else
		local patrolCenter = getRandomPoint(patrolZone.origin, patrolZone.radius)
		local p1 = getPointOnLine(patrolCenter, patrolZone.reference, CAPTrackLength / 2)
		local p2 = getPointOnLine(patrolCenter, patrolZone.reference, -(CAPTrackLength / 2))
		local patrolArea = {p1, p2}
		packages[packageID].mission = "CAP"
		packages[packageID].interceptTarget = nil
		packages[packageID].patrolArea = patrolArea
		packages[packageID].flights[flightID].mission = "CAP"
	end
end

-- loop for handling package behaviour
local function handlePackages()
	for packageID, package in pairs(packages) do
		-- clean up the package and add any aircraft on the ground to the cleanup list
		local packageExist = false
		for flightID, flight in pairs(package.flights) do
			if flight.flightGroup:isExist() then
				if cleanupList[flight.flightGroup:getID()] == nil then
					for unitKey, unit in pairs(flight.flightGroup:getUnits()) do
						if unit:inAir() ~= true then
							local data = {
								["flightGroup"] = flight.flightGroup,
								["cleanupTime"] = timer.getTime() + landingCleanupTime
							}
							cleanupList[flight.flightGroup:getID()] = data
						end
					end
				end
				packageExist = true
			end
		end
		if packageExist ~= true then
			packages[packageID] = nil
		-- refresh HAVCAP or clean up tanker packages
		elseif package.mission == "Tanker" then
			local tanker = false
			local HAVCAP = false
			for flightID, flight in pairs(package.flights) do
				-- check if the tanker doesn't exist, if so disband the package
				if flight.mission == "Tanker" then
					if flight.flightGroup:isExist() == false then
						packageAbort(packageID)
						env.info("Blue Air Debug: Tanker package: " .. tostring(packageID) .. " disbanded", 0)
						break
					else
						tanker = true
					end
				end
				-- check if the HAVCAP doesn't exist
				if flight.mission == "HAVCAP" then
					HAVCAP = true
				end
			end
			-- if there's no tanker, abort package
			if tanker ~= true then
				packageAbort(packageID)
				env.info("Blue Air Debug: Tanker package: " .. tostring(packageID) .. " disbanded", 0)
			-- if there's no HAVCAP, launch HAVCAP
			elseif HAVCAP ~= true then
				launchEscort(packageID)
				env.info("Blue Air Debug: Refreshing HAVCAP for package " .. tostring(packageID), 0)
			end
		end
	end
	timer.scheduleFunction(handlePackages, nil, timer.getTime() + 60)
end

-- decide which intercept target to employ
local function decideTactic(flightData)
	local trackPosition = getTrackPosition(flightData.interceptTarget)
	local distance = getFlightDistance(flightData.flightGroup, trackPosition.x, trackPosition.y)
	local aspectAngle = getAspectAngle(tracks[flightData.interceptTarget].heading, tracks[flightData.interceptTarget], getFlightPosition(flightData.flightGroup))
	local flightCategory = typeCategory[airbases[flightData.airbaseID].Squadrons[flightData.squadronID].type]
	local typeTactic = preferredTactic[getAircraftType(flightData.flightGroup)]
	-- if we're really close just focus on engaging
	if distance < 10000 or (flightCategory == Group.Category.HELICOPTER and distance < 5000) then
		return interceptTactic.Lead
	-- decide which tactic to use
	elseif flightData.tactic == nil then
		if typeTactic ~= nil then
			if math.random(10) < 8 then
				return typeTactic
			else
				if typeTactic == interceptTactic.Beam then
					if math.random(10) < 6 then
						return interceptTactic.LeadLow
					else
						return interceptTactic.Stern
					end
				elseif typeTactic == interceptTactic.Stern then
					if math.random(10) < 6 then
						return interceptTactic.LeadLow
					else
						return interceptTactic.Beam
					end
				else
					return interceptTactic[math.random(getTableSize(interceptTactic))]
				end
			end
		else
			return interceptTactic[math.random(getTableSize(interceptTactic))]
		end
		-- stern converting on escort takes too long
		if flightData.mission == "Escort" or flightData.mission == "HAVCAP" then
			if flightData.tactic == interceptTactic.Stern then
				return interceptTactic.Beam
			end
		-- stay low as AMBUSHCAP
		elseif flightData.mission == "AMBUSHCAP" then
			if flightData.tactic == interceptTactic.Lead or flightData.tactic == interceptTactic.LeadHigh then
				return interceptTactic.LeadLow
			end
		end
	elseif flightData.tactic == interceptTactic.Beam and math.abs(aspectAngle) > 0.785398 and distance < 60000 then
		return interceptTactic.Lead
	elseif flightData.tactic == interceptTactic.Stern and math.abs(aspectAngle) > 2.79253 and distance < 60000 then
		return interceptTactic.Lead
	end
	-- continue with what we're doing if nothing changed
	return flightData.tactic
end

-- main loop for controlling flight behaviour
local function controlFlights()
	for packageID, package in pairs(packages) do
		for flightID, flightData in pairs(package.flights) do
			if flightData.flightGroup:isExist() then
				local reset = false
				-- check if we have an intercept target
				if flightData.interceptTarget ~= nil then
					-- check if the target track is valid, if not reset the tasking
					if tracks[flightData.interceptTarget] == nil then
						packages[packageID].flights[flightID].interceptTarget = nil
						packages[packageID].flights[flightID].tactic = nil
						if flightData.mission == "Intercept" or flightData.mission == "QRA" then
							retaskInterceptors(packageID, flightID)
						end
						reset = true
					else
						-- hand off to intercept controller
						packages[packageID].flights[flightID].tactic = decideTactic(flightData)
						env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " tactic: " .. tostring(packages[packageID].flights[flightID].tactic), 0)
						controlIntercept(packages[packageID].flights[flightID])
					end
				end
				if reset then
					env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " resetting", 0)
					local missionData = {
						["packageID"] = packageID,
						["flightID"] = flightID
					}
					assignMission(missionData)
				end
				local fuelState = getFuelState(flightData.flightGroup)
				if fuelState ~= nil then
					if flightData.mission ~= "RTB" and fuelState < bingoLevel then
						env.info("Blue Air Debug: Flight " .. tostring(flightID) .. " fuel state " .. tostring(fuelState), 0)
						flightAbort(packageID, flightID)
					end
				end
			else
				packages[packageID].flights[flightID] = nil
			end
		end
	end
	timer.scheduleFunction(controlFlights, nil, timer.getTime() + 5)
end

local function cleanupFlights()
	-- cleanup flights that have failed to take off or landed
	for flightID, flight in pairs(cleanupList) do
		if timer.getTime() > flight.cleanupTime then
			if flight.flightGroup:isExist() then
				for unitKey, unit in pairs(flight.flightGroup:getUnits()) do
					if unit:inAir() ~= true then
						unit:destroy()
						-- if this is the last unit in a group, destroy it
						if flight.flightGroup:getSize() == 0 then
							flight.flightGroup:destroy()
						end
					end
				end
			end
			cleanupList[flightID] = nil
		end
	end
	timer.scheduleFunction(cleanupFlights, nil, timer.getTime() + 60)
end

initializeAirbases()
timer.scheduleFunction(patrolATO, nil, timer.getTime() + math.random(maxPackageTime))
timer.scheduleFunction(logisticsATO, nil, timer.getTime() + math.random(minPackageTime))
timer.scheduleFunction(interceptATO, nil, timer.getTime() + 5)
timer.scheduleFunction(controlFlights, nil, timer.getTime() + 10)
timer.scheduleFunction(handlePackages, nil, timer.getTime() + 60)
timer.scheduleFunction(cleanupFlights, nil, timer.getTime() + 120)

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