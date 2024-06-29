-- apx-shop/server/main.lua

local function handlePurchase(source, item, cost)
    local playerId = source
    local identifier = GetPlayerIdentifiers(playerId)[1]

    Apex.Functions.getMoney(identifier, function(cash, bank)
        if cash >= cost then
            Apex.Functions.removeMoney(identifier, cost, 'cash')
            Apex.Functions.logAction(identifier, 'purchase', 'Purchased ' .. item .. ' for $' .. cost)
            Apex.Functions.notify(playerId, 'Successfully purchased ' .. item .. ' for $' .. cost, 'success')
            TriggerClientEvent('apx-shop:purchaseSuccess', playerId, item, cost)
        else
            Apex.Functions.notify(playerId, 'Not enough money to purchase ' .. item, 'error')
            TriggerClientEvent('apx-shop:purchaseFailure', playerId, item)
        end
    end)
end

RegisterNetEvent('apx-shop:purchaseItem')
AddEventHandler('apx-shop:purchaseItem', function(item, cost)
    print("Handling purchase for item:", item, "cost:", cost)
    handlePurchase(source, item, cost)
end)
