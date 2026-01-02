local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('truckerJob:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query('SELECT * FROM trucker_stats WHERE identifier = ?', {xPlayer.identifier}, function(result)
        if result and result[1] then cb(result[1]) else
            MySQL.insert('INSERT INTO trucker_stats (identifier) VALUES (?)', {xPlayer.identifier})
            cb({level = 1, xp = 0, total_money = 0, total_deliveries = 0})
        end
    end)
end)

RegisterNetEvent('truckerJob:server:reward')
AddEventHandler('truckerJob:server:reward', function(index, damage)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = Config.Jobs[index]
    local lang = Config.Translate[Config.Language]
    local payout = math.floor(job.basePrice * (1.0 - (damage / 100 * 0.8)))
    if payout < 100 then payout = 100 end
    
    xPlayer.addMoney(payout)
    MySQL.query('UPDATE trucker_stats SET xp = xp + ?, total_money = total_money + ?, total_deliveries = total_deliveries + 1 WHERE identifier = ?', {job.xpReward, payout, xPlayer.identifier})
    
    local msg = damage > 5 and lang.n_damaged or lang.n_perfect
    local ntype = damage > 5 and "error" or "success"
    TriggerClientEvent('truckerJob:client:notify', src, msg .. " (+$" .. payout .. ")", ntype)

    MySQL.query('SELECT xp, level FROM trucker_stats WHERE identifier = ?', {xPlayer.identifier}, function(result)
        if result[1] and result[1].xp >= (result[1].level * 1500) then
            MySQL.query('UPDATE trucker_stats SET level = level + 1 WHERE identifier = ?', {xPlayer.identifier})
            TriggerClientEvent('truckerJob:client:notify', src, "Level Up!", "success")
        end
    end)
end)