local scriptPath = lfs.writedir() .. "Scripts\\AirCommand"
package.path = package.path .. ";" .. scriptPath .. "\\?.lua;"
---------------------------------------------------------------------------------------------------------------------------
local AirCommand = require("AirCommand")
local defs = require("Defs")

-- parameters
local parameters = {
	["minPackageTime"] = 2400,
	["maxPackageTime"] = 4800,
	["tankerChance"] = 20,
	["AEWChance"] = 20,
	["CAPChance"] = 80,
 	["AMBUSHChance"] = 30
}

-- parameters for aircraft
local aircraftParameters = {
	[Unit.Category.AIRPLANE] = {
		["commitRange"] = 120000,
		["maxAltitude"] = 9144,
		["standardAltitude"] = 7620,
		["returnAltitude"] = 9144,
		["ambushAltitude"] = 183,
		["standardSpeed"] = 250,
		["ambushSpeed"] = 200,
		["F-16C_50"] = {
			["radarRange"] = 60000
		}
	}
}

-- table defining aircraft threat types, any not defined is assumed to be standard
local threatTypes = {
	["Su-27"] = defs.threatType.High,
	["Su-33"] = defs.threatType.High,
	["MiG-29A"] = defs.threatType.High,
	["MiG-29S"] = defs.threatType.High,
	["MiG-23MLD"] = defs.threatType.High,
	["MiG-25PD"] = defs.threatType.High,
	["MiG-25RBT"] = defs.threatType.High,
	["MiG-31"] = defs.threatType.High,
	["Su-24M"] = defs.threatType.High,
	["Su-24MR"] = defs.threatType.High
}

-- support aircraft orbits
local orbits = {
	["SaratogaC2"] = {
		[1] = {
			["x"] = -124250,
			["y"] = 121812
		},
		[2] = {
			["x"] = -124250,
			["y"] = 222052
		},
		["airframes"] = {
			["E-2C"] = true
		}
	}
}


local CAPZones = {
	[1] = {
		["x"] = 21265,
		["y"] = 188788,
		["radius"] = 90000,
		["reference"] = {
			["x"] = 282753,
			["y"] = 141520
		}
	}
}

-- any zones where interception will not be launched even if in range of a squadron
local ADZExclusion = {
	-- West
	[1] = {
		["x"] = 293508,
		["y"] = -238231,
		["radius"] = 400000
	},
	-- North
	[2] = {
		["x"] = 540790,
		["y"] = 256629,
		["radius"] = 400000
	}
}

-- airbases and squadrons
local OOB = {
	["Jask"] = {
		name = "Bandar-e-Jask", -- DCS name
		takeoffHeading = 1.082, -- in radians
		squadrons = {
			["5PAF"] = {
				["name"] = "No. 5 Squadron",
				["country"] = country.PAKISTAN,
				["type"] = "F-16C_50",
				["skill"] = "High",
				["livery"] = "PAF_No.5_Falcons",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 100000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.CAP] = true,
				},
				["targetCategories"] = {
					[Unit.Category.AIRPLANE] = true
				},
				["threatTypes"] = {
					[defs.threatType.Standard] = true,
					[defs.threatType.High] = true
				},
				["loadouts"] = {
					[defs.roleCategory.AA] = {
						[defs.missionType.General] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{AIM-9L}",
								},
								[2] =
								{
									["CLSID"] = "{AIM-9L}",
								},
								[3] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[4] =
								{
									["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
								},
								[5] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[6] =
								{
									["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
								},
								[7] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[8] =
								{
									["CLSID"] = "{AIM-9L}",
								},
								[9] =
								{
									["CLSID"] = "{AIM-9L}",
								},
							},
							["fuel"] = 3249,
							["flare"] = 60,
							["chaff"] = 60,
							["gun"] = 100,
							["ammo_type"] = 5,
						}
					}
				},
				["callsigns"] = {
					["Falcon"] = 0
				}
			}
		}
	},
	["Saratoga"] = {
		name = "USS Saratoga (CV-60)", -- DCS name
		takeoffHeading = 0, -- in radians
		squadrons = {
			["VF74"] = {
				["name"] = "VF-74",
				["country"] = country.USA,
				["type"] = "F-14B",
				["skill"] = "High",
				["livery"] = "vf-74 bedevilers 1991",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 80000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.Escort] = true,
					[defs.missionType.HAVCAP] = true
				},
				["targetCategories"] = {
					[Unit.Category.AIRPLANE] = true
				},
				["threatTypes"] = {
					[defs.threatType.Standard] = true,
					[defs.threatType.High] = true
				},
				["loadouts"] = {
					[defs.roleCategory.AA] = {
						[defs.missionType.General] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "{LAU-138 wtip - AIM-9M}",
								},
								[2] =
								{
									["CLSID"] = "{SHOULDER AIM-7M}",
								},
								[3] =
								{
									["CLSID"] = "{F14-300gal}",
								},
								[4] =
								{
									["CLSID"] = "{AIM_54A_Mk60}",
								},
								[5] =
								{
									["CLSID"] = "{BELLY AIM-7M}",
								},
								[7] =
								{
									["CLSID"] = "{AIM_54A_Mk60}",
								},
								[8] =
								{
									["CLSID"] = "{F14-300gal}",
								},
								[9] =
								{
									["CLSID"] = "{SHOULDER AIM-7M}",
								},
								[10] =
								{
									["CLSID"] = "{LAU-138 wtip - AIM-9M}",
								},
							},
							["fuel"] = 7348,
							["flare"] = 60,
							["chaff"] = 140,
							["gun"] = 100,
							["ammo_type"] = 1,
						}
					}
				},
				["callsigns"] = {
					["Devil"] = 18
				}
			},
			["VAW125"] = {
				["name"] = "VAW-125",
				["country"] = country.USA,
				["type"] = "E-2C", -- KC-707
				["skill"] = "High",
				["livery"] = "VAW-125 Tigertails",
				["baseFlightSize"] = 1,
				["missions"] = {
					[defs.missionType.AEW] = true
				},
				["loadouts"] = {
					[defs.roleCategory.Support] = {
						[defs.missionType.General] = {
							["pylons"] =
							{
							},
							["fuel"] = 5624,
							["flare"] = 60,
							["chaff"] = 120,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Magic"] = 2,
					["Wizard"] = 3
				}
			}
		}
	}
}

local ACUSNPAF = AirCommand:new(coalition.side.BLUE, "USN/PAF")
ACUSNPAF:setParameters(parameters)
ACUSNPAF:setAircraftParameters(aircraftParameters)
ACUSNPAF:setThreatTypes(threatTypes)
ACUSNPAF:activate(OOB, orbits, CAPZones, ADZExclusion, false)
ACUSNPAF:enableDebug()