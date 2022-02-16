--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISUninstallBoatPart = ISBaseTimedAction:derive("ISUninstallBoatPart")

function ISUninstallBoatPart:isValid()
    if ISVehicleMechanics.cheat then return true; end
    return self.part:getInventoryItem() and self.vehicle:canUninstallPart(self.character, self.part)
end

--function ISUninstallBoatPart:waitToStart()
    --self.character:faceThisObject(self.vehicle)
    --return self.character:shouldBeTurning()
--end

function ISUninstallBoatPart:update()
    -- self.character:faceThisObject(self.vehicle)
    self.character:setMetabolicTarget(Metabolics.MediumWork);
end

function ISUninstallBoatPart:start()
    --if self.part:getWheelIndex() ~= -1 or self.part:getId():contains("Brake") then
    --    self:setActionAnim("VehicleWorkOnTire")
    --else
    --    self:setActionAnim("VehicleWorkOnMid")
    --end
--    self:setOverrideHandModels(nil, nil)
end

function ISUninstallBoatPart:stop()
    ISBaseTimedAction.stop(self)
end

function ISUninstallBoatPart:perform()
    local perksTable = VehicleUtils.getPerksTableForChr(self.part:getTable("install").skills, self.character)
    local args = { vehicle = self.vehicle:getId(), part = self.part:getId(),
                    perks = perksTable,
                    mechanicSkill = self.character:getPerkLevel(Perks.Mechanics),
                    contentAmount = self.part:getContainerContentAmount() }
    sendClientCommand(self.character, 'vehicle', 'uninstallPart', args)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function ISUninstallBoatPart:new(character, part, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = part:getVehicle()
    o.part = part
    o.maxTime = time - (character:getPerkLevel(Perks.Mechanics) * (time/15));
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end
    if ISVehicleMechanics.cheat then o.maxTime = 1; end
    o.jobType = getText("Tooltip_Vehicle_Uninstalling", part:getInventoryItem():getDisplayName());
    return o
end

