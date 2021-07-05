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
                                                                ["x"] = 275042.88682348,
                                                                ["y"] = -60054.907420781,
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
                                            ["ETA"] = 147.71928726955,
                                            ["ETA_locked"] = false,
                                            ["y"] = -2859.2840849397,
                                            ["x"] = 178013.50486876,
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
                                            ["ETA"] = 341.50662043739,
                                            ["ETA_locked"] = false,
                                            ["y"] = -71607.296184358,
                                            ["x"] = 227474.22720875,
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
                                            ["ETA"] = 513.50599268297,
                                            ["ETA_locked"] = false,
                                            ["y"] = -79207.975980155,
                                            ["x"] = 302258.42085872,
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
                                            ["ETA"] = 688.90641098899,
                                            ["ETA_locked"] = false,
                                            ["y"] = -23337.530411642,
                                            ["x"] = 354742.77881702,
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
                                ["groupId"] = 2,
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
                                        ["unitId"] = 3,
                                        ["psi"] = 0.26835360960537,
                                        ["y"] = 14257.968262,
                                        ["x"] = 115765.882813,
                                        ["name"] = "IRIAF F-4E Center-1",
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
                                        ["heading"] = -0.26835360960537,
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
                                        ["unitId"] = 4,
                                        ["psi"] = 0.26835360960537,
                                        ["y"] = 14297.968262,
                                        ["x"] = 115725.882813,
                                        ["name"] = "IRIAF F-4E Center-2",
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
                                        ["heading"] = -0.26835360960537,
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
                                ["name"] = "IRIAF F-4E Center",
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
                                                                ["x"] = 275042.88682348,
                                                                ["y"] = -60054.907420781,
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
                                            ["ETA"] = 172.33916848115,
                                            ["ETA_locked"] = false,
                                            ["y"] = -2859.2840849397,
                                            ["x"] = 178013.50486876,
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
                                            ["ETA"] = 398.42439051029,
                                            ["ETA_locked"] = false,
                                            ["y"] = -71607.296184358,
                                            ["x"] = 227474.22720875,
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
                                            ["ETA"] = 599.09032479681,
                                            ["ETA_locked"] = false,
                                            ["y"] = -79207.975980155,
                                            ["x"] = 302258.42085872,
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
                                            ["ETA"] = 803.72414615384,
                                            ["ETA_locked"] = false,
                                            ["y"] = -23337.530411642,
                                            ["x"] = 354742.77881702,
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
                                            ["ETA"] = 1930.844933939,
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
                                            ["ETA"] = 2190.2423507774,
                                            ["ETA_locked"] = false,
                                            ["y"] = 14257.968262,
                                            ["x"] = 115765.882813,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 2,
                                            ["speed_locked"] = true,
                                        }, -- end of [7]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = 5,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                    [1] = 
                                    {
                                        ["alt"] = 5,
                                        ["hardpoint_racks"] = true,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "IR IRIAF 43rd TFS",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-5E-3",
                                        ["unitId"] = 9,
                                        ["psi"] = 0.26835360960537,
                                        ["y"] = 14257.968262,
                                        ["x"] = 115765.882813,
                                        ["name"] = "IRIAF F-5E Center-1",
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
                                        ["heading"] = -0.26835360960537,
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
                                        ["livery_id"] = "IR IRIAF 43rd TFS",
                                        ["skill"] = "Random",
                                        ["speed"] = 138.88888888889,
                                        ["AddPropAircraft"] = 
                                        {
                                        }, -- end of ["AddPropAircraft"]
                                        ["type"] = "F-5E-3",
                                        ["unitId"] = 10,
                                        ["psi"] = 0.26835360960537,
                                        ["y"] = 14257.968262,
                                        ["x"] = 115765.882813,
                                        ["name"] = "IRIAF F-5E Center-2",
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
                                        ["heading"] = -0.26835360960537,
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
                                ["name"] = "IRIAF F-5E Center",
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
    trigger.action.setUserFlag("IRIAFCenter", 0)
end

if trigger.misc.getUserFlag("IRIAFCenter") == 1
	then
		return
	else
	spawnedGroup = coalition.addGroup(34, Group.Category.AIRPLANE, flights[math.random(1, #flights)])
	trigger.action.setUserFlag("IRIAFCenter", 1)
	timer.scheduleFunction(resetFlag, nil, timer.getTime() + 900)
end
