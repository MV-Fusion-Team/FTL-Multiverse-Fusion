mods.fusion.tempHp = 0
mods.fusion.enemytempHp = 0

script.on_internal_event(Defines.InternalEvents.JUMP_ARRIVE, function(shipManager)
    mods.fusion.tempHp = 0
    mods.fusion.enemytempHp = 0

    if shipManager:HasAugmentation("FUS_TEMP_HULL_JUMP") > 0   then
        mods.fusion.tempHp = math.floor(shipManager:GetAugmentationValue("FUS_TEMP_HULL_JUMP"))
    end
end)

script.on_internal_event(Defines.InternalEvents.DAMAGE_BEAM, function(shipManager, projectile, location, damage, realNewTile, beamHitType)
    if shipManager.iShipId == 0 then
        if beamHitType == 2 and hullData.tempHp > 0 and damage.iDamage > 0 then
            mods.fusion.tempHp = math.max(0, mods.fusion.tempHp - damage.iDamage)
            shipManager:DamageHull((-1 * damage.iDamage), true)
        end
    else
        if beamHitType == 2 and mods.fusion.enemytempHp > 0 and damage.iDamage > 0 then
            mods.fusion.enemytempHp = math.max(0, mods.fusion.enemytempHp - damage.iDamage)
            shipManager:DamageHull((-1 * damage.iDamage), true)
        end
    end
    return Defines.Chain.CONTINUE, beamHitType
end) 

script.on_internal_event(Defines.InternalEvents.DAMAGE_AREA_HIT, function(shipManager, projectile, location, damage, shipFriendlyFire)
    if shipManager.iShipId == 0 then
        if mods.fusion.tempHp > 0 and damage.iDamage > 0 then
            mods.fusion.tempHp = math.max(0, mods.fusion.tempHp - damage.iDamage)
            shipManager:DamageHull((-1 * damage.iDamage), true)
        end
    else
        if mods.fusion.enemytempHp > 0 and damage.iDamage > 0 then
            mods.fusion.enemytempHp = math.max(0, mods.fusion.enemytempHp - damage.iDamage)
            shipManager:DamageHull((-1 * damage.iDamage), true)
        end
    end
end)

local xHPos = 122 + 67
local yHPos = 75
local xHText = xHPos + 51
local yHText = yHPos + 15
local widthH = 75
local heightH = 40
local tempHullText = "Current temporary hull Integrity: will repair the ship by the amount of damage you take until it drops to 0."
local tempHullImage = Hyperspace.Resources:CreateImagePrimitiveString(
    "statusUI/fus_tempHullHp_ui.png",
    xHPos,
    yHPos,
    0,
    Graphics.GL_Color(1, 1, 1, 1),
    1.0,
    false)

script.on_render_event(Defines.RenderEvents.SPACE_STATUS, function()
    if Hyperspace.Global.GetInstance():GetCApp().world.bStartedGame then
        local shipManager = Hyperspace.ships.player
        local commandGui = Hyperspace.Global.GetInstance():GetCApp().gui
        if mods.fusion.tempHp > 0 and not (commandGui.event_pause or commandGui.menu_pause) then
            local hullHP = mods.fusion.tempHp
            Graphics.CSurface.GL_RenderPrimitive(tempHullImage)
            Graphics.CSurface.GL_SetColor(Graphics.GL_Color(0.95294, 1, 0.90196, 1))
            Graphics.freetype.easy_printCenter(0, xHText, yHText, hullHP)

            local mousePos = Hyperspace.Mouse.position
	        if mousePos.x >= xHPos and mousePos.x < (xHPos + widthH) and mousePos.y >= yHPos and mousePos.y < (yHPos + heightH) then
				Hyperspace.Mouse.tooltip = tempHullText
	        end
        end
    end
end, function() end)

local xHPosEnemy = 1056
local yHPosEnemy = 7
local xHTextEnemy = xHPosEnemy + 51
local yHTextEnemy = yHPosEnemy + 15
local widthHEnemy = 75
local heightHEnemy = 40
local tempHullTextEnemy = "Current enemy temporary hull Integrity: will repair the ship by the amount of damage they take until it drops to 0."
local tempHullImageEnemy = Hyperspace.Resources:CreateImagePrimitiveString(
    "statusUI/fus_tempHullHp_ui.png",
    xHPosEnemy,
    yHPosEnemy,
    0,
    Graphics.GL_Color(1, 1, 1, 1),
    1.0,
    false)

script.on_render_event(Defines.RenderEvents.SPACE_STATUS, function()
    if Hyperspace.Global.GetInstance():GetCApp().world.bStartedGame then
        local shipManager = Hyperspace.ships.enemy
        local commandGui = Hyperspace.Global.GetInstance():GetCApp().gui
        if mods.fusion.enemytempHp > 0 and not (commandGui.event_pause or commandGui.menu_pause) then
            local hullHP = mods.fusion.enemytempHp
            Graphics.CSurface.GL_RenderPrimitive(tempHullImageEnemy)
            Graphics.CSurface.GL_SetColor(Graphics.GL_Color(0.95294, 1, 0.90196, 1))
            Graphics.freetype.easy_printCenter(0, xHTextEnemy, yHTextEnemy, hullHP)

            local mousePos = Hyperspace.Mouse.position
	        if mousePos.x >= xHPosEnemy and mousePos.x < (xHPosEnemy + widthHEnemy) and mousePos.y >= yHPosEnemy and mousePos.y < (yHPosEnemy + heightHEnemy) then
				Hyperspace.Mouse.tooltip = tempHullTextEnemy
	        end
        end
    end
end, function() end)