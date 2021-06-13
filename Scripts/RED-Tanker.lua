-- Friendly Air Handler -- v1.0 by VMFA-169 Kijaxu --

local flight = {
                                ["modulation"] = 0,
                                ["tasks"] = 
                                {
                                }, -- end of ["tasks"]
                                ["radioSet"] = true,
                                ["task"] = "Refueling",
                                ["uncontrolled"] = false,
                                ["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 6096,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 210.69444444444,
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
                                                            ["auto"] = true,
                                                            ["id"] = "Tanker",
                                                            ["enabled"] = true,
                                                            ["params"] = 
                                                            {
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 0,
                                            ["ETA_locked"] = true,
                                            ["y"] = 140610.40381507,
                                            ["x"] = 693195.13695495,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [1]
                                        [2] = 
                                        {
                                            ["alt"] = 6096,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 210.69444444444,
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
                                                                ["speedEdited"] = true,
                                                                ["pattern"] = "Race-Track",
                                                                ["speed"] = 210.69444444444,
                                                                ["altitude"] = 6096,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 1574.7542770654,
                                            ["ETA_locked"] = false,
                                            ["y"] = 102662.59629363,
                                            ["x"] = 363580.39173551,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 6096,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 210.69444444444,
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
                                            ["ETA"] = 2007.4349089961,
                                            ["ETA_locked"] = false,
                                            ["y"] = 173034.38527787,
                                            ["x"] = 305627.15374849,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 1751,
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
                                            ["ETA"] = 2041.165511227,
                                            ["ETA_locked"] = false,
                                            ["y"] = 71096.085938,
                                            ["x"] = 454116.796875,
                                            ["formation_template"] = "",
                                            ["airdromeId"] = 18,
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
                                        ["alt"] = 6096,
                                        ["alt_type"] = "BARO",
                                        ["livery_id"] = "RF Air Force",
                                        ["skill"] = "Excellent",
                                        ["speed"] = 210.69444444444,
                                        ["type"] = "IL-78M",
                                        ["unitId"] = 1,
                                        ["psi"] = 3.0269695355011,
                                        ["y"] = 140610.40381507,
                                        ["x"] = 693195.13695495,
                                        ["name"] = "Comrade Refueler",
                                        ["payload"] = 
                                        {
                                            ["pylons"] = 
                                            {
                                            }, -- end of ["pylons"]
                                            ["fuel"] = "90000",
                                            ["flare"] = 96,
                                            ["chaff"] = 96,
                                            ["gun"] = 100,
                                        }, -- end of ["payload"]
                                        ["heading"] = -3.0269695355011,
                                        ["callsign"] = 739,
                                        ["onboard_num"] = "739",
                                    }, -- end of [1]
                                }, -- end of ["units"]
                                ["y"] = 140610.40381507,
                                ["x"] = 693195.13695495,
                                ["name"] = "409 APSZ - Il-78M",
                                ["communication"] = true,
                                ["start_time"] = 0,
                                ["frequency"] = 309.5,
		}

local group = coalition.addGroup(68, Group.Category.AIRPLANE, flight)

local function update()
	if group:isExist() == true
		then
			return timer.getTime() + 300
		else
			group = coalition.addGroup(68, Group.Category.AIRPLANE, flight)
			return timer.getTime() + 300
	end
end

timer.scheduleFunction(update, nil, timer.getTime() + 10)
