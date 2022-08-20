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
                                                                ["x"] = -18842.564203586,
                                                                ["y"] = 235846.56720622,
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
                                                                ["zoneRadius"] = 60960,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                        [2] = 
                                                        {
                                                            ["enabled"] = true,
                                                            ["auto"] = false,
                                                            ["id"] = "EngageTargetsInZone",
                                                            ["number"] = 2,
                                                            ["params"] = 
                                                            {
                                                                ["y"] = 149722.23095536,
                                                                ["x"] = -23710.953055546,
                                                                ["targetTypes"] = 
                                                                {
                                                                    [1] = "Air",
                                                                }, -- end of ["targetTypes"]
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
                                                                ["zoneRadius"] = 60960,
                                                            }, -- end of ["params"]
                                                        }, -- end of [2]
                                                        [3] = 
                                                        {
                                                            ["number"] = 3,
                                                            ["auto"] = false,
                                                            ["id"] = "EngageTargetsInZone",
                                                            ["enabled"] = true,
                                                            ["params"] = 
                                                            {
                                                                ["targetTypes"] = 
                                                                {
                                                                    [1] = "Air",
                                                                }, -- end of ["targetTypes"]
                                                                ["x"] = -22916.314138336,
                                                                ["y"] = 328565.60734599,
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
                                                                ["zoneRadius"] = 60960,
                                                            }, -- end of ["params"]
                                                        }, -- end of [3]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 0,
                                            ["ETA_locked"] = true,
                                            ["y"] = 420168.5407549,
                                            ["x"] = -76474.818605986,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [1]
                                        [2] = 
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
                                                        [1] = 
                                                        {
                                                            ["number"] = 1,
                                                            ["auto"] = false,
                                                            ["id"] = "Orbit",
                                                            ["enabled"] = true,
                                                            ["params"] = 
                                                            {
                                                                ["altitude"] = 7620,
                                                                ["pattern"] = "Race-Track",
                                                                ["speed"] = 218.40277777778,
                                                                ["speedEdited"] = true,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 779.69656414173,
                                            ["ETA_locked"] = false,
                                            ["y"] = 156818.43781033,
                                            ["x"] = -72396.774085142,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
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
                                            ["ETA"] = 1048.1362336212,
                                            ["ETA_locked"] = false,
                                            ["y"] = 149505.24011915,
                                            ["x"] = -14195.909126156,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 8,
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
                                            ["ETA"] = 1670.2336545836,
                                            ["ETA_locked"] = false,
                                            ["y"] = 156196.507813,
                                            ["x"] = -57247.5,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 21,
                                            ["speed_locked"] = true,
                                        }, -- end of [4]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = 1,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 7620,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "PAF_No.5_Falcons",
                                        ["skill"] = "High",
                                        ["speed"] = 218.51663552233,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-16C_50",
                                        ["unitId"] = 1,
                                        ["psi"] = 1.5553123054878,
                                        ["y"] = 420168.5407549,
                                        ["x"] = -76474.818605986,
                                        ["name"] = "5 Squadron - F-16A-1",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                                [1] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [1]
                                                [2] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [2]
                                                [3] = 
                                                {
                                                    ["CLSID"] = "<CLEAN>",
                                                }, -- end of [3]
                                                [4] = 
                                                {
                                                    ["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
                                                }, -- end of [4]
                                                [5] = 
                                                {
                                                    ["CLSID"] = "<CLEAN>",
                                                }, -- end of [5]
                                                [6] = 
                                                {
                                                    ["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
                                                }, -- end of [6]
                                                [7] = 
                                                {
                                                    ["CLSID"] = "<CLEAN>",
                                                }, -- end of [7]
                                                [8] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [8]
                                                [9] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [9]
                                            }, -- end of ["pylons"]
                                            ["fuel"] = 3249,
                                            ["flare"] = 60,
                                            ["ammo_type"] = 5,
                                            ["chaff"] = 60,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = -1.5553123054878,
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
                                        ["alt"] = 7620,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "PAF_No.5_Falcons",
                                        ["skill"] = "High",
                                        ["speed"] = 218.51663552233,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-16C_50",
                                        ["unitId"] = 2,
                                        ["psi"] = 1.5553123054878,
                                        ["y"] = 420208.5407549,
                                        ["x"] = -76514.818605986,
                                        ["name"] = "5 Squadron - F-16A-2",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                                [1] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [1]
                                                [2] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [2]
                                                [3] = 
                                                {
                                                    ["CLSID"] = "<CLEAN>",
                                                }, -- end of [3]
                                                [4] = 
                                                {
                                                    ["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
                                                }, -- end of [4]
                                                [5] = 
                                                {
                                                    ["CLSID"] = "<CLEAN>",
                                                }, -- end of [5]
                                                [6] = 
                                                {
                                                    ["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
                                                }, -- end of [6]
                                                [7] = 
                                                {
                                                    ["CLSID"] = "<CLEAN>",
                                                }, -- end of [7]
                                                [8] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [8]
                                                [9] = 
                                                {
                                                    ["CLSID"] = "{AIM-9L}",
                                                }, -- end of [9]
                                            }, -- end of ["pylons"]
                                            ["fuel"] = 3249,
                                            ["flare"] = 60,
                                            ["ammo_type"] = 5,
                                            ["chaff"] = 60,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = -1.5553123054878,
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
                                ["y"] = 420168.5407549,
                                ["x"] = -76474.818605986,
                                ["name"] = "5 Squadron - F-16A",
                                ["communication"] = true,
                                ["start_time"] = 0,
                                ["frequency"] = 305,
				}}
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
    trigger.action.setUserFlag("PAF5Sqn", 0)
end

if trigger.misc.getUserFlag("PAF5Sqn") == 1
	then
		return
	else
	spawnedGroup = coalition.addGroup(39, Group.Category.AIRPLANE, flights[math.random(1, #flights)])
	trigger.action.setUserFlag("PAF5Sqn", 1)
	timer.scheduleFunction(resetFlag, nil, timer.getTime() + 900)
end
