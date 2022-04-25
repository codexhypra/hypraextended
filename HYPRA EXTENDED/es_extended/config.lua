Config      = {}
Config.Locale       = 'es'

Config.Accounts     = {
	bank= _U('account_bank'),
	black_money = _U('account_black_money'),
	money       = _U('account_money'),
	forascoin    = _U('account_baxirium'),
}

Config.StartingAccountMoney = { bank = 19000, money = 1000 }

Config.EnableSocietyPayouts = false -- pay from the society account that the player is employed at? Requirement: esx_society
Config.MaxWeight    = 10000   -- the max inventory weight without backpack
Config.PaycheckInterval     = 1200000
Config.EnableDebug  = false
Config.adminRanks = { -- change this as your server ranking ( default are : superadmin | admin | moderator )
				'owner',
				'superadmin',
				'admin',
				'mod'
    }