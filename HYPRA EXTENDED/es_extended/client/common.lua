AddEventHandler('esx:getSharedObject' , function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

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
		print('Hazlo desde la terminal')
	end
end,true)