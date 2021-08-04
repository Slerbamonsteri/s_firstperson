--[[
What really grinds my gears is that people are trying to get money out of stuff like this.
Also, What this does not provide, is automatic reset on viewmode, although its not that much of an effort to press it yourself.

Happy contributing people!

Also this shit runs in 0.01ms, and i know it's such a mess, but seems to be working somewhat properly :-D 
I'd appreciate if someone can clean this code up 
 ]]

Config = {}
Config.otherthancars = true --Setting this true renders other than cars first person driven
Config.forcefirstperson = true --Setting this true probably overrides config below this, thus rendering all actions in vehicle in firstperson. Setting this false and Config.firstpersonshooting allows you to drive 3rdperson but forces first person when doing driveby
Config.firstpersonshooting = false --Set True to allow only first person shooting in CARS.
Config.drivebyspeed = 60 -- set speed you can shoot from car (60 = you can shoot when vehicles goes under 60kmh)

local notforcedfirstperson = { --Table for vehicles which are not affected Config.forcefirstperson
	'futo',
}
local notforcedfirstpersonshooting = { --Table for vehicles which are not affected Config.firstperonshooting
	'futo',
}

if Config.firstpersonshooting then
	Citizen.CreateThread(function()
	local ped = PlayerPedId()
		while true do
			sleep = 100
			local car = GetVehiclePedIsIn(ped, false)
			local vehiclehash = GetEntityModel(GetVehiclePedIsIn(ped, false))
			local driver = GetPedInVehicleSeat(car, -1), GetPedInVehicleSeat(car, 0), GetPedInVehicleSeat(car, 1), GetPedInVehicleSeat(car, 2)
			for i,o in pairs(notforcedfirstpersonshooting) do
				if vehiclehash ~= GetHashKey(o) then
					sleep = 10
					if driver then	
						if IsPedDoingDriveby(ped) then
							SetFollowVehicleCamViewMode(4)
						end
						if GetEntitySpeed(car) * 3.6 <= Config.drivebyspeed then
							SetPlayerCanDoDriveBy(PlayerId(), true)
						else
							SetPlayerCanDoDriveBy(PlayerId(), false)
						end
					end
				end
			end
		Citizen.Wait(sleep)
		end
	end)
end


local check = false
if Config.forcefirstperson then
	Citizen.CreateThread(function()
		while true do
		local ped = PlayerPedId()
		local boat = IsPedInAnyBoat(ped)
		local heli = IsPedInAnyHeli(ped)
		local subm = IsPedInAnySub(ped)
		local bike = IsPedOnAnyBike(ped)
		local plane = IsPedInAnyPlane(ped)
		local car = GetVehiclePedIsIn(ped, false)
		local vehiclehash = GetEntityModel(GetVehiclePedIsIn(ped, false))
		local driver = GetPedInVehicleSeat(car, -1), GetPedInVehicleSeat(car, 0), GetPedInVehicleSeat(car, 1), GetPedInVehicleSeat(car, 2)
			w = 1000
		if Config.otherthancars then
			if boat then
				SetCamViewModeForContext(3, 4)
			elseif	heli then
				SetCamViewModeForContext(6, 4)
			elseif	plane then
				SetCamViewModeForContext(4, 4)
			elseif subm then
				SetCamViewModeForContext(5, 4)
			elseif bike then
				SetCamViewModeForContext(2, 4)
			end
		end
			for k,v in pairs(notforcedfirstperson) do
				if car then
					w = 100
					if driver then
						if vehiclehash ~= GetHashKey(v) and check == false then
							SetFollowVehicleCamViewMode(4)
							check = true
						end
					end
					if check == true then
						check = false
					end
				end
			end
			Citizen.Wait(w)
		end
	end)
end