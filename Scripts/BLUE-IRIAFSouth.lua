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
                                            ["alt"] = 5,
                                            ["action"] = "From Runway",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 342.4134927248,
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
                                                                ["x"] = 139248.85294136,
                                                                ["y"] = 119749.3276566,
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
                                                                ["zoneRadius"] = 121920,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "TakeOff",
                                            ["ETA"] = 0,
                                            ["ETA_locked"] = true,
                                            ["y"] = 14257.968262,
                                            ["x"] = 115765.882813,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 2,
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
                                            ["ETA"] = 203.22408911426,
                                            ["ETA_locked"] = false,
                                            ["y"] = 102950.25925368,
                                            ["x"] = 111085.70885412,
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
                                            ["ETA"] = 327.82132820751,
                                            ["ETA_locked"] = false,
                                            ["y"] = 146924.29124954,
                                            ["x"] = 143201.57491851,
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
                                            ["ETA"] = 476.97322971523,
                                            ["ETA_locked"] = false,
                                            ["y"] = 117772.96666802,
                                            ["x"] = 201504.22408156,
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
                                            ["ETA"] = 591.52208361312,
                                            ["ETA_locked"] = false,
                                            ["y"] = 150159.77516713,
                                            ["x"] = 239678.35758289,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [5]
                                        [6] = 
                                        {
                                            ["alt"] = 7620,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 218.51663552233,
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
                                            ["ETA"] = 1318.2611334606,
                                            ["ETA_locked"] = false,
                                            ["y"] = 12192.02590304,
                                            ["x"] = 161041.26534875,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [6]
                                        [7] = 
                                        {
                                            ["alt"] = 5,
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
                                            ["ETA"] = 2239.1352489566,
                                            ["ETA_locked"] = false,
                                            ["y"] = 14257.968262,
                                            ["x"] = 115765.882813,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 2,
                                            ["speed_locked"] = true,
                                        }, -- end of [7]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = 1,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 5,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IRIAF Asia Minor",
                                        ["skill"] = "Random",
                                        ["speed"] = 342.4134927248,
                                        ["type"] = "F-4E",
                                        ["unitId"] = 1,
                                        ["psi"] = -1.6235160966661,
                                        ["y"] = 14257.968262,
                                        ["x"] = 115765.882813,
                                        ["name"] = "IRIAF F-4E South-1",
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
                                        ["heading"] = 0,
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
                                        ["alt"] = 5,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IRIAF Asia Minor",
                                        ["skill"] = "Random",
                                        ["speed"] = 342.4134927248,
                                        ["type"] = "F-4E",
                                        ["unitId"] = 2,
                                        ["psi"] = -1.6235160966661,
                                        ["y"] = 14297.968262,
                                        ["x"] = 115725.882813,
                                        ["name"] = "IRIAF F-4E South-2",
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
                                        ["heading"] = 0,
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
                                ["y"] = 14257.968262,
                                ["x"] = 115765.882813,
                                ["name"] = "IRIAF F-4E South",
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
                                            ["alt"] = 5,
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
                                                                ["x"] = 139248.85294136,
                                                                ["y"] = 119749.3276566,
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
                                                                ["zoneRadius"] = 121920,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "TakeOff",
                                            ["ETA"] = 0,
                                            ["ETA_locked"] = true,
                                            ["y"] = 14257.968262,
                                            ["x"] = 115765.882813,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 2,
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
                                            ["ETA"] = 237.0947706333,
                                            ["ETA_locked"] = false,
                                            ["y"] = 102950.25925368,
                                            ["x"] = 111085.70885412,
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
                                            ["ETA"] = 602.77741426374,
                                            ["ETA_locked"] = false,
                                            ["y"] = 150159.77516713,
                                            ["x"] = 239678.35758289,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
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
                                            ["ETA"] = 1511.67480611,
                                            ["ETA_locked"] = false,
                                            ["y"] = 12192.02590304,
                                            ["x"] = 161041.26534875,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [4]
                                        [5] = 
                                        {
                                            ["alt"] = 5,
                                            ["action"] = "Landing",
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
                                            ["type"] = "Land",
                                            ["ETA"] = 1771.0722229484,
                                            ["ETA_locked"] = false,
                                            ["y"] = 14257.968262,
                                            ["x"] = 115765.882813,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 2,
                                            ["speed_locked"] = true,
                                        }, -- end of [5]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = 2,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 5,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IR IRIAF 43rd TFS",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-5E-3",
                                        ["unitId"] = 3,
                                        ["psi"] = -1.6235160966661,
                                        ["y"] = 14257.968262,
                                        ["x"] = 115765.882813,
                                        ["name"] = "IRIAF F-5E South-1",
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
                                        ["heading"] = 1.6235160966661,
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
                                        ["alt"] = 5,
                                        ["hardpoint_racks"] = true,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "ir iriaf 43rd tfs",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-5E-3",
                                        ["unitId"] = 4,
                                        ["psi"] = -1.6235160966661,
                                        ["y"] = 14257.968262,
                                        ["x"] = 115765.882813,
                                        ["name"] = "IRIAF F-5E South-2",
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
                                        ["heading"] = 1.6235160966661,
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
                                ["y"] = 14257.968262,
                                ["x"] = 115765.882813,
                                ["name"] = "IRIAF F-5E South",
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
    trigger.action.setUserFlag("IRIAFSouth", 0)
end

if trigger.misc.getUserFlag("IRIAFSouth") == 1
	then
		return
	else
	spawnedGroup = coalition.addGroup(34, Group.Category.AIRPLANE, flights[math.random(1, #flights)])
	trigger.action.setUserFlag("IRIAFSouth", 1)
	timer.scheduleFunction(resetFlag, nil, timer.getTime() + 900)
end
