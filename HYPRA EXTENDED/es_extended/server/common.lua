ESX                      = {}
ESX.Players              = {}
ESX.UsableItemsCallbacks = {}
ESX.Items                = {}
ESX.ServerCallbacks      = {}
ESX.TimeoutCount         = -1
ESX.CancelledTimeouts    = {}
ESX.Pickups              = {}
ESX.PickupId             = 0
ESX.Jobs                 = {}
ESX.RegisteredCommands   = {}

AddEventHandler('esx:getSharedObject' , function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items' , {} , function(result)
		for k , v in ipairs(result) do
			ESX.Items[v.name] = {
				label     = v.label,
				type      = v.type,
				weight    = v.weight,
				rare      = v.rare,
				canRemove = v.can_remove
			}
		end
	end)
	
	MySQL.Async.fetchAll('SELECT * FROM jobs' , {} , function(jobs)
		for k , v in ipairs(jobs) do
			ESX.Jobs[v.name]        = v
			ESX.Jobs[v.name].grades = {}
		end
		
		MySQL.Async.fetchAll('SELECT * FROM job_grades' , {} , function(jobGrades)
			for k , v in ipairs(jobGrades) do
				if ESX.Jobs[v.job_name] then
					ESX.Jobs[v.job_name].grades[tostring(v.grade)] = v
				else
					print(('[HYPRA] [^3WARNING^7] Ignoring job grades for "%s" due to missing job'):format(v.job_name))
				end
			end
			
			for k2 , v2 in pairs(ESX.Jobs) do
				if ESX.Table.SizeOf(v2.grades) == 0 then
					ESX.Jobs[v2.name] = nil
					print(('[HYPRA] [^3WARNING^7] Ignoring job "%s" due to no job grades found'):format(v2.name))
				end
			end
		end)
	end)
	
print([[                                                                                                    
    
 
                                          :!J5P5                                                    
                                      :^7P#GJ?~:                                                    
        ~^                .!!      ^PGGB&&^                        .                                
       :&#:     ^:        7@P.  .  :?!.:G&.          ?5.          ?PPP5YYY~             :?~         
       .&B:.~?PB@Y.       J@5  !#J     :G&.          B@~           :~!7?Y&P:      .^.  :#&~         
      .~&@BPBY7#@~        J@J  ?@5     :G&.          #@:   YGBBBGPY7.   ^BP:      ~#B~.Y@7          
 .^7YBPG@#!:  ^#Y.       :P#!  ?@Y     .Y&!      :!JB@@^   :^~!777#&~   ~BP:       :5&B&?    :!:    
?GPPJ~..&B.   !&J.       :P&!  ?@Y     .?@P  .~JPBG??@Y           GB^   ~BP:        :B@P   ^5#G!    
.:     :&B: .^?&Y: ..    :P&!  ?@Y     :J@@P5#G5!:  5@~          .GB^   ~BP:       ^G&P#Y~5&G!      
       :&B: :JGB#BBBBG!  :P#!  ?@Y    :P#@B!~:      &@^          .GB^   ~#P:  .~~^7##^ 7@@G~        
       :&B:    ..::::^:   J@J  ?@Y     .?&7         #@^          .GB^   ~BP:  ^YG&@&#GGB&&P         
       :&B:               J@5  ?@Y       :         .&&:  ^^:..    GB^    5#!   .Y&Y..^~~.!&B^       
       .#&:               !&P. ?@Y                 :@P  ^G#&#BGGY?##~    5@?  .Y@J        :B@7      
        G@~               ~BG. ?@Y                 :@P.    ?@P??JYP?.    ?@5  7&Y          .J@P:    
        P@~               .5#~ ?@Y                 :@P.    !&?     .::::^7#B^ ::             ~#&7   
        P@~               .Y&! ?@Y                 :@P.    !&?.    ?B&#GGPPY^                 .?&B! 
        P@~               .Y&! ?@Y                 Y@?     !&J.     5@? ~7~.                    :Y5 
        P@~               .5&! 5&!                 !G~     J@7      P@! ~5GBG7.                     
        G@!                Y@? !Y:                         #@^     ^#B^    :??:                     
        YG^                ^?~                            ^&P.     :J!                              
                                                          !G!   
                                                          
                                  ╔══════════════════════════════╗  
                                  ║         HYPRAEXTENDED        ║
                                  ╚══════════════════════════════╝                                                       
]])
	print('[es_extended] [^2INFO^7] ESX ^6HYPRA^7 EXTENDED FOR 1.2 & LEGACY')
end)

RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog' , function(msg)
	if Config.EnableDebug then
		print(('[HYPRA] [^2TRACE^7] %s^7'):format(msg))
	end
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback' , function(name , requestId , ...)
	local playerId = source
	
	ESX.TriggerServerCallback(name , requestId , playerId , function(...)
		TriggerClientEvent('esx:serverCallback' , playerId , requestId , ...)
	end , ...)
end)
