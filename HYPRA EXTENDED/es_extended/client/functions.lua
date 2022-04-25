local isPaused , isDead , pickups = false , false , {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded' , function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData   = playerData
	if playerData.coords == nil then
		playerData.coords = {x = 196.2,  y = -884.08,  z = 30.72}
	end
	
	-- check if player is coming from loading screen
	if GetEntityModel(PlayerPedId()) == GetHashKey('PLAYER_ZERO') then
		local defaultModel = GetHashKey('a_m_y_stbla_02')
		RequestModel(defaultModel)
		
		while not HasModelLoaded(defaultModel) do
			Citizen.Wait(10)
		end
		
		SetPlayerModel(PlayerId() , defaultModel)
		SetPedDefaultComponentVariation(PlayerPedId())
		SetPedRandomComponentVariation(PlayerPedId() , true)
		SetModelAsNoLongerNeeded(defaultModel)
	end
	
	-- freeze the player
	FreezeEntityPosition(PlayerPedId() , true)
	
	-- enable PVP
	SetCanAttackFriendly(PlayerPedId() , true , false)
	NetworkSetFriendlyFireOption(true)
	
	-- disable wanted level
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)
	
	ESX.Game.Teleport(PlayerPedId() , {
		x       = playerData.coords.x,
		y       = playerData.coords.y,
		z       = playerData.coords.z + 0.25,
		heading = playerData.coords.heading
	} , function()
		TriggerServerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:onPlayerSpawn')
		TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
		TriggerEvent('esx:restoreLoadout')
		
		Citizen.Wait(4000)
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		FreezeEntityPosition(PlayerPedId() , false)
		DoScreenFadeIn(10000)
		StartServerSyncLoops()
	end)
	TriggerEvent('DisplayWM', true)
	TriggerEvent('esx:loadingScreenOff')
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight' , function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
end)

AddEventHandler('esx:onPlayerSpawn' , function()
	isDead = false
end)
AddEventHandler('esx:onPlayerDeath' , function()
	isDead = true
end)

AddEventHandler('skinchanger:modelLoaded' , function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(100)
	end
	
	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout' , function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	RemoveAllPedWeapons(playerPed , true)
	
	for k , v in ipairs(ESX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)
		
		GiveWeaponToPed(playerPed , weaponHash , 0 , false , false)
		SetPedWeaponTintIndex(playerPed , weaponHash , v.tintIndex)
		
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed , weaponHash)
		
		for k2 , v2 in ipairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName , v2).hash
			GiveWeaponComponentToPed(playerPed , weaponHash , componentHash)
		end
		
		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed , weaponHash , v.ammo)
			ammoTypes[ammoType] = true
		end
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney' , function(account)
	for k , v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end
end)


RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem' , function(item , count , showNotification)
	for k , v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.UI.ShowInventoryItemNotification(true , v.label , count - v.count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end
	
	if showNotification then
		ESX.UI.ShowInventoryItemNotification(true , item , count)
	end
	
	if ESX.UI.Menu.IsOpen('default' , 'es_extended' , 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem' , function(item , count , showNotification)
	for k , v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.UI.ShowInventoryItemNotification(false , v.label , v.count - count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end
	
	if showNotification then
		ESX.UI.ShowInventoryItemNotification(false , item , count)
	end
	
	if ESX.UI.Menu.IsOpen('default' , 'es_extended' , 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob' , function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon' , function(weaponName , ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	
	GiveWeaponToPed(playerPed , weaponHash , ammo , false , false)
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent' , function(weaponName , weaponComponent)
	local playerPed     = PlayerPedId()
	local weaponHash    = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName , weaponComponent).hash
	
	GiveWeaponComponentToPed(playerPed , weaponHash , componentHash)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo' , function(weaponName , weaponAmmo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	
	SetPedAmmo(playerPed , weaponHash , weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint' , function(weaponName , weaponTintIndex)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	
	SetPedWeaponTintIndex(playerPed , weaponHash , weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon' , function(weaponName)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	
	RemoveWeaponFromPed(playerPed , weaponHash)
	SetPedAmmo(playerPed , weaponHash , 0) -- remove leftover ammo
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent' , function(weaponName , weaponComponent)
	local playerPed     = PlayerPedId()
	local weaponHash    = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName , weaponComponent).hash
	
	RemoveWeaponComponentFromPed(playerPed , weaponHash , componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport' , function(coords)
	local playerPed = PlayerPedId()
	
	-- start decmial number
	coords.x        = coords.x + 0.0
	coords.y        = coords.y + 0.0
	coords.z        = coords.z + 0.0
	
	ESX.Game.Teleport(playerPed , coords)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle' , function(vehicleName)
	local model = (type(vehicleName) == 'number' and vehicleName or GetHashKey(vehicleName))
	
	if IsModelInCdimage(model) then
		local playerPed                    = PlayerPedId()
		local playerCoords , playerHeading = GetEntityCoords(playerPed) , GetEntityHeading(playerPed)
		
		ESX.Game.SpawnVehicle(model , playerCoords , playerHeading , function(vehicle)
			TaskWarpPedIntoVehicle(playerPed , vehicle , -1)
		end)
	else
		TriggerEvent('chat:addMessage' , { args = { '^1[HYPRA]', '¡Modelo de vehículo invalido!' } })
	end
end)

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup' , function(pickupId , label , coords , type , name , components , tintIndex)
	local function setObjectProperties(object)
		SetEntityAsMissionEntity(object , true , false)
		PlaceObjectOnGroundProperly(object)
		FreezeEntityPosition(object , true)
		SetEntityCollision(object , false , true)
		
		pickups[pickupId] = {
			obj     = object,
			label   = label,
			inRange = false,
			coords  = vector3(coords.x , coords.y , coords.z)
		}
	end
	
	if type == 'item_weapon' then
		local weaponHash = GetHashKey(name)
		ESX.Streaming.RequestWeaponAsset(weaponHash)
		local pickupObject = CreateWeaponObject(weaponHash , 50 , coords.x , coords.y , coords.z , true , 1.0 , 0)
		SetWeaponObjectTintIndex(pickupObject , tintIndex)
		
		for k , v in ipairs(components) do
			local component = ESX.GetWeaponComponent(name , v)
			GiveWeaponComponentToWeaponObject(pickupObject , component.hash)
		end
		
		setObjectProperties(pickupObject)
	else
		ESX.Game.SpawnLocalObject('prop_money_bag_01' , coords , setObjectProperties)
	end
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups' , function(missingPickups)
	for pickupId , pickup in pairs(missingPickups) do
		TriggerEvent('esx:createPickup' , pickupId , pickup.label , pickup.coords , pickup.type , pickup.name , pickup.components , pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions' , function(registeredCommands)
	for name , command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion' , ('/%s'):format(name) , command.suggestion.help , command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup' , function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		ESX.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle' , function(radius)
	local playerPed = PlayerPedId()
	
	if radius and tonumber(radius) then
		radius         = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed) , radius)
		
		for k , entity in ipairs(vehicles) do
			local attempt = 0
			
			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end
			
			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle , attempt = ESX.Game.GetVehicleInDirection() , 0
		
		if IsPedInAnyVehicle(playerPed , true) then
			vehicle = GetVehiclePedIsIn(playerPed , false)
		end
		
		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end
		
		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

function StartServerSyncLoops()
	-- keep track of ammo
	Citizen.CreateThread(function()
		local currentWeapon = {timer=0}
		while ESX.PlayerLoaded do
			local sleep = 5

			if currentWeapon.timer == sleep then
				local ammoCount = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
				TriggerServerEvent('esx:updateWeaponAmmo', currentWeapon.name, ammoCount)
				currentWeapon.timer = 0
			elseif currentWeapon.timer > sleep then
				currentWeapon.timer = currentWeapon.timer - sleep
			end

			if IsPedArmed(ESX.PlayerData.ped, 4) then
				if IsPedShooting(ESX.PlayerData.ped) then
					local _,weaponHash = GetCurrentPedWeapon(ESX.PlayerData.ped, true)
					local weapon = ESX.GetWeaponFromHash(weaponHash)

					if weapon then
						currentWeapon.name = weapon.name
						currentWeapon.hash = weaponHash	
						currentWeapon.timer = 100 * sleep		
					end
				end
			else
				sleep = 200
			end
			Citizen.Wait(sleep)
		end
	end)
	
	-- sync current player coords with server
	Citizen.CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x , ESX.PlayerData.coords.y , ESX.PlayerData.coords.z)
		
		while true do
			Citizen.Wait(1000)
			local playerPed = PlayerPedId()
			
			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance     = #(playerCoords - previousCoords)
				
				if distance > 1 then
					previousCoords        = playerCoords
					local playerHeading   = ESX.Math.Round(GetEntityHeading(playerPed) , 1)
					local formattedCoords = { x = ESX.Math.Round(playerCoords.x , 1), y = ESX.Math.Round(playerCoords.y , 1), z = ESX.Math.Round(playerCoords.z , 1), heading = playerHeading }
					TriggerServerEvent('esx:updateCoords' , formattedCoords)
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 289) then
			if IsInputDisabled(0) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
				-- ESX.ShowInventory()
				TriggerEvent("esx_inventory:show")
			end
		end
	end
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if IsControlJustReleased(0, 289) then
			if IsInputDisabled(0) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
				ESX.ShowInventory()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed                       = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(playerPed), true
		local closestPlayer , closestDistance = ESX.Game.GetClosestPlayer(playerCoords)
		
		for pickupId , pickup in pairs(pickups) do
			local distance = #(playerCoords - pickup.coords)
			
			if distance < 5 then
				local label = pickup.label
				letSleep    = false
				
				if distance < 1 then
					if IsControlJustReleased(0 , 38) then
						if IsPedOnFoot(playerPed) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
							pickup.inRange    = true
							
							local dict , anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@' , 'plant_floor'
							ESX.Streaming.RequestAnimDict(dict)
							TaskPlayAnim(playerPed , dict , anim , 8.0 , 1.0 , 1000 , 16 , 0.0 , false , false , false)
							Citizen.Wait(1000)
							
							TriggerServerEvent('esx:onPickup' , pickupId)
							PlaySoundFrontend(-1 , 'PICK_UP' , 'HUD_FRONTEND_DEFAULT_SOUNDSET' , false)
						end
					end
					
					label = ('%s%s'):format(label , _U('threw_pickup_prompt'))
				end
				
				ESX.Game.Utils.DrawText3D({
					                          x = pickup.coords.x,
					                          y = pickup.coords.y,
					                          z = pickup.coords.z + 0.25
				                          } , label , 1.2 , 1)
			elseif pickup.inRange then
				pickup.inRange = false
			end
		end
		
		if letSleep then
			Citizen.Wait(500)
		end
	end
end)]]

Citizen.CreateThread(function()

	while true do

		s = 1000

		local playerPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(playerPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for pickupId,pickup in pairs(pickups) do

			local distance = #(playerCoords - pickup.coords)

			if distance < 5 then
				s = 5
				local label = pickup.label
				letSleep = false

				if distance < 1 then
					s = 5
					if IsControlJustReleased(0, 38) then
						if IsPedOnFoot(playerPed) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
							pickup.inRange = true

							local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
							ESX.Streaming.RequestAnimDict(dict)
							TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
							Citizen.Wait(1000)

							TriggerServerEvent('esx:onPickup', pickupId)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						end
					end

					label = ('%s%s'):format(label, _U('threw_pickup_prompt'))
					
				end

				ESX.Game.Utils.DrawText3D({
					x = pickup.coords.x,
					y = pickup.coords.y,
					z = pickup.coords.z + 0.25
				}, label, 1.2, 1)

			elseif pickup.inRange then
				pickup.inRange = false
			end
			
		end

		if letSleep then
			Citizen.Wait(500)
		end
		
		Citizen.Wait(s)

	end

end)


RegisterCommand('refreshDB', function(sr)
	if sr == 0 then
		print('Starting...')
		MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
			for k,v in ipairs(result) do
				if Config.EnableDebug then
					print('^5['..GetCurrentResourceName()..'] ^2[Items]^5 ['..v.name..'] ['..v.label..'] ^2Registed!^7')
				end
				ESX.Items[v.name] = {
					label = v.label,
					weight = v.weight,
					rare = v.rare,
					canRemove = v.can_remove
				}
			end
		end)
		MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
			for k,v in ipairs(jobs) do
				if Config.EnableDebug then
					print('^5['..GetCurrentResourceName()..'] ^2[Jobs]^5 ['..v.name..'] ['..v.label..'] ^2Registed!^7')
				end
				ESX.Jobs[v.name] = v
				ESX.Jobs[v.name].grades = {}
			end
			MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
				for k,v in ipairs(jobGrades) do
					if ESX.Jobs[v.job_name] then
						ESX.Jobs[v.job_name].grades[tostring(v.grade)] = v
					else
						print(('^5[HYPRA] [^3WARNING^7] Ignoring job grades for "%s" due to missing job^7'):format(v.job_name))
					end
				end
				for k2,v2 in pairs(ESX.Jobs) do
					if ESX.Table.SizeOf(v2.grades) == 0 then
						ESX.Jobs[v2.name] = nil
						print(('^5[HYPRA] [^3WARNING^7] Ignoring job "%s" due to no job grades found^7'):format(v2.name))
					end
				end
			end)
		end)
		Wait(10000)
		print('Finished')
	else
		print('Hola12312')
	end
end,true)