--
-- Created by IntelliJ IDEA.
-- User: RJ
-- Date: 22/09/2017
-- Time: 11:06
-- To change this template use File | Settings | File Templates.
--
-- Edit by Notepad++.
-- User: iBrRus
-- Date: 30/11/2020
-- Time: 15:39
--


ISBoatMechanics = ISCollapsableWindow:derive("ISBoatMechanics");
ISBoatMechanics.alphaOverlay = 1;
ISBoatMechanics.alphaOverlayInc = true;
ISBoatMechanics.tooltip = nil;
ISVehicleMechanics.cheat = false;

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function ISBoatMechanics:initialise()
    ISCollapsableWindow.initialise(self);
end

-- tick
function ISBoatMechanics:update()
    if not self.character:getVehicle() or math.abs(self.vehicle:getCurrentSpeedKmHour()) > 10 then 
        -- not (self.vehicle:getSeat(self.character) == self.seat) or 
        self:close()
    else
        self:recalculGeneralCondition();
    end
end

-- tick
function ISBoatMechanics:updateLayout()
    self.listbox:setWidth(self.listWidth)
    self.bodyworklist:setWidth(self.listWidth)
    self.bodyworklist:setX(self.listbox:getRight() + 20)
    self.listbox.vscroll:setX(self.listbox:getWidth() - 16)
    self.bodyworklist.vscroll:setX(self.bodyworklist:getWidth() - 16)
    self.bodyworklist:setX(self.listbox:getRight() + 20)
    self:setWidth(math.max(800, self.xCarTexOffset + self.listWidth + 20 + self.listWidth + 10))
    self.collapseButton:setX(self:getWidth() - 3 - self.collapseButton:getWidth())
    self.pinButton:setX(self:getWidth() - 3 - self.pinButton:getWidth())
end

function ISBoatMechanics:initParts()
    if not self.vehicle then return; end
    self.listbox:clear();
    self.bodyworklist:clear();
    self.vehiclePart = {};
    local currentCat = {};
    local generalCondition = 0;
    local totalPart = 0;
    for i=1,self.vehicle:getPartCount() do
        local part = self.vehicle:getPartByIndex(i-1)
        local category = part:getCategory() or "Other";
        if category ~= "nodisplay" then
            if self.vehiclePart[category] then
                currentCat = self.vehiclePart[category]
            else
                currentCat = {};
                currentCat.parts = {};
                currentCat.name = getText("IGUI_VehiclePartCat" .. category);
                currentCat.cat = category;
                self.vehiclePart[category] = currentCat;
            end
            
            local newPart = {};
            newPart.name = getText("IGUI_VehiclePart" .. part:getId());
            newPart.part = part;
            table.insert(currentCat.parts, newPart);
            
            generalCondition = generalCondition + part:getCondition();
            totalPart = totalPart + 1;
        end
    end
    
    local scrollbarWidth = self.listbox.vscroll:getWidth()
    local maxWidth = (800 - self.xCarTexOffset - 10 - 20) / 2
    
    for i,v in pairs(self.vehiclePart) do
        local cat = {};
        cat.name = v.name;
        cat.cat = true;
        local list = self.listbox;
        if i == "BoatBody" or i == "Other" or i == "other" or i == "HouseholdSystem" or i == "householdsystem" then list = self.bodyworklist;  end
        list:addItem(cat.name, cat);
        for j,k in ipairs(v.parts) do
            list:addItem(k.name, k);
            local width = 20 + getTextManager():MeasureStringX(UIFont.Small, k.name)
            width = width + 2 + getTextManager():MeasureStringX(UIFont.Small, "(100%)")
            maxWidth = math.max(maxWidth, width + scrollbarWidth + 2)
        end
    end
    
    self.listWidth = maxWidth
    self:updateLayout()
    
    self.generalCondition = round(generalCondition / totalPart, 2);
    self.generalCondRGB = self:getConditionRGB(self.generalCondition);
    
    self.leftListHasFocus = true
    self.leftListSelection = 1
    self.rightListSelection = 1
    if self.listbox:size() > 1 then self.listbox.selected = 2 end
    if self.bodyworklist:size() > 1 then self.rightListSelection = 2 end
end

-- tick
function ISBoatMechanics:recalculGeneralCondition()
    if not self.vehicle then return; end
    local generalCondition = 0;
    local totalPart = 0;
    for i=1,self.vehicle:getPartCount() do
        local part = self.vehicle:getPartByIndex(i-1)
        local cond = part:getCondition();
        -- if we removed the item, condition should be 0
        if part:getItemType() and not part:getItemType():isEmpty() and not part:getInventoryItem() then
            cond = 0;
        end
        generalCondition = generalCondition + cond;
        totalPart = totalPart + 1;
    end
    self.generalCondition = round(generalCondition / totalPart, 2);
    self.generalCondRGB = self:getConditionRGB(self.generalCondition);
end

-- tick
function ISBoatMechanics:checkEngineFull()
    local checkEngine = true;
    for i,v in pairs(self.vehiclePart) do
        for j,k in ipairs(v.parts) do
            local functionName = k.part:getLuaFunction("checkEngine")
            if functionName then
                local check = VehicleUtils.callLua(functionName, self.vehicle, k.part)
                if not check then checkEngine = false; end
            end
        end
    end
    self.checkEngine = checkEngine;
end

function ISBoatMechanics:createChildren()
    ISCollapsableWindow.createChildren(self);
    if self.resizeWidget then self.resizeWidget.yonly = true end
    self:setInfo(getText("IGUI_InfoPanel_Mechanics"))    ;

    local rh = self.resizable and self:resizeWidgetHeight() or 0
    local y = self:titleBarHeight() + 10 + 5 + FONT_HGT_MEDIUM + FONT_HGT_SMALL * (5 + 1) + 10
    
    self.listbox = ISScrollingListBox:new(self.xCarTexOffset, y, 220, self.height - rh - 10 - y);
    self.listbox:initialise();
    self.listbox:instantiate();
    self.listbox:setAnchorLeft(true);
    self.listbox:setAnchorRight(false);
    self.listbox:setAnchorTop(true);
    self.listbox:setAnchorBottom(true);
    self.listbox.itemheight = FONT_HGT_SMALL;
    self.listbox.drawBorder = false
    self.listbox.backgroundColor.a = 0
    self.listbox.doDrawItem = ISBoatMechanics.doDrawItem;
    self.listbox.onRightMouseUp = ISBoatMechanics.onListRightMouseUp;
    self.listbox.onMouseDown = ISBoatMechanics.onListMouseDown;
    self.listbox.parent = self;
    self:addChild(self.listbox);
    
    self.bodyworklist = ISScrollingListBox:new(self.xCarTexOffset + self.listbox.width + 20, y, 220, self.height - rh - 10 - y);
    self.bodyworklist:initialise();
    self.bodyworklist:instantiate();
    self.bodyworklist:setAnchorLeft(true);
    self.bodyworklist:setAnchorRight(false);
    self.bodyworklist:setAnchorTop(true);
    self.bodyworklist:setAnchorBottom(true);
    self.bodyworklist.itemheight = FONT_HGT_SMALL;
    self.bodyworklist.drawBorder = false
    self.bodyworklist.backgroundColor.a = 0
    self.bodyworklist.doDrawItem = ISBoatMechanics.doDrawItem;
    self.bodyworklist.onRightMouseUp = ISBoatMechanics.onListRightMouseUp;
    self.bodyworklist.onMouseDown = ISBoatMechanics.onListMouseDown;
    self.bodyworklist.parent = self;
    self:addChild(self.bodyworklist);
    
    self:initParts();
end

function ISBoatMechanics:onListMouseDown(x, y)
    if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 and not getDebug() then return; end
    
    self.parent.listbox.selected = 0;
    self.parent.bodyworklist.selected = 0;
    
    local row = self:rowAt(x, y)
    if row < 1 or row > #self.items then return end
    if not self.items[row].item.cat then
        self.selected = row;
    end
end

function ISBoatMechanics:onListRightMouseUp(x, y)
    self:onMouseDown(x, y);
    if self.items[self.selected] and not self.items[self.selected].item.cat then
        self.parent:doPartContextMenu(self.items[self.selected].item.part, self:getX() + x, self:getY() + self:getYScroll() + y)
    else
        self.parent:onRightMouseUp(self:getX() + x, self:getY() + self:getYScroll() + y)
    end
end

function ISBoatMechanics:doPartContextMenu(part, x,y)
    if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then return; end
    
    local playerObj = getSpecificPlayer(self.playerNum);
    self.context = ISContextMenu.get(self.playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())
    local option;
    
    if part:getItemType() and not part:getItemType():isEmpty() then
        if part:getInventoryItem() then
            local fixingList = FixingManager.getFixes(part:getInventoryItem());
            if part:getScriptPart():isRepairMechanic() and not fixingList:isEmpty() then
                local fixOption = self.context:addOption(getText("ContextMenu_Repair"), nil, nil);
                local subMenuFix = ISContextMenu:getNew(self.context);
                self.context:addSubMenu(fixOption, subMenuFix);
                for i=0,fixingList:size()-1 do
                    ISInventoryPaneContextMenu.buildFixingMenu(part:getInventoryItem(), playerObj:getPlayerNum(), fixingList:get(i), fixOption, subMenuFix, part)
                end
            end
            
            if part:getTable("uninstall") then
                option = self.context:addOption(getText("IGUI_Uninstall"), playerObj, ISBoatPartMenu.onUninstallPart, part)
                self:doMenuTooltip(part, option, "uninstall");
                if not ISVehicleMechanics.cheat and not part:getVehicle():canUninstallPart(playerObj, part) then
                    option.notAvailable = true;
                end
            end
        else
            if part:getTable("install") then
                option = self.context:addOption(getText("IGUI_Install"), playerObj, nil)
                if not ISVehicleMechanics.cheat and not part:getVehicle():canInstallPart(playerObj, part) then
                    option.notAvailable = true;
                    self:doMenuTooltip(part, option, "install", nil);
                else
                    local subMenu = ISContextMenu:getNew(self.context);
                    self.context:addSubMenu(option, subMenu);
                    local typeToItem = VehicleUtils.getItems(self.character:getPlayerNum())
                    -- display all possible item that can be installed
                    for i=0,part:getItemType():size() - 1 do
                        local name = part:getItemType():get(i);
                        local item = InventoryItemFactory.CreateItem(name);
                        if item then name = item:getName(); end
                        local itemOpt = subMenu:addOption(name, playerObj, nil);
                        self:doMenuTooltip(part, itemOpt, "install", part:getItemType():get(i));
                        if not typeToItem[part:getItemType():get(i)] then
                            itemOpt.notAvailable = true;
                        else
                            -- display every item the player posess
                            local subMenuItem = ISContextMenu:getNew(subMenu);
                            self.context:addSubMenu(itemOpt, subMenuItem);
                            for j,v in ipairs(typeToItem[part:getItemType():get(i)]) do
                                local itemOpt = subMenuItem:addOption(v:getDisplayName() .. " (" .. v:getCondition() .. "%)", playerObj, ISBoatPartMenu.onInstallPart, part, v);
                                self:doMenuTooltip(part, itemOpt, "install", part:getItemType():get(i));
                            end
                        end
                    end
                end
            end
        end
    end
    
    if part:getWindow() and (not part:getItemType() or part:getInventoryItem()) then
        local window = part:getWindow()
        if window:isOpenable() and not window:isDestroyed() and playerObj:getVehicle() then
            if window:isOpen() then
                option = self.context:addOption(getText("ContextMenu_Close_window"), playerObj, ISBoatPartMenu.onOpenCloseWindow, part, false)
            else
                option = self.context:addOption(getText("ContextMenu_Open_window"), playerObj, ISBoatPartMenu.onOpenCloseWindow, part, true)
            end
        end
        -- if not window:isDestroyed() then
            -- option = self.context:addOption(getText("ContextMenu_Smash_window"), playerObj, ISBoatPartMenu.onSmashWindow, part)
        -- end
    end
    
    if part:isContainer() and part:getContainerContentType() == "Air" and part:getInventoryItem() then
        option = self.context:addOption(getText("IGUI_InflateTire"), playerObj, ISBoatPartMenu.onInflateTire, part)
        if part:getContainerContentAmount() >= part:getContainerCapacity() + 5 then
            option.notAvailable = true
        end
        local tirePump = InventoryItemFactory.CreateItem("Base.TirePump");
        if not self.character:getInventory():contains("TirePump", true) then
            option.notAvailable = true
            local tooltip = ISToolTip:new();
            tooltip:initialise();
            tooltip:setVisible(false);
            tooltip.description = "<RGB:1,0,0> " .. getText("Tooltip_craft_Needs") .. ": <LINE> " .. tirePump:getDisplayName() .. " 0/1";
            option.toolTip = tooltip;
        else
            local tooltip = ISToolTip:new();
            tooltip:initialise();
            tooltip:setVisible(false);
            tooltip.description = "<RGB:1,1,1> " .. getText("Tooltip_craft_Needs") .. ":  <LINE> " .. tirePump:getDisplayName() .. " 1/1";
            option.toolTip = tooltip;
        end
        option = self.context:addOption(getText("IGUI_DeflateTire"), playerObj, ISBoatPartMenu.onDeflateTire, part)
        if part:getContainerContentAmount() == 0 then
            option.notAvailable = true
        end
    end
    local condInfo = getTextOrNull("IGUI_Vehicle_CondInfo" .. part:getId());
    if condInfo then
        option = self.context:addOption(getText("ContextMenu_PartInfo"), playerObj, nil)
        local tooltip = ISToolTip:new();
        tooltip:initialise();
        tooltip:setVisible(false);
        tooltip.description = condInfo;
        option.toolTip = tooltip;
    end
    
    if part:getId() == "Engine" then
        if part:getCondition() > 10 and self.character:getPerkLevel(Perks.Mechanics) >= part:getVehicle():getScript():getEngineRepairLevel() and self.character:getInventory():contains("Wrench") then
            option = self.context:addOption(getText("IGUI_TakeEngineParts"), playerObj, ISBoatMechanics.onTakeEngineParts, part);
            self:doMenuTooltip(part, option, "takeengineparts");
        else
            option = self.context:addOption(getText("IGUI_TakeEngineParts"), nil, nil);
            self:doMenuTooltip(part, option, "takeengineparts");
            option.notAvailable = true;
        end
        if part:getCondition() < 100 and self.character:getInventory():getNumberOfItem("EngineParts", false, true) > 0 and self.character:getPerkLevel(Perks.Mechanics) >= part:getVehicle():getScript():getEngineRepairLevel() and self.character:getInventory():contains("Wrench") then
            local option = self.context:addOption(getText("IGUI_RepairEngine"), playerObj, ISBoatMechanics.onRepairEngine, part);
            self:doMenuTooltip(part, option, "repairengine");
        else
            local option = self.context:addOption(getText("IGUI_RepairEngine"), playerObj, ISBoatMechanics.onRepairEngine, part);
            self:doMenuTooltip(part, option, "repairengine");
            option.notAvailable = true;
        end
    end
    -- ???????????????????????????? ??????????
    if part:getId() == "BoatName" then
        if part:getItemType() and not part:getItemType():isEmpty() then
            if part:getTable("install") then
                local haveAllItems = true
                local typeToItem = VehicleUtils.getItems(self.playerNum);
                for i, j in pairs(part:getTable("install")["items"]) do 
                    if typeToItem[j["type"]] then
                        haveAllItems = haveAllItems and true
                    else 
                        haveAllItems = haveAllItems and false
                    end
                end
                option = self.context:addOption(getText("IGUI_RenameBoat"), playerObj, nil)
                if not ISVehicleMechanics.cheat and not haveAllItems then
                    self:doMenuTooltip(part, option, "install", nil);
                    option.notAvailable = true;
                else
                    local subMenu = ISContextMenu:getNew(self.context);
                    self.context:addSubMenu(option, subMenu);
                    local typeToItem = VehicleUtils.getItems(self.character:getPlayerNum())
                    -- display all possible item that can be installed
                    for i=0,part:getItemType():size() - 1 do
                        local name = part:getItemType():get(i);
                        -- print(name)
                        local item = InventoryItemFactory.CreateItem(name);
                        if item then name = item:getName(); end
                        local itemOpt = subMenu:addOption(item:getDisplayName(), playerObj, ISBoatPartMenu.onRenameBoat, part, item);
                    -- self:doMenuTooltip(part, itemOpt, "install", part:getItemType():get(i));
                    -- self:doMenuTooltip(part, itemOpt, "install", part:getItemType():get(i));
                    -- if not typeToItem[part:getItemType():get(i)] then
                        -- itemOpt.notAvailable = true;
                        
                        
                        
                    -- else
                        -- display every item the player posess
                        -- local subMenuItem = ISContextMenu:getNew(subMenu);
                        -- self.context:addSubMenu(itemOpt, subMenuItem);
                        
                        -- local itemOpt = subMenuItem:addOption(item:getDisplayName() .. " (" .. item:getCondition() .. "%)", playerObj, ISBoatPartMenu.onInstallPart, part, item);
                        -- self:doMenuTooltip(part, itemOpt, "install", part:getItemType():get(i));
                        
                    -- end
                    end
                end
            end
        end
    end
    
--[[
    if ((part:getId() == "HeadlightLeft") or (part:getId() == "HeadlightRight")) and part:getInventoryItem() then
        if part:getLight():canFocusingUp() and self.character:getPerkLevel(Perks.Mechanics) >= part:getVehicle():getScript():getHeadlightConfigLevel() then
        --if part:getLight():canFocusingUp() and self.character:getInventory():contains("Spanner") then
            option = self.context:addOption(getText("IGUI_HeadlightFocusingUp"), playerObj, ISBoatMechanics.onConfigHeadlight, part, 1);
            self:doMenuTooltip(part, option, "configheadlight");
        else
            option = self.context:addOption(getText("IGUI_HeadlightFocusingUp"), nil, nil);
            self:doMenuTooltip(part, option, "configheadlight");
            option.notAvailable = true;
        end
        if part:getLight():canFocusingDown() and self.character:getPerkLevel(Perks.Mechanics) >= part:getVehicle():getScript():getHeadlightConfigLevel() then
        --if part:getLight():canFocusingDown() and self.character:getInventory():contains("Spanner") then
            option = self.context:addOption(getText("IGUI_HeadlightFocusingDown"), playerObj, ISBoatMechanics.onConfigHeadlight, part, -1);
            self:doMenuTooltip(part, option, "configheadlight");
        else
            option = self.context:addOption(getText("IGUI_HeadlightFocusingDown"), nil, nil);
            self:doMenuTooltip(part, option, "configheadlight");
            option.notAvailable = true;
        end
    end
--]]
    if ISVehicleMechanics.cheat or playerObj:getAccessLevel() ~= "None" then
        if self.vehicle:getPartById("Engine") then
            option = self.context:addOption("CHEAT: Get Key", playerObj, ISBoatMechanics.onCheatGetKey, self.vehicle)
            if self.vehicle:isHotwired() then
                self.context:addOption("CHEAT: Remove Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, false, false)
                --[[
                if self.vehicle:isHotwiredBroken() then
                    self.context:addOption("CHEAT: Fix Broken Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, true, false)
                else
                    self.context:addOption("CHEAT: Break Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, true, true)
                end
                --]]
            else
                self.context:addOption("CHEAT: Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, true, false)
            end
        end
        option = self.context:addOption("CHEAT: Repair Part", playerObj, ISBoatMechanics.onCheatRepairPart, part)
        option = self.context:addOption("CHEAT: Repair Vehicle", playerObj, ISBoatMechanics.onCheatRepair, self.vehicle)
        option = self.context:addOption("CHEAT: Set Rust", playerObj, ISBoatMechanics.onCheatSetRust, self.vehicle)
        option = self.context:addOption("CHEAT: Set Part Condition", playerObj, ISBoatMechanics.onCheatSetCondition, part)
        if part:isContainer() and part:getContainerContentType() then
            option = self.context:addOption("CHEAT: Set Content Amount", playerObj, ISBoatMechanics.onCheatSetContentAmount, part)
        end
        option = self.context:addOption("CHEAT: Remove Vehicle", playerObj, ISBoatMechanics.onCheatRemove, self.vehicle)
    end
    if getDebug() then
        if ISVehicleMechanics.cheat then
            self.context:addOption("DBG: ISVehicleMechanics.cheat=false", playerObj, ISBoatMechanics.onCheatToggle)
        else
            self.context:addOption("DBG: ISVehicleMechanics.cheat=true", playerObj, ISBoatMechanics.onCheatToggle)
        end
    end
    
    if self.context.numOptions == 1 then self.context:setVisible(false) end
    
    if JoypadState.players[self.playerNum+1] and self.context:getIsVisible() then
        self.context.mouseOver = 1
        self.context.origin = self
        JoypadState.players[self.playerNum+1].focus = self.context
        updateJoypadFocus(JoypadState.players[self.playerNum+1])
    end
end

function ISBoatMechanics.onRepairEngine(playerObj, part)
    -- if playerObj:getVehicle() then
        -- ISVehicleMenu.onExit(playerObj)
    -- end
    
    local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
    local item = typeToItem["Base.Wrench"][1]
    ISBoatPartMenu.toPlayerInventory(playerObj, item)
    
    -- ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
    
    local engineCover = nil
    local doorPart = part:getVehicle():getPartById("EngineDoor")
    if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() and not doorPart:getDoor():isOpen() then
        engineCover = doorPart
    end
    
    local time = 300;
    ISTimedActionQueue.add(ISRepairBoatEngine:new(playerObj, part, item, time))
    -- if engineCover then
        -- -- The hood is magically unlocked if any door/window is broken/open/uninstalled.
        -- -- If the player can get in the vehicle, they can pop the hood, no key required.
        -- if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(engineCover, playerObj) then
            -- ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, engineCover))
        -- end
        -- ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
        -- ISTimedActionQueue.add(ISRepairEngine:new(playerObj, part, item, time))
        -- ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    -- else
        -- ISTimedActionQueue.add(ISRepairEngine:new(playerObj, part, item, time))
    -- end
end

function ISBoatMechanics.onTakeEngineParts(playerObj, part)
    -- if playerObj:getVehicle() then
        -- ISVehicleMenu.onExit(playerObj)
    -- end
    
    local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
    local item = typeToItem["Base.Wrench"][1]
    ISBoatPartMenu.toPlayerInventory(playerObj, item)
    
    -- ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
    
    local engineCover = nil
    local doorPart = part:getVehicle():getPartById("EngineDoor")
    if doorPart and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
        engineCover = doorPart
    end
    
    local time = 300;
    if engineCover then
        -- The hood is magically unlocked if any door/window is broken/open/uninstalled.
        -- If the player can get in the vehicle, they can pop the hood, no key required.
        if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(part, playerObj) then
            ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, engineCover))
        end
        ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
        ISTimedActionQueue.add(ISTakeEngineParts:new(playerObj, part, item, time))
        ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    else
        ISTimedActionQueue.add(ISTakeEngineParts:new(playerObj, part, item, time))
    end
end

-- function ISBoatMechanics.onConfigHeadlight(playerObj, part, dir)
    -- if ISVehicleMechanics.cheat then
        -- local time = 1
        -- ISTimedActionQueue.add(ISConfigHeadlight:new(playerObj, part, dir, time))
        -- return
    -- end

    -- if playerObj:getVehicle() then
        -- ISVehicleMenu.onExit(playerObj)
    -- end
    
    -- ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
    
    -- local engineCover = nil
    -- local doorPart = part:getVehicle():getPartById("EngineDoor")
    -- if doorPart and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
        -- engineCover = doorPart
    -- end
    
    -- local time = 300;
    -- if engineCover then
        -- if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(part, playerObj) then
            -- ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, engineCover))
        -- end
        -- ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
        -- ISTimedActionQueue.add(ISConfigHeadlight:new(playerObj, part, dir, time))
        -- ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    -- else
        -- ISTimedActionQueue.add(ISConfigHeadlight:new(playerObj, part, dir, time))
    -- end
-- end

function ISBoatMechanics.onCheatGetKey(playerObj, vehicle)
    sendClientCommand(playerObj, "vehicle", "getKey", { vehicle = vehicle:getId() })
end

function ISBoatMechanics.onCheatHotwire(playerObj, vehicle, hotwired, broken)
    sendClientCommand(playerObj, "vehicle", "cheatHotwire", { vehicle = vehicle:getId(), hotwired = hotwired, broken = broken })
end

function ISBoatMechanics.onCheatRepair(playerObj, vehicle)
    sendClientCommand(playerObj, "vehicle", "repair", { vehicle = vehicle:getId() })
end

function ISBoatMechanics.onCheatSetRustAux(target, button, playerObj, vehicle)
    if button.internal ~= "OK" then return end
    local text = button.parent.entry:getText()
    local rust = tonumber(text)
    if not rust then return end
    rust = math.max(rust, 0.0)
    rust = math.min(rust, 1.0)
    sendClientCommand(playerObj, "vehicle", "setRust", { vehicle = vehicle:getId(), rust = rust })
end

function ISBoatMechanics.onCheatSetRust(playerObj, vehicle)
    local modal = ISTextBox:new(0, 0, 280, 180, "Rust (0-1):", tostring(vehicle:getRust()),
        nil, ISBoatMechanics.onCheatSetRustAux, playerObj:getPlayerNum(), playerObj, vehicle)
    modal:initialise()
    modal:addToUIManager()
end

function ISBoatMechanics.onCheatRepairPart(playerObj, part)
    sendClientCommand(playerObj, "vehicle", "repairPart", { vehicle = part:getVehicle():getId(), part = part:getId() })
end

function ISBoatMechanics.onCheatSetConditionAux(target, button, playerObj, part)
    if button.internal ~= "OK" then return end
    local text = button.parent.entry:getText()
    local condition = tonumber(text)
    if not condition then return end
    condition = math.max(condition, 0)
    condition = math.min(condition, 100)
    local vehicle = part:getVehicle()
    sendClientCommand(playerObj, "vehicle", "setPartCondition", { vehicle = vehicle:getId(), part = part:getId(), condition = condition })
end

function ISBoatMechanics.onCheatSetCondition(playerObj, part)
    local modal = ISTextBox:new(0, 0, 280, 180, "Condition (0-100):", tostring(part:getCondition()),
        nil, ISBoatMechanics.onCheatSetConditionAux, playerObj:getPlayerNum(), playerObj, part)
    modal:initialise()
    modal:addToUIManager()
end

function ISBoatMechanics.onCheatSetContentAmountAux(target, button, playerObj, part)
    if button.internal ~= "OK" then return end
    local text = button.parent.entry:getText()
    local amount = tonumber(text)
    if not amount then return end
    local vehicle = part:getVehicle()
    if isClient() then
        sendClientCommand(playerObj, "vehicle", "setContainerContentAmount", { vehicle = vehicle:getId(), part = part:getId(), amount = amount })
    else
        part:setContainerContentAmount(amount)
    end
end

function ISBoatMechanics.onCheatSetContentAmount(playerObj, part)
    local modal = ISTextBox:new(0, 0, 280, 180, "Content Amount:", tostring(part:getContainerContentAmount()),
        nil, ISBoatMechanics.onCheatSetContentAmountAux, playerObj:getPlayerNum(), playerObj, part)
    modal:initialise()
    modal:addToUIManager()
end

function ISBoatMechanics.onCheatRemoveAux(dummy, button, playerObj, vehicle)
    if button.internal == "NO" then return end
    if isClient() then
        sendClientCommand(playerObj, "vehicle", "remove", { vehicle = vehicle:getId() })
    else
        vehicle:permanentlyRemove()
    end
end

function ISBoatMechanics.onCheatRemove(playerObj, vehicle)
    local playerNum = playerObj:getPlayerNum()
    local modal = ISModalDialog:new(0, 0, 350, 150, getText("Remove this vehicle from the world?"),
        true, nil, ISBoatMechanics.onCheatRemoveAux, playerNum, playerObj, vehicle)
    modal:initialise()
    modal.prevFocus = getPlayerMechanicsUI(playerNum)
    modal.moveWithMouse = true
    modal:addToUIManager()
    if JoypadState.players[playerNum+1] then
        setJoypadFocus(playerNum, modal)
    end
end

function ISBoatMechanics.onCheatToggle(playerObj)
    ISVehicleMechanics.cheat = not ISVehicleMechanics.cheat
end

function ISBoatMechanics:doMenuTooltip(part, option, lua, name)
    local vehicle = part:getVehicle();
    local tooltip = ISToolTip:new();
    tooltip:initialise();
    tooltip:setVisible(false);
    tooltip.description = getText("Tooltip_craft_Needs") .. " : <LINE>";
    option.toolTip = tooltip;
    local keyvalues = part:getTable(lua);
    
    -- repair engines tooltip
    if lua == "takeengineparts" then
        local rgb = " <RGB:1,1,1>";
        local addedTxt = "";
        if part:getCondition() < 10 then
            rgb = " <RGB:1,0,0>";
            addedTxt = "/10";
            tooltip.description = tooltip.description .. rgb .. " " .. getText("Tooltip_Vehicle_EngineCondition", part:getCondition() .. addedTxt) .. " <LINE>";
        end
        rgb = " <RGB:1,1,1>";
        if self.character:getPerkLevel(Perks.Mechanics) < part:getVehicle():getScript():getEngineRepairLevel() then
            rgb = " <RGB:1,0,0>";
        end
        tooltip.description = tooltip.description .. rgb .. getText("IGUI_perks_Mechanics") .. " " .. self.character:getPerkLevel(Perks.Mechanics) .. "/" .. part:getVehicle():getScript():getEngineRepairLevel() .. " <LINE>";
        rgb = " <RGB:1,1,1>";
        local item = InventoryItemFactory.CreateItem("Base.Wrench");
        if not self.character:getInventory():contains("Wrench") then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. item:getDisplayName() .. " 0/1 <LINE>";
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. item:getDisplayName() .. " 1/1 <LINE>";
        end
        
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_TakeEnginePartsWarning");
    end
    if lua == "repairengine" then
        local rgb = " <RGB:1,1,1>";
        local addedTxt = "";
        if part:getCondition() >= 100 then
            tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_Vehicle_EngineCondition", part:getCondition()) .. " <LINE>";
        end
        rgb = " <RGB:1,1,1>";
        if self.character:getPerkLevel(Perks.Mechanics) < part:getVehicle():getScript():getEngineRepairLevel() then
            rgb = " <RGB:1,0,0>";
        end
        tooltip.description = tooltip.description .. rgb .. getText("IGUI_perks_Mechanics") .. " " .. self.character:getPerkLevel(Perks.Mechanics) .. "/" .. part:getVehicle():getScript():getEngineRepairLevel() .. " <LINE>";
        rgb = " <RGB:1,1,1>";
        local item = InventoryItemFactory.CreateItem("Base.Wrench");
        if not self.character:getInventory():contains("Wrench") then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. item:getDisplayName() .. " 0/1 <LINE>";
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. item:getDisplayName() .. " 1/1 <LINE>";
        end
        local item = InventoryItemFactory.CreateItem("Base.EngineParts");
        if not self.character:getInventory():contains("EngineParts") then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. item:getDisplayName() .. " 0/1 <LINE>";
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. item:getDisplayName() .. " <LINE>";
        end
    end
    if lua == "configheadlight" then
        local rgb = " <RGB:1,1,1>";
        tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. getText("IGUI_HeadlightFocusing") .. ": " .. part:getLight():getFocusing() .. " <LINE>";
        --tooltip.description = tooltip.description .. " <RGB:1,0,0> Destination: " .. part:getLight():getDistanization() .. " <LINE>";
        --tooltip.description = tooltip.description .. " <RGB:1,0,0> Intensity: " .. part:getLight():getIntensity() .. " <LINE>";
        --rgb = " <RGB:1,1,1>";
        --local item = InventoryItemFactory.CreateItem("Base.Spanner");
        --if not self.character:getInventory():contains("Spanner") then
        --    tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. item:getDisplayName() .. " 0/1 <LINE>";
        --else
        --    tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. item:getDisplayName() .. " 1/1 <LINE>";
        --end
        rgb = " <RGB:1,1,1>";
        if self.character:getPerkLevel(Perks.Mechanics) < part:getVehicle():getScript():getHeadlightConfigLevel() then
            rgb = " <RGB:1,0,0>";
        end
        tooltip.description = tooltip.description .. rgb .. " Mechanic Skill: " .. self.character:getPerkLevel(Perks.Mechanics) .. "/" .. part:getVehicle():getScript():getHeadlightConfigLevel() .. " <LINE>";
    end

    -- do you need the key to operate
    if VehicleUtils.RequiredKeyNotFound(part, self.character) then
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_keyRequired") .. " <LINE>";
    end
    
    if not keyvalues then return; end
    --    if not part:getInventoryItem() then return; end
    if not part:getItemType() then return; end
    local typeToItem = VehicleUtils.getItems(self.playerNum);
    -- first do items required
    if name then
        local item = InventoryItemFactory.CreateItem(name);
        if not typeToItem[name] then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. item:getDisplayName() .. " 0/1 <LINE>";
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. item:getDisplayName() .. " 1/1 <LINE>";
        end
    end
    for i,v in pairs(keyvalues.items) do
        local itemName = InventoryItemFactory.CreateItem(v.type);
        if itemName then
            itemName = itemName:getName();
        else
            itemName = v.type;
        end
        local keep = "";
        --        if v.keep then keep = "Keep "; end
        if not typeToItem[v.type] then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. keep .. itemName .. " 0/1 <LINE>";
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. keep .. itemName .. " 1/1 <LINE>";
        end
    end
    -- recipes
    if keyvalues.recipes and keyvalues.recipes ~= "" then
        for _,recipe in ipairs(keyvalues.recipes:split(";")) do
            if not self.character:isRecipeKnown(recipe) then
                tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_requireRecipe", getRecipeDisplayName(recipe)) .. " <LINE>";
            else
                tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. getText("Tooltip_vehicle_requireRecipe", getRecipeDisplayName(recipe)) .. " <LINE>";
            end
        end
    end
    -- uninstall stuff
    if keyvalues.requireUninstalled and (vehicle:getPartById(keyvalues.requireUninstalled) and vehicle:getPartById(keyvalues.requireUninstalled):getInventoryItem()) then
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_requireUnistalled", getText("IGUI_VehiclePart" .. keyvalues.requireUninstalled)) .. " <LINE>";
    end
    local seatNumber = part:getContainerSeatNumber()
    local seatOccupied = (seatNumber ~= -1) and vehicle:isSeatOccupied(seatNumber)
    if keyvalues.requireEmpty and (round(part:getContainerContentAmount(), 3) > 0 or seatOccupied) then
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_needempty", getText("IGUI_VehiclePart" .. part:getId())) .. " <LINE> ";
    end
    -- install stuff
    if keyvalues.requireInstalled then
        local split = keyvalues.requireInstalled:split(";");
        for i,v in ipairs(split) do
            if not vehicle:getPartById(v) or not vehicle:getPartById(v):getInventoryItem() then
                tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_requireInstalled", getText("IGUI_VehiclePart" .. v)) .. " <LINE>";
            end
        end
    end
    -- now required skill
    local perks = keyvalues.skills;
    if perks and perks ~= "" then
        for _,perk in ipairs(perks:split(";")) do
            local name,level = VehicleUtils.split(perk, ":")
            local rgb = " <RGB:1,1,1> ";
            tooltip.description = tooltip.description .. rgb .. getText("Tooltip_vehicle_recommendedSkill", getText("IGUI_perks_" .. name), self.character:getPerkLevel(Perks.FromString(name)) .. "/" .. level) .. " <LINE> <LINE>";
        end
    end
    -- install/uninstall success/failure chances
    local perks = keyvalues.skills;
    local success, failure = VehicleUtils.calculateInstallationSuccess(perks, self.character);
    if success < 100 and failure > 0 then
        local colorSuccess = "<GREEN>";
        if success < 65 then
            colorSuccess = "<ORANGE>";
        end
        if success < 25 then
            colorSuccess = "<RED>";
        end
        local colorFailure = "<GREEN>";
        if failure > 30 then
            colorFailure = "<ORANGE>";
        end
        if failure > 60 then
            colorFailure = "<RED>";
        end
        tooltip.description = tooltip.description .. colorSuccess .. getText("Tooltip_chanceSuccess") .. " " .. success .. "% <LINE> " .. colorFailure .. getText("Tooltip_chanceFailure") .. " " .. failure .. "%";
    end
end

-- tick
function ISBoatMechanics:doDrawItem(y, item, alt)
    if not item.item.cat then
        if item.itemindex == self.selected then
            self:drawRect(0, y, self:getWidth(), item.height, 0.1, 1.0, 1.0, 1.0);
        elseif item.itemindex == self.mouseoverselected and ((self.parent.context and not self.parent.context:isVisible()) or not self.parent.context) then
            self:drawRect(0, y, self:getWidth(), item.height, 0.05, 1.0, 1.0, 1.0);
        end
    end
    
    if item.item.cat then
        self:drawText(item.item.name, 0, y, self.parent.partCatRGB.r, self.parent.partCatRGB.g, self.parent.partCatRGB.b, self.parent.partCatRGB.a, UIFont.Medium);
        y = y + 5;
    else
        local rgb = self.parent.partRGB;
        if not item.item.part:getInventoryItem() and item.item.part:getTable("install") then
            self:drawText(item.item.name, 20, y, 1, 0, 0, 1, UIFont.Small);
        else
            self:drawText(item.item.name, 20, y, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);
            local condition = item.item.part:getCondition();
            local invItm = item.item.part:getInventoryItem();
            local condRGB = self.parent:getConditionRGB(item.item.part:getCondition());
            self:drawText(" (" .. condition .. "%)", getTextManager():MeasureStringX(UIFont.Small, item.item.name) + 22, y, condRGB.r, condRGB.g, condRGB.b, self.parent.partRGB.a, UIFont.Small)
        end
    end
    
    return y + self.itemheight;
end

-- tick
-- render the car overlay on the left based on ISBoatMechanicsOverlay
function ISBoatMechanics:renderCarOverlay()
    local scale = 1;
    if ISBoatMechanics.alphaOverlayInc then
        ISBoatMechanics.alphaOverlay = ISBoatMechanics.alphaOverlay + 0.08 * (UIManager.getMillisSinceLastRender() / 33.3);
        if ISBoatMechanics.alphaOverlay >= 1 then
            ISBoatMechanics.alphaOverlayInc = false;
            ISBoatMechanics.alphaOverlay = 1;
        end
    else
        ISBoatMechanics.alphaOverlay = ISBoatMechanics.alphaOverlay - 0.08 * (UIManager.getMillisSinceLastRender() / 33.3);
        if ISBoatMechanics.alphaOverlay <= 0 then
            ISBoatMechanics.alphaOverlayInc = true;
            ISBoatMechanics.alphaOverlay = 0;
        end
    end
    self.hidetooltip = true;
    if ISBoatMechanicsOverlay.BoatList[self.vehicle:getScriptName()] then
        local props = ISBoatMechanicsOverlay.BoatList[self.vehicle:getScriptName()];
        self:drawTextureScaledUniform(getTexture("media/ui/boats/mechanic overlay/" .. props.imgPrefix .. "base.png"), props.x, props.y, scale,1,1,1,1);
        for i=1,self.vehicle:getPartCount() do
            local part = self.vehicle:getPartByIndex(i-1)
            if ISBoatMechanicsOverlay.PartList[part:getId()] then
                local partProps = ISBoatMechanicsOverlay.PartList[part:getId()];
                local condRGB = {r=0,g=0,b=0};
                if part:getCondition() < 60 then
                    condRGB = self:getConditionRGB(part:getCondition());
                end
                if not part:getInventoryItem() and part:getTable("install")  then
                    condRGB = {r=1,g=0,b=0};
                end
                -- we can override certain texture that share same img (like rear windshield..)
                if props.PartList and props.PartList[part:getId()] then
                    partProps = props.PartList[part:getId()];
                end
                local alpha = 0.9;
                if part:getCondition() < 10 or (not part:getInventoryItem() and part:getTable("install")) then
                    alpha = ISBoatMechanics.alphaOverlay;
                end
                if not partProps.multipleImg then
                    self:drawTextureScaledUniform(getTexture("media/ui/boats/mechanic overlay/" .. props.imgPrefix .. partProps.img .. ".png"), props.x, props.y, scale,alpha,condRGB.r,condRGB.g,condRGB.b);
                else
                    for i,v in ipairs(partProps.img) do
                        self:drawTextureScaledUniform(getTexture("media/ui/boats/mechanic overlay/" .. props.imgPrefix .. v .. ".png"), props.x, props.y, scale,alpha,condRGB.r,condRGB.g,condRGB.b);
                    end
                end
                if self:renderCarOverlayTooltip(partProps, part, ISBoatMechanicsOverlay.BoatList[self.vehicle:getScriptName()].imgPrefix) then
                    self.hidetooltip = false;
                end
            end
        end
    end
    if self.hidetooltip and self.tooltip then
        self.tooltip:setVisible(false);
    end
end

function ISBoatMechanics:selectPart(part)
    if not part then return end
    for i=1,self.listbox:size() do
        local item = self.listbox.items[i]
        if item.item.part == part then
            if self.joyfocus then self:onJoypadDirLeft() end
            self.bodyworklist.selected = -1
            self.listbox.selected = i
            self.listbox:ensureVisible(i)
            return
        end
    end
    for i=1,self.bodyworklist:size() do
        local item = self.bodyworklist.items[i]
        if item.item.part == part then
            if self.joyfocus then self:onJoypadDirRight() end
            self.listbox.selected = -1
            self.bodyworklist.selected = i
            self.bodyworklist:ensureVisible(i)
            return
        end
    end
end

function ISBoatMechanics:isMouseOverPart(x, y, part)
    if not self:isMouseOver() then return false end -- other windows in front
    if not part then return false end
    local props = ISBoatMechanicsOverlay.BoatList[self.vehicle:getScriptName()]
    if not props then return end
    local partProps = ISBoatMechanicsOverlay.PartList[part:getId()]
    if not partProps then return false end
    local xTest = partProps.x
    local yTest = partProps.y
    local x2Test = partProps.x2
    local y2Test = partProps.y2
    if partProps.vehicles and partProps.vehicles[props.imgPrefix] then
        xTest = partProps.vehicles[props.imgPrefix].x
        yTest = partProps.vehicles[props.imgPrefix].y
        x2Test = partProps.vehicles[props.imgPrefix].x2
        y2Test = partProps.vehicles[props.imgPrefix].y2
    end
    if xTest and yTest and x2Test and y2Test and
            x >= xTest and x <= x2Test and y > yTest and y <= y2Test then
        return true
    end
    local option = getDebug() and getDebugOptions():getOptionByName("Mechanics.Render.Hitbox")
    if option and option:getValue() and xTest and yTest and x2Test and y2Test then
        self:drawRectBorder(xTest, yTest, x2Test-xTest, y2Test-yTest, 1.0, 0.0, 1.0, 1.0)
    end
    return false
end

function ISBoatMechanics:getMouseOverPart(x, y)
    for i=1,self.vehicle:getPartCount() do
        local part = self.vehicle:getPartByIndex(i-1)
        if self:isMouseOverPart(x, y, part) then
            return part
        end
    end
    return nil
end

function ISBoatMechanics:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self, x, y)
    local part = self:getMouseOverPart(self:getMouseX(), self:getMouseY())
    self:selectPart(part)
end

function ISBoatMechanics:onRightMouseUp(x, y)
    local playerObj = getSpecificPlayer(self.playerNum)
    local part = self:getMouseOverPart(x, y)
    self.context = nil
    if part then
        self:selectPart(part)
        self:doPartContextMenu(part, x, y)
    elseif ISVehicleMechanics.cheat or playerObj:getAccessLevel() ~= "None" then
        if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then return; end
        self.context = ISContextMenu.get(self.playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())
        if self.vehicle:getScript() and self.vehicle:getScript():getWheelCount() > 0 then
            if self.vehicle:getPartById("Engine") then
                self.context:addOption("CHEAT: Get Key", playerObj, ISBoatMechanics.onCheatGetKey, self.vehicle)
                if self.vehicle:isHotwired() then
                    self.context:addOption("CHEAT: Remove Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, false, false)
                    --[[
                    if self.vehicle:isHotwiredBroken() then
                        self.context:addOption("CHEAT: Fix Broken Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, true, false)
                    else
                        self.context:addOption("CHEAT: Break Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, true, true)
                    end
                    --]]
                else
                    self.context:addOption("CHEAT: Hotwire", playerObj, ISBoatMechanics.onCheatHotwire, self.vehicle, true, false)
                end
            end
            self.context:addOption("CHEAT: Repair Vehicle", playerObj, ISBoatMechanics.onCheatRepair, self.vehicle)
            self.context:addOption("CHEAT: Set Rust", playerObj, ISBoatMechanics.onCheatSetRust, self.vehicle)
        end
        self.context:addOption("CHEAT: Remove Vehicle", playerObj, ISBoatMechanics.onCheatRemove, self.vehicle)
    end
    if not part and getDebug() then
        if not self.context then self.context = ISContextMenu.get(self.playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY()) end
        if ISVehicleMechanics.cheat then
            self.context:addOption("DBG: ISVehicleMechanics.cheat=false", playerObj, ISBoatMechanics.onCheatToggle)
        else
            self.context:addOption("DBG: ISVehicleMechanics.cheat=true", playerObj, ISBoatMechanics.onCheatToggle)
        end
    end
end

-- render the tooltip over each part
function ISBoatMechanics:renderCarOverlayTooltip(partProps, part, carType)
    if self.context and self.context:getIsVisible() then return false; end
    if not self.tooltip then
        self.tooltip = ISToolTip:new();
        self.tooltip:initialise();
        self.tooltip:addToUIManager();
        self.tooltip.followMouse = true;
    end
    if self:isMouseOverPart(self:getMouseX(), self:getMouseY(), part) then
        self.tooltip:setVisible(true);
        self.tooltip:setName(getText("IGUI_VehiclePart" .. part:getId()));
        local inventoryItem = part:getInventoryItem()
        if (not inventoryItem and part:getTable("install")) then
            self.tooltip.description = "<RGB:1,0,0> " .. getText("IGUI_Missing");
        else
            self.tooltip.description = getText("IGUI_invpanel_Condition") .. ": " .. part:getCondition() .. "%";
            if part:getContainerContentType() then
                local text = "???"
                if part:getId() == "GasTank" and round(part:getContainerContentAmount(), 3) <= 0.1 then
                    text = getText("Tooltip_outoffuel") .. " (0 / " .. part:getContainerCapacity() .. ")"
                else
                    local contents = self:roundContainerContentAmount(part) .. " / " .. part:getContainerCapacity()
                    text = getTextOrNull("IGUI_Vehicle_ContainerCapacity_" .. part:getContainerContentType(), contents)
                    if not text then
                        text = getText("IGUI_Vehicle_ContainerCapacity_Other", part:getContainerContentType(), contents)
                    end
                end
                self.tooltip.description = self.tooltip.description .. " <LINE> " .. text
            elseif instanceof(inventoryItem, "DrainableComboItem") then
                local text = "???"
                text = getText("IGUI_invpanel_Remaining") .. ": " .. round(inventoryItem:getUsedDelta() * 100, 2) .. "%"
                self.tooltip.description = self.tooltip.description .. " <LINE> " .. text
            end
        end
        self.tooltip:bringToTop();
        return true;
    end
    return false;
end

function ISBoatMechanics:startFlashRed()
    self.flashFailure = true
    self.flashTimer = 250;
    self.flashTimerAlpha = 1;
    self.flashTimerAlphaInc = false;
end

function ISBoatMechanics:startFlashGreen()
    self.flashFailure = false
    self.flashTimer = 250;
    self.flashTimerAlpha = 1;
    self.flashTimerAlphaInc = false;
end

local ROUND_CONTENT_AMOUNT = {
    Air = 1,
    Gasoline = 3,
}

function ISBoatMechanics:roundContainerContentAmount(part)
    local amount = part:getContainerContentAmount()
    return round(amount, ROUND_CONTENT_AMOUNT[part:getContainerContentType()] or 3)
end

function ISBoatMechanics:prerender()
    ISCollapsableWindow.prerender(self)
    self:updateLayout()
end

-- tick
function ISBoatMechanics:render()
    ISCollapsableWindow.render(self)
    if self.isCollapsed then return end
    
    self:checkEngineFull();
    local fgBar = {r=0.1, g=0.5, b=0.1, a=0.5}
    --    self:drawTexture(self.texVehicle, 20, 50, 1);
    self:renderCarOverlay();
    
    -- car info rect
    local x = self.xCarTexOffset;
    local y = self:titleBarHeight() + 10;
    local lineHgt = FONT_HGT_SMALL;
    local rectWidth = self:getWidth() - self.xCarTexOffset - 10;
    local rectHgt = 5 + FONT_HGT_MEDIUM + FONT_HGT_SMALL * (5 + 1) -- +1 for the progressbar
    self:drawRectBorder(x, y, rectWidth, rectHgt, 1, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    x = x + 5;
    y = y + 5;
    local debugLine = "";
    if getCore():getDebug() then
        debugLine = " (" .. self.vehicle:getScript():getName() .. " )";
    end
    local name = getText("IGUI_VehicleName" .. self.vehicle:getScript():getName());
    if string.match(self.vehicle:getScript():getName(), "Burnt") then
        local unburnt = string.gsub(self.vehicle:getScript():getName(), "Burnt", "")
        if getTextOrNull("IGUI_VehicleName" .. unburnt) then
            name = getText("IGUI_VehicleName" .. unburnt)
        end
        name = getText("IGUI_VehicleNameBurnt", name);
    end
    self:drawTextCentre(name .. debugLine, x + (rectWidth / 2), y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Medium);
    y = y + FONT_HGT_MEDIUM;
    self:drawText(getText("Tooltip_item_BoatMechanic") .. ": " .. getText("IGUI_VehicleType_" .. self.vehicle:getScript():getMechanicType()), x, y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Small);
    y = y + lineHgt;
    self:drawText(getText("IGUI_OverallCondition") .. ": ", x, y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Small);
    self:drawText(self.generalCondition .. "%", x + getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_OverallCondition") .. ": ") + 2, y, self.generalCondRGB.r, self.generalCondRGB.g, self.generalCondRGB.b, self.partCatRGB.a, UIFont.Small);
    -- y = y + lineHgt;
    -- self:drawText(getText("IGUI_char_Weight") .. ": " .. self.vehicle:getMass(), x, y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Small);
    y = y + lineHgt;
    if self.vehicle:getPartById("Engine") then
        self:drawText(getText("IGUI_EnginePower") .. ": " .. (self.vehicle:getEnginePower()/10) .. " hp", x, y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Small);
    end
    --    y = y + lineHgt;
    --    self:drawText("Ignition :", x, y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Small);
    --    if self.checkEngine then
    --        self:drawText("Ok", x + getTextManager():MeasureStringX(UIFont.Small, "Engine :") + 2, y, 0.1, 0.9, 0.1, self.partCatRGB.a, UIFont.Small);
    --    else
    --        self:drawText("Failure", x + getTextManager():MeasureStringX(UIFont.Small, "Engine :") + 2, y, 1, 0, 0, self.partCatRGB.a, UIFont.Small);
    --    end
    y = y + lineHgt + 4;
    local actionQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
    local progress = false;
    if actionQueue and actionQueue.queue and actionQueue.queue[1] and actionQueue.queue[1].jobType and actionQueue.queue[1].jobType ~= "" then
        local progressY = 30 + rectHgt - lineHgt - 4
        self:drawProgressBar(x, progressY, rectWidth - 10, lineHgt - 2, actionQueue.queue[1]:getJobDelta(), fgBar);
        self:drawTextCentre(actionQueue.queue[1].jobType, (self.width - 12 + x) / 2, progressY - 2, 0.8, 0.8, 0.8, 1, UIFont.Small);
        y = y + lineHgt;
        progress = true;
    end
    
    if not progress and self.flashTimer > 0 then
        local progressY = 30 + rectHgt - lineHgt - 4
        self.flashTimer = self.flashTimer - 1
        if self.flashFailure then
            self:drawProgressBar(x, progressY, rectWidth - 10, lineHgt - 2, 100, {r=0.5, g=0.1, b=0.1, a=self.flashTimerAlpha});
            self:drawTextCentre(getText("IGUI_Failure"), (self.width - 12 + x) / 2, progressY- 2, 0.8, 0.8, 0.8, 1, UIFont.Small);
        else
            self:drawProgressBar(x, progressY, rectWidth - 10, lineHgt - 2, 100, {r=0.1, g=0.6, b=0.1, a=self.flashTimerAlpha});
            self:drawTextCentre(getText("IGUI_Success"), (self.width - 12 + x) / 2, progressY- 2, 0.8, 0.8, 0.8, 1, UIFont.Small);
        end
        if self.flashTimerAlphaInc then
            self.flashTimerAlpha = self.flashTimerAlpha + 0.06;
            if self.flashTimerAlpha >= 1 then self.flashTimerAlpha = 1; self.flashTimerAlphaInc = false; end
        else
            self.flashTimerAlpha = self.flashTimerAlpha - 0.06;
            if self.flashTimerAlpha <= 0 then self.flashTimerAlpha = 0; self.flashTimerAlphaInc = true; end
        end
        y = y + lineHgt;
    end
    
    -- list of parts
    x = self.xCarTexOffset;
    y = 140;
    --    self:drawText("Parts:", x, y, self.partCatRGB.r, self.partCatRGB.g, self.partCatRGB.b, self.partCatRGB.a, UIFont.Medium);
    
    local selectedPart;
    if self.listbox.items[self.listbox.selected] then
        selectedPart = self.listbox.items[self.listbox.selected].item.part;
    elseif self.bodyworklist.items[self.bodyworklist.selected] then
        selectedPart = self.bodyworklist.items[self.bodyworklist.selected].item.part;
    end
    if selectedPart then self:renderPartDetail(selectedPart); end
    
    if self.drawJoypadFocus and self.leftListHasFocus then
        local ui = self.listbox
        self:drawRectBorder(ui:getX(), ui:getY(), ui:getWidth(), ui:getHeight(), 0.4, 0.2, 1.0, 1.0);
        self:drawRectBorder(ui:getX()+1, ui:getY()+1, ui:getWidth()-2, ui:getHeight()-2, 0.4, 0.2, 1.0, 1.0);
    elseif self.drawJoypadFocus then
        local ui = self.bodyworklist
        self:drawRectBorder(ui:getX(), ui:getY(), ui:getWidth(), ui:getHeight(), 0.4, 0.2, 1.0, 1.0);
        self:drawRectBorder(ui:getX()+1, ui:getY()+1, ui:getWidth()-2, ui:getHeight()-2, 0.4, 0.2, 1.0, 1.0);
    end
end

-- tick
function ISBoatMechanics:renderPartDetail(part)
    local y = self:titleBarHeight() + 10 + FONT_HGT_MEDIUM + 5;
    local x = self.xCarTexOffset + (self.width - 10 - self.xCarTexOffset) / 2;
    local lineHgt = FONT_HGT_SMALL;
    local inventoryItem = part:getInventoryItem();
    if inventoryItem and part:getTable("install") then
        self:drawText(getText("IGUI_Item") .. ": " .. inventoryItem:getDisplayName(), x, y, 1, 1, 1, 1);
        y = y + lineHgt;
        self:drawText(getText("IGUI_char_Weight") .. ": " .. round(part:getInventoryItem():getWeight(),0), x, y, 1, 1, 1, 1);
        y = y + lineHgt;
        if instanceof(inventoryItem, "DrainableComboItem") then
            if round(inventoryItem:getUsedDelta() * 100, 2) < 5 then
                self:drawText(getText("IGUI_invpanel_Remaining") .. ": " .. round(inventoryItem:getUsedDelta() * 100, 2) .. "%", x, y, 1, 0, 0, 1);
            else
                self:drawText(getText("IGUI_invpanel_Remaining") .. ": " .. round(inventoryItem:getUsedDelta() * 100, 2) .. "%", x, y, 1, 1, 1, 1);
            end
            y = y + lineHgt;
        end
    elseif part:getItemType() and part:getTable("install") then
        self:drawText(getText("IGUI_Item") .. ": " .. getText("IGUI_Missing"), x, y, 1, 0, 0, 1);
        y = y + lineHgt;
    end
    local capacity = self:roundContainerContentAmount(part) .. " / " .. part:getContainerCapacity();
    if part:getItemContainer() then
        capacity = round(part:getItemContainer():getCapacityWeight(), 2) .. " / " .. part:getContainerCapacity(self.character);
    end
    if part:getItemType() and part:getInventoryItem() then
        if part:getId() == "GasTank" and round(part:getContainerContentAmount(), 3) <= 0.1 then
            capacity = getText("Tooltip_outoffuel") .. " (0 / " .. part:getContainerCapacity() .. ")";
            self:drawText(capacity, x, y, 1, 0, 0, 1);
            y = y + lineHgt;
        elseif part:getContainerContentType() then
            local label = getTextOrNull("IGUI_Vehicle_ContainerCapacity_" .. part:getContainerContentType(), capacity)
            if not label then
                label = getText("IGUI_Vehicle_ContainerCapacity_Other", part:getContainerContentType(), capacity)
            end
            if round(part:getContainerContentAmount(), 2) < 5 then
                self:drawText(label, x, y, 1, 0, 0, 1);
            else
                self:drawText(label, x, y, 1, 1, 1, 1);
            end
            y = y + lineHgt;
        elseif part:isContainer() then
            -- display if someone is sit on this seat
            if part:getContainerSeatNumber() > -1 and self.vehicle:isSeatOccupied(part:getContainerSeatNumber()) then
                self:drawText(getText("IGUI_Vehicle_SeatOccupied"), x, y, 1, 1, 1, 1);
            else
                self:drawText(getText("Tooltip_container_Capacity") .. ": " .. capacity, x, y, 1, 1, 1, 1);
            end
            y = y + lineHgt;
        end
        if part:getInventoryItem():getBrakeForce() > 0 then
            self:drawText(getText("IGUI_TotalBreakingForce") .. ": " .. round(self.vehicle:getBrakingForce(), 1), x, y, 1, 1, 1, 1);
            y = y + lineHgt;
        end
        if part:getInventoryItem():getEngineLoudness() > 0 then
            self:drawText(getText("Tooltip_Vehicle_EngineLoudnessMultiplier", round((1 + (100-part:getEngineLoudness()) / 100), 2)), x, y, 1, 1, 1, 1);
            y = y + lineHgt;
        end
    end
    
    local door = part:getDoor();
    if door then
        local txt = getText("UI_Yes");
        if not door:isOpen() then txt = getText("UI_No"); end
        self:drawText(getText("IGUI_Open") .. ": " .. txt, x, y, 1, 1, 1, 1);
        y = y + lineHgt;
        txt = getText("UI_Yes");
        if not door:isLocked() then txt = getText("UI_No"); end
        self:drawText(getText("IGUI_XP_Locked") .. ": " .. txt, x, y, 1, 1, 1, 1);
        y = y + lineHgt;
        txt = getText("UI_Yes");
        if not door:isLockBroken() then txt = getText("UI_No"); end
        self:drawText(getText("IGUI_LockBroken") .. ": " .. txt, x, y, 1, 1, 1, 1);
        y = y + lineHgt;
    end
    local window = part:getWindow()
    if window and window:isOpenable() then
        local txt = getText("UI_Yes");
        if not window:isOpen() then txt = getText("UI_No"); end
        self:drawText(getText("IGUI_Open") .. ": " .. txt, x, y, 1, 1, 1, 1);
        y = y + lineHgt;
    end
    if part:getModData().temperature then
        self:drawText(getText("IGUI_Temperature") .. ": " .. round(part:getModData().temperature, 2), x, y, 1, 1, 1, 1);
        y = y + lineHgt;
    end
    if part:getId() == "Engine" then
        self:drawText(getText("IGUI_Vehicle_EngineLoudness") .. part:getVehicle():getEngineLoudness(), x, y, 1, 1, 1, 1);
        y = y + lineHgt;
        self:drawText(getText("IGUI_Vehicle_EngineQuality") .. part:getVehicle():getEngineQuality(), x, y, 1, 1, 1, 1);
        y = y + lineHgt;
    end
    if part:getWheelFriction() > 0 and part:getInventoryItem() then
        self:drawText(getText("IGUI_WheelFriction") .. ": " .. round(part:getWheelFriction(), 2), x, y, 1, 1, 1, 1);
        y = y + lineHgt;
    end
    if getCore():getDebug() and part:getInventoryItem() then
        local text = "true";
        if self.character:getMechanicsItem(part:getInventoryItem():getID() .. self.vehicle:getMechanicalID() .. "1") then
            text = "false";
        end
        self:drawText("DBG: Gain XP: " .. text, x, y, 1, 1, 1, 0.5);
        y = y + lineHgt;
    end
    --        if part:getCondition() < 50 and part:getInventoryItem() then
    --            local condInfo = getText("IGUI_Vehicle_CondInfo" .. part:getId());
    --            if condInfo ~= "IGUI_Vehicle_CondInfo" .. part:getId() then
    --                self:drawText(condInfo, x, y, 1, 0, 0, 1);
    --                y = y + lineHgt;
    --            end
    --        end
    
    --        functionName = part:getLuaFunction("checkOperate")
    --        if functionName then
    --            local check = VehicleUtils.callLua(functionName, self.vehicle, part)
    --            local r,g,b,a = 1,1,1,1
    --            if not check then r,g,b,a = 1,0,0,1 end
    --            self:drawText("checkOperate = " .. tostring(check), self.partList:getRight() + 20, y, r, g, b, a)
    --            y = y + lineHgt
    --        end
    --        if part:hasModData() then
    --            local r,g,b,a = 1,1,1,1
    --            self:drawText("modData", self.partList:getRight() + 20, y, r, g, b, a)
    --            y = y + lineHgt
    --            local keys = {}
    --            for k,v in pairs(part:getModData()) do
    --                table.insert(keys, k)
    --            end
    --            table.sort(keys, function(a,b) return not string.compare(a, b) end)
    --            for _,k in ipairs(keys) do
    --                self:drawText(k .. " = " .. tostring(part:getModData()[k]), self.partList:getRight() + 40, y, r, g, b, a)
    --                y = y + lineHgt
    --            end
    --        end
end

function ISBoatMechanics:getConditionRGB(condition)
    local r = ((100 - condition) / 100) ;
    local g = (condition / 100);
    return {r = r, g = g, b = 0};
end

function ISBoatMechanics:setVisible(bVisible, joypadData)
    if self.javaObject == nil then
        self:instantiate();
    end
    
    self:setEnabled(bVisible);
    
    self.javaObject:setVisible(bVisible);
    if self.visibleTarget and self.visibleFunction then
        self.visibleFunction(self.visibleTarget, self);
    end
    
    if self.vehicle then
        self.vehicle:setActiveInBullet(bVisible);
        self.vehicle:setMechanicUIOpen(bVisible);
    end
    
    if self.tooltip then
        self.tooltip:setVisible(false);
    end
    
    if bVisible and joypadData then
        joypadData.focus = self
        updateJoypadFocus(joypadData)
    end
    
    if self.usedHood then
        if not bVisible then
            if self.character and self.vehicle and self.vehicle:isInArea(self.usedHood:getArea(), self.character) then
                ISTimedActionQueue.add(ISCloseVehicleDoor:new(self.character, self.vehicle, self.usedHood))
            end
            self.usedHood = nil
        else
            if self.character and self.vehicle then
                ISTimedActionQueue.add(ISOpenVehicleDoor:new(self.character, self.vehicle, self.usedHood))
            end
        end
    end
end

function ISBoatMechanics:close()
    self:setVisible(false)
    self:setEnabled(false);
    self:removeFromUIManager()
    local data = getPlayerData(self.playerNum)
    data.mechanicsUI = ISVehicleMechanics:new(0,0, self.character, nil);
    data.mechanicsUI:setVisible(false);
    data.mechanicsUI:setEnabled(false);
    data.mechanicsUI:initialise();
    if JoypadState.players[self.playerNum+1] then
        setJoypadFocus(self.playerNum, nil)
    end
end

function ISBoatMechanics:onListboxJoypadDirUp(listbox)
    listbox:onJoypadDirUp()
    if listbox.items[listbox.selected].item.cat then
        listbox:onJoypadDirUp()
    end
    if listbox.selected == 2 then
        listbox:ensureVisible(1)
    end
end

function ISBoatMechanics:onListboxJoypadDirDown(listbox)
    listbox:onJoypadDirDown()
    if listbox.items[listbox.selected].item.cat then
        listbox:onJoypadDirDown()
    end
    if listbox.selected == 2 then
        listbox:ensureVisible(1)
    end
end

function ISBoatMechanics:onGainJoypadFocus(joypadData)
    ISPanel.onGainJoypadFocus(self, joypadData)
    self.drawJoypadFocus = true
end

function ISBoatMechanics:onJoypadDown(button)
    if button == Joypad.AButton then
        local listbox = self.leftListHasFocus and self.listbox or self.bodyworklist
        local item = listbox.items[listbox.selected]
        if item and not item.item.cat then
            local menuX = listbox:getX() + 20
            local menuY = listbox:getY() + listbox:topOfItem(listbox.selected) + item.height + listbox:getYScroll()
            self:doPartContextMenu(item.item.part, menuX, menuY)
        end
    end
    if button == Joypad.BButton then
        self:close()
    end
end

function ISBoatMechanics:onJoypadDirUp()
    if self.leftListHasFocus then
        self:onListboxJoypadDirUp(self.listbox)
    else
        self:onListboxJoypadDirUp(self.bodyworklist)
    end
end

function ISBoatMechanics:onJoypadDirDown()
    if self.leftListHasFocus then
        self:onListboxJoypadDirDown(self.listbox)
    else
        self:onListboxJoypadDirDown(self.bodyworklist)
    end
end

function ISBoatMechanics:onJoypadDirLeft()
    if self.leftListHasFocus then return end
    self.leftListHasFocus = true
    self.rightListSelection = self.bodyworklist.selected
    self.bodyworklist.selected = -1
    self.listbox.selected = self.leftListSelection or -1
end

function ISBoatMechanics:onJoypadDirRight()
    if not self.leftListHasFocus then return end
    self.leftListHasFocus = false
    self.leftListSelection = self.listbox.selected
    self.listbox.selected = -1
    self.bodyworklist.selected = self.rightListSelection or 1
end

function ISBoatMechanics:new(x, y, character, vehicle)
    local width = 800;
    local height = 600;
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2);
        y = (getCore():getScreenHeight() / 2) - (height / 2);
    end
    local o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.minimumHeight = height
    o.character = character;
    o.playerNum = character:getPlayerNum();
    o.vehicle = vehicle;
    -- o.seat = vehicle:getSeat(character)
    o:setResizable(true);
    o.partCatRGB = {r=1;g=1;b=1;a=1};
    o.partRGB = {r=0.8;g=0.8;b=0.8;a=1};
    o.title = getText("ContextMenu_VehicleMechanics");
    o.clearStentil = false;
    --    o.borderColor = {r=1;g=1;b=1;a=1};
    o.xCarTexOffset = 300;
    o.checkEngine = true;
    --    o.texVehicle = getTexture("media/ui/vehicle/vehicle.png")
    o.leftListHasFocus = true
    o.flashFailure = false;
    o.flashTimer = 0;
    o.flashTimerAlpha = 1;
    o.flashTimerAlphaInc = false;
    o:setWantKeyEvents(true)
    return o
end

function ISBoatMechanics:isKeyConsumed(key)
    return key == Keyboard.KEY_ESCAPE or
            key == getCore():getKey("VehicleMechanics")
end

function ISBoatMechanics:onKeyRelease(key)
    if key == Keyboard.KEY_ESCAPE then
        if isPlayerDoingActionThatCanBeCancelled(self.character) then
            stopDoingActionThatCanBeCancelled(self.character)
        else
            self:close()
        end
    end
    if key == getCore():getKey("VehicleMechanics") then
        self:close();
    end
end

-- ISBoatMechanics.OnMechanicActionDone = function(character, success, vehicleId, partId, itemId, installing)
    -- if success and itemId ~= -1 then
        -- local vehicle = getVehicleById(vehicleId);
        -- if not vehicle then noise('no such vehicle ' .. vehicleId); return; end
        -- local part = vehicle:getPartById(partId);
        -- if not part then noise('no such part in vehicle ' .. partId); return; end
        -- if installing then
            -- character:addMechanicsItem(itemId .. vehicle:getMechanicalID() .. "1", part, getGameTime():getCalender():getTimeInMillis());
        -- else
            -- character:addMechanicsItem(itemId .. vehicle:getMechanicalID() .. "0", part, getGameTime():getCalender():getTimeInMillis());
        -- end
    -- end
    
    -- local ui = getPlayerMechanicsUI(character:getPlayerNum());
    -- if ui and ui:isReallyVisible() then
        -- if success then ui:startFlashGreen()
        -- else ui:startFlashRed() end
    -- end
    
    -- -- Give some exp if you fail
    -- if not success then
        -- character:getXp():AddXP(Perks.Mechanics, 1);
    -- end
-- end

-- Events.OnMechanicActionDone.Add(ISBoatMechanics.OnMechanicActionDone);
