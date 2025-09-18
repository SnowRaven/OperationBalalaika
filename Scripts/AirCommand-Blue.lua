local scriptPath = lfs.writedir() .. "Scripts\\AirCommand"
package.path = package.path .. ";" .. scriptPath .. "\\?.lua;"
---------------------------------------------------------------------------------------------------------------------------
local AirCommand = require("AirCommand")
local defs = require("Defs")

-- parameters
local parameters = {
	["minPackageTime"] = 2400,
	["maxPackageTime"] = 4800,
	["tankerChance"] = 15,
	["CAPChance"] = 80,
 	["AMBUSHChance"] = 60
}

-- parameters for aircraft
local aircraftParameters = {
	[Unit.Category.AIRPLANE] = {
		["maxAltitude"] = 9144,
		["standardAltitude"] = 7620,
		["returnAltitude"] = 9144,
		["ambushAltitude"] = 183,
		["standardSpeed"] = 250,
		["ambushSpeed"] = 200,
		["KC-135"] = {
			["standardAltitude"] = 6096.1,
			["standardSpeed"] = 211.1
		},
		["KC135MPRS"] = {
			["standardAltitude"] = 6096.1,
			["standardSpeed"] = 211.1
		},
		["F-5E-3"] = {
			["preferredTactic"] = defs.interceptTactic.Stern,
			["radarRange"] = 12000
		},
		["F-4E-45MC"] = {
			["preferredTactic"] = defs.interceptTactic.Beam,
			["radarRange"] = 60000
		},
		["F-14A-135-GR"] = {
			["preferredTactic"] = defs.interceptTactic.LeadHigh
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
	["Shiraz"] = {
		[1] = {
			["x"] = 340121,
			["y"] = -205223
		},
		[2] = {
			["x"] = 287224,
			["y"] = -150008
		},
		["HAVCAP"] = true
	},
	["Abbas"] = {
		[1] = {
			["x"] = 226045,
			["y"] = -48664
		},
		[2] = {
			["x"] = 175307,
			["y"] = 25752
		},
		["HAVCAP"] = true
	}
}

local CAPZones = {
	[1] = {
		["x"] = 330907,
		["y"] = -74878,
		["radius"] = 80000,
		["reference"] = {
			["x"] = 454234,
			["y"] = 71048
		}
	},
	[2] = {
		["x"] = 195156,
		["y"] = 60845,
		["radius"] = 80000,
		["reference"] = {
			["x"] = 282753,
			["y"] = 141520
		}
	}
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

-- airbases and squadrons
local OOB = {
	["Abbas"] = {
		name = "Bandar Abbas Intl", -- DCS name
		takeoffHeading = 0.488, -- in radians
		squadrons = {
			["91TFS"] = {
				["name"] = "91st TFS",
				["country"] = country.IRAN,
				["type"] = "F-4E-45MC",
				["skill"] = "High",
				["livery"] = "iriaf-3-6673",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 220000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.CAP] = true,
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
									["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
								},
								[2] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[6] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[8] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[14] =
								{
									["CLSID"] = "{HB_ALE_40_30_60}",
								},
								[10] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[12] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[13] =
								{
									["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
								},
							},
							["fuel"] = 5510.5,
							["flare"] = 30,
							["chaff"] = 120,
							["ammo_type"] = 1,
							["gun"] = 100,
						},
						[defs.missionType.QRA] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[2] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[6] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[8] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[14] =
								{
									["CLSID"] = "{HB_ALE_40_30_60}",
								},
								[10] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[12] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[13] =
								{
									["CLSID"] = "<CLEAN>",
								},
							},
							["fuel"] = 5510.5,
							["flare"] = 30,
							["chaff"] = 120,
							["ammo_type"] = 1,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Toophan"] = 0,
					["Alvand"] = 0,
					["Sahand"] = 0,
					["Alborz"] = 0,
					["Shahab"] = 0
				}
			},
			["82TFS"] = {
				["name"] = "82nd TFS",
				["country"] = country.IRAN,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
				["interceptRadius"] = 220000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 1,
				["maxFlightSize"] = 2,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.HAVCAP] = true
				},
				["targetCategories"] = {
					[Unit.Category.AIRPLANE] = true
				},
				["threatTypes"] = {
					[defs.threatType.High] = true
				},
				["loadouts"] = {
					[defs.roleCategory.AA] = {
						[defs.missionType.General] = {
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
								[3] =
								{
									["CLSID"] = "<CLEAN>",
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
								[8] =
								{
									["CLSID"] = "<CLEAN>",
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
							["chaff"] = 140,
							["ammo_type"] = 1,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Shahin"] = 0,
					["Oghab"] = 0,
					["Toophan"] = 0
				}
			}
		}
	},
	["Lar"] = {
		name = "Lar", -- DCS name
		takeoffHeading = 1.576, -- in radians
		squadrons = {
			["23TFS"] = {
				["name"] = "23rd TFS",
				["country"] = country.IRAN,
				["type"] = "F-5E-3",
				["skill"] = "High",
				["livery"] = "ir iriaf 43rd tfs",
				["allWeatherAA"] = defs.capability.Limited,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 60000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.CAP] = true,
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
							["chaff"] = 30,
							["ammo_type"] = 2,
							["gun"] = 100,
						},
						[defs.missionType.QRA] = {
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
					["Palang"] = 0,
					["Kaman"] = 0,
					["Paykan"] = 0
				}
			}
		}
	},
	["Shiraz"] = {
		name = "Shiraz Intl", -- DCS name
		takeoffHeading = 2.037, -- in radians
		squadrons = {
			["71TFS"] = {
				["name"] = "71st TFS",
				["country"] = country.IRAN,
				["type"] = "F-4E-45MC", -- F-4D
				["skill"] = "High",
				["livery"] = "iriaf-3-6643",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 350000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 2,
				["maxFlightSize"] = 4,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.CAP] = true,
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
									["CLSID"] = "{F4_SARGENT_TANK_370_GAL}",
								},
								[2] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[6] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[8] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[10] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[12] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[13] =
								{
									["CLSID"] = "{F4_SARGENT_TANK_370_GAL_R}",
								},
							},
							["fuel"] = 5510.5,
							["flare"] = 0,
							["chaff"] = 0,
							["ammo_type"] = 1,
							["gun"] = 100,
						},
						[defs.missionType.QRA] = {
							["pylons"] =
							{
								[1] =
								{
									["CLSID"] = "<CLEAN>",
								},
								[2] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[4] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[6] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[8] =
								{
									["CLSID"] = "{HB_F4E_AIM-7E-2}",
								},
								[10] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[12] =
								{
									["CLSID"] = "{AIM-9J}",
								},
								[13] =
								{
									["CLSID"] = "<CLEAN>",
								},
							},
							["fuel"] = 5510.5,
							["flare"] = 0,
							["chaff"] = 0,
							["ammo_type"] = 1,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Toophan"] = 0,
					["Alvand"] = 0,
					["Sahand"] = 0,
					["Alborz"] = 0,
					["Kaman"] = 0
				}
			},
			["72TFS"] = {
				["name"] = "72nd TFS",
				["country"] = country.IRAN,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
				["interceptRadius"] = 350000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 1,
				["maxFlightSize"] = 2,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.HAVCAP] = true
				},
				["targetCategories"] = {
					[Unit.Category.AIRPLANE] = true
				},
				["threatTypes"] = {
					[defs.threatType.High] = true
				},
				["loadouts"] = {
					[defs.roleCategory.AA] = {
						[defs.missionType.General] = {
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
								[3] =
								{
									["CLSID"] = "<CLEAN>",
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
								[8] =
								{
									["CLSID"] = "<CLEAN>",
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
							["chaff"] = 140,
							["ammo_type"] = 1,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Shahin"] = 0,
					["Oghab"] = 0,
					["Toophan"] = 0
				}
			},
			["73TFS"] = {
				["name"] = "73rd TFS",
				["country"] = country.IRAN,
				["type"] = "F-14A-135-GR", -- F-14A-95-GR IRIAF
				["skill"] = "High",
				["livery"] = "IRIAF Asia Minor",
				["allWeatherAA"] = defs.capability.Full,
				["allWeatherAG"] = defs.capability.None,
				["highPriority"] = true, -- squadron aircraft will be saved for high priority targets
				["interceptRadius"] = 350000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 1,
				["maxFlightSize"] = 2,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.HAVCAP] = true
				},
				["targetCategories"] = {
					[Unit.Category.AIRPLANE] = true
				},
				["threatTypes"] = {
					[defs.threatType.High] = true
				},
				["loadouts"] = {
					[defs.roleCategory.AA] = {
						[defs.missionType.General] = {
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
								[3] =
								{
									["CLSID"] = "<CLEAN>",
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
								[8] =
								{
									["CLSID"] = "<CLEAN>",
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
							["chaff"] = 140,
							["ammo_type"] = 1,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Shahin"] = 0,
					["Oghab"] = 0,
					["Shahab"] = 0
				}
			},
			["11TS"] = {
				["name"] = "11th TS",
				["country"] = country.IRAN,
				["type"] = "KC135MPRS", -- KC-707
				["skill"] = "High",
				["livery"] = "IRIAF (2)",
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
							["fuel"] = 90700,
							["flare"] = 0,
							["chaff"] = 0,
							["gun"] = 100,
						}
					}
				},
				["callsigns"] = {
					["Karoon"] = 0,
					["Paykan"] = 0,
					["Nahid"] = 0,
					["Mahtab"] = 0
				}
			}
		}
	},
	["Kahnuj FB"] = {
		name = "Kahnuj FB", -- DCS name
		takeoffHeading = 0.436, -- in radians
		squadrons = {
			["3CSG"] = {
				["name"] = "3rd CSG",
				["country"] = country.IRAN,
				["type"] = "AH-1W", -- AH-1J
				["skill"] = "Excellent",
				["livery"] = "I.R.I.A.A",
				["allWeatherAA"] = defs.capability.None,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 40000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 1,
				["maxFlightSize"] = 2,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.CAP] = true
				},
				["targetCategories"] = {
					[Unit.Category.HELICOPTER] = true
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
					["Oghab"] = 0,
					["Sahand"] = 0,
					["Shahin"] = 0,
					["Babr"] = 0
				}
			}
		}
	},
	["Sirjan FB"] = {
		name = "Sirjan FB", -- DCS name
		takeoffHeading = 1.047, -- in radians
		squadrons = {
			["3CSG"] = {
				["name"] = "3rd CSG",
				["country"] = country.IRAN,
				["type"] = "AH-1W", -- AH-1J
				["skill"] = "Excellent",
				["livery"] = "I.R.I.A.A",
				["allWeatherAA"] = defs.capability.None,
				["allWeatherAG"] = defs.capability.None,
				["interceptRadius"] = 40000, -- radius of action around the airbase for interceptors from this squadron in meters
				["baseFlightSize"] = 1,
				["maxFlightSize"] = 2,
				["missions"] = {
					[defs.missionType.Intercept] = true,
					[defs.missionType.QRA] = true,
					[defs.missionType.CAP] = true
				},
				["targetCategories"] = {
					[Unit.Category.HELICOPTER] = true
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
					["Oghab"] = 0,
					["Sahand"] = 0,
					["Shahin"] = 0,
					["Babr"] = 0
				}
			}
		}
	}
}

local ACBlue = AirCommand:new(coalition.side.BLUE, "Iran")
ACBlue:setParameters(parameters)
ACBlue:setAircraftParameters(aircraftParameters)
ACBlue:setThreatTypes(threatTypes)
ACBlue:activate(OOB, orbits, CAPZones, ADZExclusion, false)
ACBlue:enableDebug()