local class = require "lib/middleclass"
local eAI = class('eAI', AI)

local _settings = {
    thinkIntervalMin = 0.01,
    thinkIntervalMax = 0.02,
    waitBeforeActionMin = 0.1,
    waitBeforeActionMax = 0.2,
    waitChance = 0.15
}

function eAI:initialize(unit, settings)
    AI.initialize(self, unit, settings or _settings)
    -- new or overridden AI schedules
end

function eAI:selectNewSchedule(conditions)
    self.unit.b.reset()
    if not self.currentSchedule or conditions.init then
        self:setSchedule( self.SCHEDULE_INTRO )
        return
    end
    if conditions.noPlayers then
        self:setSchedule( self.SCHEDULE_WALK_OFF_THE_SCREEN )
        return
    end
    if not conditions.cannotAct then
        if conditions.canCombo then
            if conditions.canMove and conditions.tooCloseToPlayer then
                --and love.math.random() < 0.5 then --and love.math.random() < 0.5
                self:setSchedule( self.SCHEDULE_ESCAPE_BACK )
                return
            end
            self:setSchedule( self.SCHEDULE_COMBO )
            return
        end
        if conditions.canMove and (conditions.reactMediumPlayer or conditions.reactShortPlayer) then
            self:setSchedule( self.SCHEDULE_SIDE_STEP_OFFENSIVE )
            return
        end
        if conditions.faceNotToPlayer then
            self:setSchedule( self.SCHEDULE_FACE_TO_PLAYER )
            return
        end
        if self.currentSchedule ~= self.SCHEDULE_WAIT_MEDIUM and love.math.random() < self.waitChance then
            self:setSchedule( self.SCHEDULE_WAIT_MEDIUM )
            return
        end
        if conditions.canMove and conditions.wokeUp or not conditions.noTarget then
            if love.math.random() < 0.5 then
                self:setSchedule( self.SCHEDULE_WALK_CLOSE_TO_ATTACK )
            else
                self:setSchedule( self.SCHEDULE_WALK_AROUND )
            end
            return
        end
        if not conditions.dead and not conditions.cannotAct and conditions.wokeUp then
            if self.currentSchedule ~= self.SCHEDULE_STAND then
                self:setSchedule( self.SCHEDULE_STAND )
            else
                self:setSchedule( self.SCHEDULE_WAIT_MEDIUM )
            end
            return
        end
    else
        -- cannot control body
        self:setSchedule( self.SCHEDULE_RECOVER )
        return
    end
    if not self.currentSchedule then
        self:setSchedule( self.SCHEDULE_STAND )
    end
end

return eAI
