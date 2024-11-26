mods.fusion.tempHp = 0

script.on_internal_event(Defines.InternalEvents.JUMP_ARRIVE, function(shipManager)
    if shipManager:HasAugmentation("FUS_TEMP_HULL_JUMP") > 0   then
        mods.fusion.tempHp = math.floor(shipManager:GetAugmentationValue("FUS_TEMP_HULL_JUMP"))
    else
        mods.fusion.tempHp = nil
    end
end)

script.on_internal_event(Defines.InternalEvents.DAMAGE_BEAM, function(shipManager, projectile, location, damage, realNewTile, beamHitType)
    if beamHitType == 2 and hullData.tempHp > 0 and damage.iDamage > 0 then
        hullData.tempHp = hullData.tempHp - damage.iDamage
        shipManager:DamageHull((-1 * damage.iDamage), true)
    end
    return Defines.Chain.CONTINUE, beamHitType
end) 

script.on_internal_event(Defines.InternalEvents.DAMAGE_AREA_HIT, function(shipManager, projectile, location, damage, shipFriendlyFire)
    if mods.fusion.tempHp > 0 and damage.iDamage > 0 then
        mods.fusion.tempHp = mods.fusion.tempHp - damage.iDamage
        shipManager:DamageHull((-1 * damage.iDamage), true)
    end
end)

local xHPos = 122 + 67
local yHPos = 75
local xHText = xHPos + 51
local yHText = yHPos + 15
local widthH = 75
local heightH = 40
local tempHullText = "text"
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
        local naniteSwarms = Hyperspace.playerVariables.aea_necro_ability_points
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