local weapons = {
	`WEAPON_HAMMER`,
	`WEAPON_PISTOL`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_REVOLVER`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_MINISMG`,
	`WEAPON_MACHINEPISTOL`,
	`WEAPON_DOUBLEACTION`,
}

local holstered = true
local canFire = true
local currWeapon = `WEAPON_UNARMED`

Citizen.CreateThread(function()
	currWeapon = GetSelectedPedWeapon(PlayerPedId())
	while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
		if DoesEntityExist( player ) and not IsEntityDead( player ) and not IsPedInAnyVehicle(PlayerPedId(-1), true) and not IsPedInParachuteFreeFall(player) and GetPedParachuteState(player) == -1 then
			if currWeapon ~= GetSelectedPedWeapon(player) then
				pos = GetEntityCoords(player, true)
				rot = GetEntityHeading(player)

				local newWeap = GetSelectedPedWeapon(player)
				SetCurrentPedWeapon(player, currWeapon, true)
				loadAnimDict( "reaction@intimidation@1h" )

				if CheckWeapon(newWeap) then
					if holstered then
						canFire = false
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "intro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(player, newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(player)
						holstered = false
						canFire = true
					elseif newWeap ~= currWeapon and CheckWeapon(currWeapon) then
						canFire = false
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "outro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1600)
						SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
						--ClearPedTasks(player)
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "intro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(player, newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(player)
						holstered = false
						canFire = true
					else
						SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
						--ClearPedTasks(player)
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "intro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(player, newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(player)
						holstered = false
						canFire = true
					end
				else
					if not holstered and CheckWeapon(currWeapon) then
						canFire = false
						TaskPlayAnimAdvanced(player, "reaction@intimidation@1h", "outro", GetEntityCoords(player, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1600)
						SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
						ClearPedTasks(player)
						SetCurrentPedWeapon(player, newWeap, true)
						holstered = true
						canFire = true
						currWeapon = newWeap
					else
						SetCurrentPedWeapon(player, newWeap, true)
						holstered = false
						canFire = true
						currWeapon = newWeap
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(player, true)
		end
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if weapons[i] == newWeap then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end