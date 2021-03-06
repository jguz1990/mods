require "Movables/ISMoveableSpriteProps"

function ISMoveableSpriteProps:scrapObjectInternalX( _character, _scrapDef, _square, _object, _scrapResult, _chance, _perkName )
    local added = 0;
    local scrapResult, chance, perkName = _scrapResult, _chance, _perkName;
    local scrapDef = _scrapDef;
    local object = _object;
    local square = _square;
    if scrapDef and object and square then
        self.keyId = nil
        if instanceof(object, "IsoDoor") then
            self.keyId = object:checkKeyId()
        elseif instanceof(object, "IsoThumpable") then
            self.keyId = object:getKeyId()
        end

        -- Carpentry objects should return items from modData "need:", not MaterialN tile properties.
        -- i.e., Log Walls should give back sheets/rope/twine used to build it, not nails.
        if instanceof(object, "IsoThumpable") and object:hasModData() then
            scrapDef = copyTable(_scrapDef)
            scrapDef.returnItems = {}
            scrapDef.returnItemsStatic = {}
            for k,v in pairs(self.object:getModData()) do
                if luautils.stringStarts(k, "need:") then
                    local type = luautils.split(k, ":")[2]
                    local count = tonumber(v)
                    local item = { returnItem = type, maxAmount = count, chancePerRoll = 80 }
                    table.insert(scrapDef.returnItemsStatic, item)
                end
            end
--            self.scrapSize = nil
            self.material2 = nil
            self.material3 = nil
        end

        local deviceData = object.getDeviceData and object:getDeviceData();

        if isClient() then square:transmitRemoveItemFromSquare(object) end
        square:RemoveTileObject(object);
        square:RecalcProperties();
        square:RecalcAllWithNeighbours(true);

        if self.customItem then
            -- if the moveable object returns a custom item, check if the item can be dismantled
            -- if so, use the dismantle recipes/xp so they are similar.
            local recipe = RecipeManager.getDismantleRecipeFor(self.customItem);
            if recipe then
                local item = instanceItem(self.customItem);
                if item then
                    if deviceData and item.setDeviceData then
                        item:setDeviceData(deviceData);
                        --add item to inventory for the makeItem code for function:
                        _character:getInventory():AddItem(item);
                        RecipeManager.PerformMakeItem(recipe, item, _character, nil);
                        return 1;
                    end
                end
            end
        end

        added = added + self:spawnScrapItems( square, scrapDef, chance );
        -- give XP
        local multiplier = 1;
        if self.scrapSize == "Medium" then
            multiplier = 2;
        elseif self.scrapSize == "Large" then
            multiplier = 3;
        end
        _character:getXp():AddXP(scrapDef.perk, 5 * multiplier)

        if self.material2 then
            scrapDef = ISMoveableDefinitions:getInstance().getScrapDefinition( self.material2 );
            chance = self:getChanceByDef(scrapDef, _character);
            if scrapDef then
                added = added + self:spawnScrapItems( square, scrapDef, chance );
            end
        end
        if self.material3 then
            scrapDef = ISMoveableDefinitions:getInstance().getScrapDefinition( self.material3 );
            chance = self:getChanceByDef(scrapDef, _character);
            if scrapDef then
                added = added + self:spawnScrapItems( square, scrapDef, chance );
            end
        end
    end
	
	local object = _object
	local roadsign = nil
	local spriteName = object:getSprite():getName()
	local customName = object:getProperties():Val("CustomName")
	local groupName = object:getProperties():Val("GroupName")
	if spriteName:contains("roadsign") then roadsign = true end
	if customName:contains("Sign") then
		if groupName == "Inmates" or groupName == "Stop" or groupName == "Streetname" then  roadsign = true end
	end
	if roadsign then
		--_character:getInventory():AddItem("Base.Roadsign")
		_square:AddWorldInventoryItem("Base.Roadsign", 0.5, 0.5, 0);
	end
	
	
	
	
	
    return added;
end

function ISMoveableSpriteProps:scrapObjectInternal( _character, _scrapDef, _square, _object, _scrapResult, _chance, _perkName )
    local added = 0;
    local scrapResult, chance, perkName = _scrapResult, _chance, _perkName;
    local scrapDef = _scrapDef;
    local object = _object;
    local square = _square;
    if scrapDef and object and square then
        self.keyId = nil
        if instanceof(object, "IsoDoor") then
            self.keyId = object:checkKeyId()
        elseif instanceof(object, "IsoThumpable") then
            self.keyId = object:getKeyId()
        end

        -- Carpentry objects should return items from modData "need:", not MaterialN tile properties.
        -- i.e., Log Walls should give back sheets/rope/twine used to build it, not nails.
        if instanceof(object, "IsoThumpable") and object:hasModData() then
            scrapDef = copyTable(_scrapDef)
            scrapDef.returnItems = {}
            scrapDef.returnItemsStatic = {}
            for k,v in pairs(self.object:getModData()) do
                if luautils.stringStarts(k, "need:") then
                    local type = luautils.split(k, ":")[2]
                    local count = tonumber(v)
                    local item = { returnItem = type, maxAmount = count, chancePerRoll = 80 }
                    table.insert(scrapDef.returnItemsStatic, item)
                end
            end
--            self.scrapSize = nil
            self.material2 = nil
            self.material3 = nil
        end

        local deviceData = object.getDeviceData and object:getDeviceData();

        if isClient() then square:transmitRemoveItemFromSquare(object) end
        square:RemoveTileObject(object);
        square:RecalcProperties();
        square:RecalcAllWithNeighbours(true);

        if self.customItem then
            -- if the moveable object returns a custom item, check if the item can be dismantled
            -- if so, use the dismantle recipes/xp so they are similar.
            local recipe = RecipeManager.getDismantleRecipeFor(self.customItem);
            if recipe then
                local item = instanceItem(self.customItem);
                if item then
                    if deviceData and item.setDeviceData then
                        item:setDeviceData(deviceData);
                        --add item to inventory for the makeItem code for function:
                        _character:getInventory():AddItem(item);
                        RecipeManager.PerformMakeItem(recipe, item, _character, nil);
                        return 1;
                    end
                end
            end
        end

        --added = added + self:spawnScrapItems( square, scrapDef, chance );
        --[[
        -- give XP
        local multiplier = 1;
        if self.scrapSize == "Medium" then
            multiplier = 2;
        elseif self.scrapSize == "Large" then
            multiplier = 3;
        end
        _character:getXp():AddXP(scrapDef.perk, 5 * multiplier)
        --]]
        local items = self:getScrapItemsList(_character);

        if scrapDef.addToInventory then
            added = self:addAllScrapItemsToInventory( _character, items );
        else
            added = self:addAllScrapItemsToSquare( _square, items );
        end

        self:scrapGiveXp(_character, scrapDef);

        --[[
        if self.material2 then
            scrapDef = ISMoveableDefinitions:getInstance().getScrapDefinition( self.material2 );
            chance = self:getChanceByDef(scrapDef, _character);
            if scrapDef then
                added = added + self:spawnScrapItems( square, scrapDef, chance );
            end
        end
        if self.material3 then
            scrapDef = ISMoveableDefinitions:getInstance().getScrapDefinition( self.material3 );
            chance = self:getChanceByDef(scrapDef, _character);
            if scrapDef then
                added = added + self:spawnScrapItems( square, scrapDef, chance );
            end
        end
        --]]
    end
	
	local object = _object
	local roadsign = nil
	local spriteName = object:getSprite():getName()
	local customName = object:getProperties():Val("CustomName")
	local groupName = object:getProperties():Val("GroupName")
	if spriteName:contains("roadsign") then roadsign = true end
	if customName:contains("Sign") then
		if groupName == "Inmates" or groupName == "Stop" or groupName == "Streetname" then  roadsign = true end
	end
	if roadsign then
		--_character:getInventory():AddItem("Base.Roadsign")
		_square:AddWorldInventoryItem("Base.Roadsign", 0.5, 0.5, 0);
	end
	
    return added;
end