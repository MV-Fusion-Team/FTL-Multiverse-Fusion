### UNDER CONSTRUCTION

Anyone familiar with Fusion's features is welcome to open a PR to add to this documentation.

## Custom fires
Fusion adds the ability to customize the behavior of individual fires. Related functions and constants are accessible under the `mods.fusion.custom_fires` table.

### Functions
#### `mods.fusion.custom_fires.get_fire_extend(Fire* fire)`
  - Expects a `Fire*` object and returns a `table` unique to that object. Only works for valid `Fire*` objects on tiles within the ship.
  - Additional members can be added to the table, but the following key names are reserved:
    - `systemDamageMultiplier`
    - `spreadSpeedMultiplier` 
    - `deathSpeedMultiplier` 
    - `oxygenDrainMultiplier`
    - `animationSpeedMultiplier`
    - `replacementSheet` 
If you must add new members to this table, they should be added to a table with a unique identifier so as to not conflict with any future reserved identifiers.
  - The following attributes of a fire can be changed:
    - `systemDamageMultiplier`
        A multiplier to the system damage done by an individual fire while it is burning. Default value is 1.
    - `spreadSpeedMultiplier` 
        A multiplier to how quickly this fire starts adjacent fires. Default value is 1.
    - `deathSpeedMultiplier` 
        A multiplier to the speed the fire dies out at low oxygen (less than or equal to 10% oxygen). Default value is 1.
    - `oxygenDrainMultiplier`
        A multiplier to the speed the fire drains oxygen from the room it is in. Default value is 1.
    - `animationSpeedMultiplier`
        A multiplier to the speed at which the fire's animations play. Default value is 1.
    - `replacementSheet` 
        A `GL_Texture*` of the spritesheet of the fire. Defaults to `nil`, which means the vanilla sprite at `img/effects/largeFire.png` will be used. The replacement sprite must have the same dimensions and frame size as the original sheet to function properly.
    - Proper use expects these values to be set as following:
    ```lua
    script.on_internal_event(Defines.InternalEvents.SHIP_LOOP, 
    function(shipManager)
      for room in vter(shipManager.ship.vRoomList) do
        for fire in fires(room, shipManager) do
          get_fire_extend(fire).systemDamageMultiplier = get_fire_extend(fire).systemDamageMultiplier * 2
        end
      end
    end, VALID_PRIORITY)  
    ```
    Where `VALID_PRIORITY` must be greater than `mods.inferno.constants.FIRE_STAT_APPLICATION_PRIORITY` and less than `mods.inferno.constants.FIRE_STAT_INITIALIZATION_PRIORITY`.

#### `mods.fusion.custom_fires.fires(Room*, ShipManager*)`
- An iterator over all `Fire*` objects in a `Room*`. Usage:
```lua
--Extinguish all fires in a room
for fire in fires(room, shipManager) do
    fire.fDamage = 0
end
```
### Constants
Constants relating to custom fires are accessible under `mods.fusion.custom_fires.constants`, a read-only `table` object.
#### `FIRE_EXTEND_INITIALIZATION_LOOP_PRIORITY`
- The priority of the `SHIP_LOOP` callback in which new `Fire_Extend` tables are created.
#### `FIRE_STAT_INITIALIZATION_PRIORITY`
- The priority of the `SHIP_LOOP` callback in which `Fire_Extend` tables have their reserved members set back to default values. All modifications of these members should happen at a lower priority.
#### `FIRE_STAT_APPLICATION_PRIORITY`
- The priority of the `SHIP_LOOP` callback in which `Fire_Extend` tables have their reserved members processed to modify the behavior of their associated `Fire*`. All modifications of these members should happen at a higher priority.