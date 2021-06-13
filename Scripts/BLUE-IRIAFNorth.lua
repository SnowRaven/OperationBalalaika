-- Opposition Air Scramble -- v1.0 by VMFA-169 Kijaxu --

local flights = {{
                                ["modulation"] = 0,
                                ["tasks"] = 
                                {
                                }, -- end of ["tasks"]
                                ["task"] = "CAP",
                                ["uncontrolled"] = false,
                                ["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 1487,
                                            ["action"] = "From Runway",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 138.88888888889,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                        [1] = 
                                                        {
                                                            ["number"] = 1,
                                                            ["auto"] = false,
                                                            ["id"] = "EngageTargetsInZone",
                                                            ["enabled"] = true,
                                                            ["params"] = 
                                                            {
                                                                ["targetTypes"] = 
                                                                {
                                                                    [1] = "Air",
                                                                }, -- end of ["targetTypes"]
                                                                ["x"] = 428287.09661417,
                                                                ["y"] = -241215.39608658,
                                                                ["value"] = "Air;",
                                                                ["noTargetTypes"] = 
                                                                {
                                                                    [1] = "Cruise missiles",
                                                                    [2] = "Antiship Missiles",
                                                                    [3] = "AA Missiles",
                                                                    [4] = "AG Missiles",
                                                                    [5] = "SA Missiles",
                                                                }, -- end of ["noTargetTypes"]
                                                                ["priority"] = 0,
                                                                ["zoneRadius"] = 182880,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "TakeOff",
                                            ["ETA"] = 0,
                                            ["ETA_locked"] = true,
                                            ["y"] = -351636.515625,
                                            ["x"] = 381101.03125,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 19,
                                            ["speed_locked"] = true,
                                        }, -- end of [1]
                                        [2] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 437.03327104467,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 197.03382416221,
                                            ["ETA_locked"] = false,
                                            ["y"] = -296249.75470496,
                                            ["x"] = 447035.06493472,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 437.03327104467,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 346.81551285817,
                                            ["ETA_locked"] = false,
                                            ["y"] = -230809.02048976,
                                            ["x"] = 445464.36562021,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 437.03327104467,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 533.35920973971,
                                            ["ETA_locked"] = false,
                                            ["y"] = -187412.6011267,
                                            ["x"] = 514480.35786026,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [4]
                                        [5] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 437.03327104467,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 822.42062565003,
                                            ["ETA_locked"] = false,
                                            ["y"] = -82160.051947744,
                                            ["x"] = 444615.9722482,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [5]
                                        [6] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 256.94444444444,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 1691.0295771233,
                                            ["ETA_locked"] = false,
                                            ["y"] = -293830.66201844,
                                            ["x"] = 373857.51116742,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [6]
                                        [7] = 
                                        {
                                            ["alt"] = 1487,
                                            ["action"] = "Landing",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 256.94444444444,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Land",
                                            ["ETA"] = 1917.7631053348,
                                            ["ETA_locked"] = false,
                                            ["y"] = -351636.515625,
                                            ["x"] = 381101.03125,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 19,
                                            ["speed_locked"] = true,
                                        }, -- end of [7]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = 3,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 1487,
                                        ["hardpoint_racks"] = true,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IRIAF Asia Minor",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["type"] = "F-4E",
                                        ["unitId"] = 5,
                                        ["psi"] = -0.69867914399834,
                                        ["y"] = -351636.515625,
                                        ["x"] = 381101.03125,
                                        ["name"] = "IRIAF F-4E North-1",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                                [1] = 
                                                {
                                                    ["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
                                                }, -- end of [1]
                                                [2] = 
                                                {
                                                    ["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
                                                }, -- end of [2]
                                                [3] = 
                                                {
                                                    ["CLSID"] = "{AIM-7E}",
                                                }, -- end of [3]
                                                [4] = 
                                                {
                                                    ["CLSID"] = "{AIM-7E}",
                                                }, -- end of [4]
                                                [5] = 
                                                {
                                                    ["CLSID"] = "{8B9E3FD0-F034-4A07-B6CE-C269884CC71B}",
                                                }, -- end of [5]
                                                [6] = 
                                                {
                                                    ["CLSID"] = "{AIM-7E}",
                                                }, -- end of [6]
                                                [7] = 
                                                {
                                                    ["CLSID"] = "{AIM-7E}",
                                                }, -- end of [7]
                                                [8] = 
                                                {
                                                    ["CLSID"] = "{773675AB-7C29-422f-AFD8-32844A7B7F17}",
                                                }, -- end of [8]
                                                [9] = 
                                                {
                                                    ["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
                                                }, -- end of [9]
                                            }, -- end of ["pylons"]
                                            ["fuel"] = "4864",
                                            ["flare"] = 30,
                                            ["chaff"] = 60,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = 0.69867914399834,
                                        ["callsign"] = 
                                        {
                                            [1] = 1,
                                            [2] = 1,
                                            [3] = 1,
                                            ["name"] = "Enfield11",
                                        }, -- end of ["callsign"]
                                        ["onboard_num"] = "010",
                                    }, -- end of [1]
                                    [2] = 
                                    {
                                        ["alt"] = 1487,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IRIAF Asia Minor",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["type"] = "F-4E",
                                        ["unitId"] = 6,
                                        ["psi"] = -0.69867914399834,
                                        ["y"] = -351636.515625,
                                        ["x"] = 381101.03125,
                                        ["name"] = "IRIAF F-4E North-2",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                            }, -- end of ["pylons"]
                                            ["fuel"] = "4864",
                                            ["flare"] = 30,
                                            ["chaff"] = 60,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = 0.69867914399834,
                                        ["callsign"] = 
                                        {
                                            [1] = 1,
                                            [2] = 1,
                                            [3] = 2,
                                            ["name"] = "Enfield12",
                                        }, -- end of ["callsign"]
                                        ["onboard_num"] = "011",
                                    }, -- end of [2]
                                }, -- end of ["units"]
                                ["y"] = -351636.515625,
                                ["x"] = 381101.03125,
                                ["name"] = "IRIAF F-4E North",
                                ["communication"] = true,
                                ["start_time"] = 0,
                                ["frequency"] = 251,
				},
				{
                                ["modulation"] = 0,
                                ["tasks"] = 
                                {
                                }, -- end of ["tasks"]
                                ["task"] = "CAP",
                                ["uncontrolled"] = false,
                                ["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 1487,
                                            ["action"] = "From Runway",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 138.88888888889,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                        [1] = 
                                                        {
                                                            ["number"] = 1,
                                                            ["auto"] = false,
                                                            ["id"] = "EngageTargetsInZone",
                                                            ["enabled"] = true,
                                                            ["params"] = 
                                                            {
                                                                ["targetTypes"] = 
                                                                {
                                                                    [1] = "Air",
                                                                }, -- end of ["targetTypes"]
                                                                ["x"] = 428287.09661417,
                                                                ["y"] = -241215.39608658,
                                                                ["value"] = "Air;",
                                                                ["noTargetTypes"] = 
                                                                {
                                                                    [1] = "Cruise missiles",
                                                                    [2] = "Antiship Missiles",
                                                                    [3] = "AA Missiles",
                                                                    [4] = "AG Missiles",
                                                                    [5] = "SA Missiles",
                                                                }, -- end of ["noTargetTypes"]
                                                                ["priority"] = 0,
                                                                ["zoneRadius"] = 182880,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "TakeOff",
                                            ["ETA"] = 0,
                                            ["ETA_locked"] = true,
                                            ["y"] = -351636.515625,
                                            ["x"] = 381101.03125,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 19,
                                            ["speed_locked"] = true,
                                        }, -- end of [1]
                                        [2] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 374.59994660971,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 229.87279485591,
                                            ["ETA_locked"] = false,
                                            ["y"] = -296249.75470496,
                                            ["x"] = 447035.06493472,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 374.59994660971,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 384.09298796131,
                                            ["ETA_locked"] = false,
                                            ["y"] = -239401.07657169,
                                            ["x"] = 457316.20885244,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 374.59994660971,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 592.73511632698,
                                            ["ETA_locked"] = false,
                                            ["y"] = -202509.91310223,
                                            ["x"] = 491183.50646375,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [4]
                                        [5] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 374.59994660971,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 1007.965105623,
                                            ["ETA_locked"] = false,
                                            ["y"] = -82160.051947744,
                                            ["x"] = 444615.9722482,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [5]
                                        [6] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 174.72222222222,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 2139.634554748,
                                            ["ETA_locked"] = false,
                                            ["y"] = -293830.66201844,
                                            ["x"] = 373857.51116742,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [6]
                                        [7] = 
                                        {
                                            ["alt"] = 1487,
                                            ["action"] = "Landing",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 138.88888888889,
                                            ["task"] = 
                                            {
                                                ["id"] = "ComboTask",
                                                ["params"] = 
                                                {
                                                    ["tasks"] = 
                                                    {
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Land",
                                            ["ETA"] = 2704.788237922,
                                            ["ETA_locked"] = false,
                                            ["y"] = -351636.515625,
                                            ["x"] = 381101.03125,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 19,
                                            ["speed_locked"] = true,
                                        }, -- end of [7]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = 3,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 1487,
                                        ["hardpoint_racks"] = true,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IR IRIAF 43rd TFS",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-5E-3",
                                        ["unitId"] = 5,
                                        ["psi"] = -0.69867914399834,
                                        ["y"] = -351636.515625,
                                        ["x"] = 381101.03125,
                                        ["name"] = "IRIAF F-5E North-1",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                                [1] = 
                                                {
                                                    ["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
                                                }, -- end of [1]
                                                [3] = 
                                                {
                                                    ["CLSID"] = "{PTB-150GAL}",
                                                }, -- end of [3]
                                                [4] = 
                                                {
                                                    ["CLSID"] = "{PTB-150GAL}",
                                                }, -- end of [4]
                                                [5] = 
                                                {
                                                    ["CLSID"] = "{PTB-150GAL}",
                                                }, -- end of [5]
                                                [7] = 
                                                {
                                                    ["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
                                                }, -- end of [7]
                                            }, -- end of ["pylons"]
                                            ["fuel"] = 2046,
                                            ["flare"] = 15,
                                            ["ammo_type"] = 2,
                                            ["chaff"] = 30,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = 0.69867914399834,
                                        ["callsign"] = 
                                        {
                                            [1] = 1,
                                            [2] = 1,
                                            [3] = 1,
                                            ["name"] = "Enfield11",
                                        }, -- end of ["callsign"]
                                        ["onboard_num"] = "010",
                                    }, -- end of [1]
                                    [2] = 
                                    {
                                        ["alt"] = 1487,
                                        ["hardpoint_racks"] = true,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "ir iriaf 43rd tfs",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-5E-3",
                                        ["unitId"] = 6,
                                        ["psi"] = -0.69867914399834,
                                        ["y"] = -351636.515625,
                                        ["x"] = 381101.03125,
                                        ["name"] = "IRIAF F-5E North-2",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                                [1] = 
                                                {
                                                    ["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
                                                }, -- end of [1]
                                                [3] = 
                                                {
                                                    ["CLSID"] = "{PTB-150GAL}",
                                                }, -- end of [3]
                                                [4] = 
                                                {
                                                    ["CLSID"] = "{PTB-150GAL}",
                                                }, -- end of [4]
                                                [5] = 
                                                {
                                                    ["CLSID"] = "{PTB-150GAL}",
                                                }, -- end of [5]
                                                [7] = 
                                                {
                                                    ["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
                                                }, -- end of [7]
                                            }, -- end of ["pylons"]
                                            ["fuel"] = 2046,
                                            ["flare"] = 15,
                                            ["ammo_type"] = 2,
                                            ["chaff"] = 30,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = 0.69867914399834,
                                        ["callsign"] = 
                                        {
                                            [1] = 1,
                                            [2] = 1,
                                            [3] = 2,
                                            ["name"] = "Enfield12",
                                        }, -- end of ["callsign"]
                                        ["onboard_num"] = "011",
                                    }, -- end of [2]
                                }, -- end of ["units"]
                                ["y"] = -351636.515625,
                                ["x"] = 381101.03125,
                                ["name"] = "IRIAF F-5E North",
                                ["communication"] = true,
                                ["start_time"] = 0,
                                ["frequency"] = 305,
				}
				}
local spawnedGroup = {}

local function resetFlag()
    local isActive = false
    if spawnedGroup:isExist()
        then for _, v in pairs(spawnedGroup:getUnits()) do
            if v:inAir() then
                return timer.getTime() + 60
            end
        end
		spawnedGroup:destroy()
    end
    trigger.action.setUserFlag("REPRESENTATIVEFLAGNAME", 0)
end

if trigger.misc.getUserFlag("REPRESENTATIVEFLAGNAME") == 1
	then
		return
	else
	spawnedGroup = coalition.addGroup(34, Group.Category.AIRPLANE, flights[math.random(1, #flights)])
	trigger.action.setUserFlag("REPRESENTATIVEFLAGNAME", 1)
	timer.scheduleFunction(resetFlag, nil, timer.getTime() + 900)
end
