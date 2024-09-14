local scriptPath = lfs.writedir() .. "Scripts\\AirCommand"
package.path = package.path .. ";" .. scriptPath .. "\\?.lua;"
---------------------------------------------------------------------------------------------------------------------------
local AirCommand = require("AirCommand")
local defs = require("Defs")

-- parameters
local parameters = {
	["minPackageTime"] = 300,
	["maxPackageTime"] = 600,
	["tankerChance"] = 100,
	["CAPChance"] = 2,
 	["AMBUSHChance"] = 0
}

-- parameters for aircraft
local aircraftParameters = {
	["escortCommitRange"] = 90000,
	["maxAltitude"] = 10000,
	["standardAltitude"] = 7500,
	["returnAltitude"] = 9000,
	["ambushAltitude"] = 180,
	["standardSpeed"] = 250,
	["ambushSpeed"] = 200,
	["IL-78M"] = {
		["standardAltitude"] = 8000,
		["standardSpeed"] = 233.6
	},
	["Su-27"] = {
		["preferredTactic"] = defs.interceptTactic.LeadHigh
	},
	["MiG-31"] = {
		["preferredTactic"] = defs.interceptTactic.LeadHigh
	}
}

-- table defining aircraft threat types, any not defined is assumed to be standard
local threatTypes = {
	["F-14A-135-GR"] = defs.threatType.High
}

-- support aircraft orbits
local orbits = {
	["Kerman"] = {
		[1] = {
			["x"] = 363580,
			["y"] = 102662
		},
		[2] = {
			["x"] = 305627,
			["y"] = 173034
		},
		["airframes"] = {
			["IL-78M"] = true
		}
	}
}

local CAPZones = {
	[1] = {
		["x"] = 419780,
		["y"] = 94495,
		["radius"] = 160000,
		["reference"] = {
			["x"] = 268235,
			["y"] = 56650
		}
	}
}

-- any zones where interception will not be launched even if in range of a squadron
local ADZExclusion = {
}

-- airbases and squadrons
local OOB = {
	["Kerman"] = {
		name = "Kerman", -- DCS name
		takeoffHeading = 0.314, -- in radians
		squadrons = {
			["763IAP"] = {
				["name"] = "763 IAP",
				["country"] = country.USSR,
				["type"] = "MiG-31",
				["skill"] = "High",
				["livery"] = "af standard",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 75000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.Escort] = true,
					[defs.missionType.HAVCAP] = true,
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true
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
									["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
								},
								[2] =
								{
									["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
								},
								[3] =
								{
									["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
								},
								[4] =
								{
									["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
								},
								[5] =
								{
									["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
								},
								[6] =
								{
									["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
								},
							},
							["fuel"] = 15500,
							["flare"] = 0,
							["chaff"] = 0,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Aurora"] = 0
				}
			},
			["831IAP"] = {
				["name"] = "831 IAP",
				["country"] = country.USSR,
				["type"] = "Su-27",
				["skill"] = "High",
				["livery"] = "Air Force Standard Early",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 50000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
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
									["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
								},
								[2] =
								{
									["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
								},
								[3] =
								{
									["CLSID"] = "{88DAC840-9F75-4531-8689-B46E64E42E53}",
								},
								[4] =
								{
									["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
								},
								[7] =
								{
									["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
								},
								[8] =
								{
									["CLSID"] = "{88DAC840-9F75-4531-8689-B46E64E42E53}",
								},
								[9] =
								{
									["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
								},
								[10] =
								{
									["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
								},
							},
							["fuel"] = 9400,
							["flare"] = 96,
							["chaff"] = 96,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Aurora"] = 0
				}
			},
			["176IAP"] = {
				["name"] = "176 IAP",
				["country"] = country.USSR,
				["type"] = "MiG-29A",
				["skill"] = "High",
				["livery"] = "Air Force Standard",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 75000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.CAP] = true,
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true
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
									["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
								},
								[2] =
								{
									["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
								},
								[3] =
								{
									["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
								},
								[5] =
								{
									["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
								},
								[6] =
								{
									["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
								},
								[7] =
								{
									["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
								},
							},
							["fuel"] = 3376,
							["flare"] = 30,
							["chaff"] = 30,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Siren"] = 0,
					["Sapphire"] = 0,
					["Amber"] = 0
				}
			},
			["982IAP"] = {
				["name"] = "982 IAP",
				["country"] = country.USSR,
				["type"] = "MiG-23MLD",
				["skill"] = "High",
				["livery"] = "af standard-1",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 75000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.CAP] = true,
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true
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
								[2] =
								{
									["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
								},
								[3] =
								{
									["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
								},
								[4] =
								{
									["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
								},
								[5] =
								{
									["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
								},
								[6] =
								{
									["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
								},
							},
							["fuel"] = 3800,
							["flare"] = 60,
							["chaff"] = 60,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Siren"] = 0,
					["Sapphire"] = 0,
					["Amber"] = 0
				}
			},
			["409APSZ"] = {
				["name"] = "409 APSZ",
				["country"] = country.USSR,
				["type"] = "IL-78M",
				["skill"] = "High",
				["livery"] = "RF Air Force",
				["baseFlightSize"] = 1,
				["missions"] = {
					[defs.missionType.Tanker] = true
				},
				["loadouts"] = {
					[defs.roleCategory.Support] = {
						[defs.missionType.General] = {
							["pylons"] =
							{
							},
							["fuel"] = 90000,
							["flare"] = 96,
							["chaff"] = 96,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Atlant"] = 0
				}
			}
		}
	}
}

local ACRed = AirCommand:new(coalition.side.RED, "Soviet Union")
ACRed:setParameters(parameters)
ACRed:setAircraftParameters(aircraftParameters)
ACRed:setThreatTypes(threatTypes)
ACRed:activate(OOB, orbits, CAPZones, ADZExclusion, true)
ACRed:enableDebug()