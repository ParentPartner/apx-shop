-- apx-shop/client/main.lua

local inShop = false
local currentShop = nil

function openShop(shop)
    print("Opening shop:", shop.name)
    inShop = true
    currentShop = shop
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openShop",
        shop = shop
    })
end

function closeShop()
    if inShop then
        print("Closing shop")
        inShop = false
        currentShop = nil
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "closeShop"
        })
    end
end

-- Create blips for shops
Citizen.CreateThread(function()
    for _, shop in ipairs(Config.Shops) do
        local blip = AddBlipForCoord(shop.blip.x, shop.blip.y, shop.blip.z)
        SetBlipSprite(blip, shop.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, shop.blip.scale)
        SetBlipColour(blip, shop.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Keybind to open shop (E key)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 38) then -- E key
            if not inShop then
                local playerCoords = GetEntityCoords(PlayerPedId())
                for _, shop in ipairs(Config.Shops) do
                    local distance = GetDistanceBetweenCoords(playerCoords, shop.blip.x, shop.blip.y, shop.blip.z, true)
                    if distance < 2.0 then
                        openShop(shop)
                        break
                    end
                end
            end
        end
    end
end)

RegisterNUICallback('purchaseItem', function(data, cb)
    local item = data.item
    local cost = data.cost
    TriggerServerEvent('apx-shop:purchaseItem', item, cost)
    cb('ok')
end)

RegisterNUICallback('closeShop', function(data, cb)
    closeShop()
    cb('ok')
end)

RegisterNetEvent('apx-shop:purchaseSuccess')
AddEventHandler('apx-shop:purchaseSuccess', function(item, cost)
    TriggerEvent('chat:addMessage', { args = { 'Shop', 'Successfully purchased ' .. item .. ' for $' .. cost } })
    closeShop()
end)

RegisterNetEvent('apx-shop:purchaseFailure')
AddEventHandler('apx-shop:purchaseFailure', function(item)
    TriggerEvent('chat:addMessage', { args = { 'Shop', 'Failed to purchase ' .. item .. '. Not enough money.' } })
end)

RegisterNetEvent('apx-shop:receiveInventory')
AddEventHandler('apx-shop:receiveInventory', function(inventory)
    for _, item in ipairs(inventory) do
        TriggerEvent('chat:addMessage', { args = { 'Inventory', item.name .. ' x' .. item.count } })
    end
end)

RegisterCommand('inventory', function()
    TriggerServerEvent('apx-shop:requestInventory')
end, false)
