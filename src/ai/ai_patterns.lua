local AI = AI

function AI:initCommonAiSchedules()
    self.SCHEDULE_INTRO = Schedule:new({ self.initIntro, self.onIntro },
        {"wokeUp", "tooCloseToPlayer"})
    self.SCHEDULE_STAND = Schedule:new({ self.initStand },
        {"cannotAct", "wokeUp", "noTarget", "canCombo", "canDashAttack", "inAir",
          "faceNotToPlayer", "tooCloseToPlayer"})
    self.SCHEDULE_WALK_OFF_THE_SCREEN = Schedule:new({ self.ensureStanding, self.calcWalkOffTheScreenXY, self.onMove, self.onStop },
        { })
    self.SCHEDULE_WALK_CLOSE_TO_ATTACK = Schedule:new({ self.ensureStanding, self.initWalkCloser, self.onWalkToAttackRange, self.initCombo, self.onCombo },
        {"cannotAct", "inAir", "grabbed", "noTarget"})
    self.SCHEDULE_ATTACK_FROM_BACK = Schedule:new({ self.ensureStanding, self.initGetToBack, self.onGetToBack, self.initCombo, self.onCombo  },
        {"cannotAct", "inAir", "grabbed", "noTarget"})
    self.SCHEDULE_WALK_AROUND = Schedule:new({ self.ensureStanding, self.initWalkAround, self.onWalkAround },
        {"cannotAct", "inAir", "grabbed", "noTarget"})
    self.SCHEDULE_GET_TO_BACK = Schedule:new({ self.ensureStanding, self.initGetToBack, self.onGetToBack },
        {"cannotAct", "inAir", "grabbed", "noTarget"})
    self.SCHEDULE_RUN = Schedule:new({ self.ensureStanding, self.initRunToXY, self.onMoveThenNoReset },
        {"cannotAct", "noTarget", "cannotAct", "inAir"})
    self.SCHEDULE_DASH_ATTACK = Schedule:new({ self.ensureStanding, self.initDashAttack, self.waitUntilStand, self.initWaitMedium, self.onWait },
        { })
    self.SCHEDULE_RUN_DASH_ATTACK = Schedule:new({ self.ensureStanding, self.initRunToXY, self.onMoveThenDashAttack },
        { })
    self.SCHEDULE_FACE_TO_PLAYER = Schedule:new({ self.ensureHasTarget, self.initFaceToPlayer },
        {"cannotAct", "noTarget", "noPlayers"})
    self.SCHEDULE_COMBO = Schedule:new({ self.ensureStanding, self.initCombo, self.onCombo },
        {"cannotAct", "grabbed", "inAir", "noTarget", "tooFarToTarget"})
    self.SCHEDULE_RECOVER = Schedule:new({ self.waitUntilStand },
        {"noPlayers"})

    self.SCHEDULE_WAIT_SHORT = Schedule:new({ self.initWaitShort, self.onWait },
        {"tooCloseToPlayer"})
    self.SCHEDULE_WAIT_MEDIUM = Schedule:new({ self.initWaitMedium, self.onWait },
        {"tooCloseToPlayer"})
    self.SCHEDULE_WAIT_LONG = Schedule:new({ self.initWaitLong, self.onWait },
        {"tooCloseToPlayer"})
    self.SCHEDULE_ESCAPE_BACK = Schedule:new({ self.calcEscapeBackXY, self.onMove },
        {"cannotAct", "grabbed", "inAir", "noTarget"})
    self.SCHEDULE_STEP_BACK = Schedule:new({ self.calcStepBack, self.onMove },
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_STEP_DOWN = Schedule:new({ self.calcStepDown, self.onMove },
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_STEP_FORWARD = Schedule:new({ self.calcStepForward, self.onMove },
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_STEP_UP = Schedule:new({ self.calcStepUp, self.onMove },
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_RANDOM = Schedule:new({ self.calcWalkRandom, self.onMove },
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_BY_TARGET_H = Schedule:new({ self.ensureHasTarget, self.calcWalkByTargetHorizontally, self.onMove },
        {"cannotAct", "grabbed", "inAir", "noTarget", "canCombo"})
    self.SCHEDULE_WALK_BY_TARGET_V = Schedule:new({ self.ensureHasTarget, self.calcWalkByTargetVertically, self.onMove },
        {"cannotAct", "grabbed", "inAir", "noTarget", "canCombo"})
    self.SCHEDULE_STRAIGHT_JUMP = Schedule:new({ self.ensureStanding, self.emulateJumpPress, self.initWaitShort, self.onWait, self.emulateReleaseJump},
        {"grabbed"})
    self.SCHEDULE_DANCE = Schedule:new({ self.ensureStanding, self.initDance, self.initWaitLong, self.onWait},
        {"grabbed", "inAir"})
    self.SCHEDULE_WALK_TO_SHORT_DISTANCE = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.initWalkToShortDistance, self.onMove},
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_TO_MEDIUM_DISTANCE = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.initWalkToMediumDistance, self.onMove},
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_TO_LONG_DISTANCE = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.initWalkToLongDistance, self.onMove},
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_OVER_TO_SHORT_DISTANCE = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.initWalkToShortDistanceAfterEnemy, self.onMove},
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_OVER_TO_MEDIUM_DISTANCE = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.initWalkToMediumDistanceAfterEnemy, self.onMove},
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_WALK_OVER_TO_LONG_DISTANCE = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.initWalkToLongDistanceAfterEnemy, self.onMove},
        {"cannotAct", "grabbed", "inAir"})
    self.SCHEDULE_SMART_ATTACK = Schedule:new({ self.selectNewAttackSchedule },
        {})
    self.SCHEDULE_HORIZONTAL_JUMP_ATTACK = Schedule:new(
        { self.emulateHorizontalJumpPressToTarget, self.emulateWaitStart, self.emulateWait, self.emulateAttackPress, self.emulateReleaseButtons },
        {})
    self.SCHEDULE_DIAGONAL_JUMP_ATTACK = Schedule:new(
        { self.emulateDiagonalJumpPressToTarget, self.emulateWaitStart, self.emulateWait, self.emulateAttackPress, self.emulateReleaseButtons },
        {})
    self.SCHEDULE_WALK_TO_GRAB = Schedule:new({ self.ensureHasTarget, self.ensureStanding, self.calcWalkToGrabXY, self.emulateAttackHold, self.onMoveUntilGrab },
        { "grabbed", "tooFarFromPlayer", "inAir", "noTarget", "noPlayers", "cannotAct" })
    self.SCHEDULE_WALKING_SPEED_UP = Schedule:new({ self.walkingSpeedUp },
        {})
    self.SCHEDULE_WALKING_SPEED_DOWN = Schedule:new({ self.walkingSpeedDown },
        {})
end

local function getPosByAngleR(x, y, angle, r)
    return x + math.cos( angle ) * r,
    y + math.sin( angle ) * r / 2
end

function AI:initIntro()
    local u = self.unit
    u.b.reset()
    if self:canAct() then
        if u.state == "stand" or u.state == "intro" then
            return true
        end
    end
    return false
end

function AI:onIntro()
    local u = self.unit
    if not u.target then
        u:pickAttackTarget("random")
    elseif u.target.isDisabled or u.target.hp < 1 then
        u:pickAttackTarget("close")
    end
    return false
end

function AI:ensureHasTarget()
    local u = self.unit
    if not u.target then
        u:pickAttackTarget("close")
    end
    return true
end

function AI:ensureStanding()
    local u = self.unit
    if self:canAct() then
        if u.state == "intro" then
            u:setState(u.stand)
        end
        return true
    end
    return false
end

function AI:walkingSpeedUp()
    local u = self.unit
    if u:isMovementNormal() then
        u:setMovementMode("fast")
    end
    return true
end

function AI:walkingSpeedDown()
    local u = self.unit
    if u:isMovementNormal() then
        u:setMovementMode("slow")
    end
    return true
end

function AI:initStand()
    local u = self.unit
    u.b.reset()
    if self:canActAndMove() then
        assert(not u.isDisabled and u.hp > 0)
        return true
    end
    return false
end

function AI:initWaitShort()
    local u = self.unit
    u.b.reset()
    self.waitingCounter = love.math.random() * (self.waitShortMax - self.waitShortMin) + self.waitShortMin
    u.speed_x = 0
    u.speed_y = 0
    return true
end

function AI:initWaitMedium()
    local u = self.unit
    u.b.reset()
    self.waitingCounter = love.math.random() * (self.waitMediumMax - self.waitMediumMin) + self.waitMediumMin
    u.speed_x = 0
    u.speed_y = 0
    return true
end

function AI:initWaitLong()
    local u = self.unit
    u.b.reset()
    self.waitingCounter = love.math.random() * (self.waitLongMax - self.waitLongMin) + self.waitLongMin
    u.speed_x = 0
    u.speed_y = 0
    return true
end

function AI:onWait(dt)
    local u = self.unit
    self.waitingCounter = self.waitingCounter - dt
    if self.waitingCounter < 0 then
        return true
    end
    return false
end

function AI:calcWalkRandom()
    local u = self.unit
    u.b.reset()
    if not self.conditions.canMove or u.state ~= "stand" then
        return false
    end
    local leftX, rightX = stage:getCurrentWaveBounds()
    local r = (rightX - leftX) / 4
    u.ttx = u.x + love.math.random(-r, r)
    if u.ttx < leftX then
        u.ttx = leftX + love.math.random(2 * u.width)
    end
    if u.ttx > rightX then
        u.ttx = rightX - love.math.random(2 * u.width)
    end
    u.tty = u.y + love.math.random(-u.width, u.width)
    return true
end

function AI:calcWalkByTargetHorizontally()
    local u = self.unit
    u.b.reset()
    if not self.conditions.canMove or u.state ~= "stand" or not u.target then
        return false
    end
    local r = u.x - u.target.x
    if r < 0 then
        r = math.min(r, -u.target.width * 2)
        r = math.max(r, -u.target.width * 4)
    else
        r = math.max(r, u.target.width * 2)
        r = math.min(r, u.target.width * 4)
    end
    u.ttx = u.target.x - r
    u.tty = u.y
    return true
end
function AI:calcWalkByTargetVertically()
    local u = self.unit
    u.b.reset()
    if not self.conditions.canMove or u.state ~= "stand" or not u.target then
        return false
    end
    local r = u.y - u.target.y
    if r < 0 then
        r = math.min(r, -u.target.width)
        r = math.max(r, -u.target.width * 2)
    else
        r = math.max(r, u.target.width)
        r = math.min(r, u.target.width * 2)
    end
    u.ttx = u.x
    u.tty = u.target.y - r
    return true
end

local escapeBackRandomRadius = 6
function AI:calcEscapeBackXY()
    local u = self.unit
    if not self.conditions.canMove or u.state ~= "stand" then
        return false
    end
    if u.target then
        u.horizontal = u.x < u.target.x and 1 or -1
    else
        u.horizontal = -u.horizontal
    end
    u.ttx = u.x + (u.width * 3 + love.math.random(-escapeBackRandomRadius, escapeBackRandomRadius) ) * -u.horizontal
    u.tty = u.y + love.math.random(-escapeBackRandomRadius, escapeBackRandomRadius)
    return true
end

local stepDistance = 20
local stepRandomRadius = 6
function AI:calcStepUp()
    local u = self.unit
    if not self.conditions.canMove or u.state ~= "stand" then
        return false
    end
    u.ttx = u.x
    u.tty = u.y - stepDistance + love.math.random(-stepRandomRadius, stepRandomRadius)
    return true
end
function AI:calcStepDown()
    local u = self.unit
    if not self.conditions.canMove or u.state ~= "stand" then
        return false
    end
    u.ttx = u.x
    u.tty = u.y + stepDistance + love.math.random(-stepRandomRadius, stepRandomRadius)
    return true
end
function AI:calcStepBack()
    local u = self.unit
    if not self.conditions.canMove or u.state ~= "stand" then
        return false
    end
    if u.target then
        u.horizontal = u.x < u.target.x and 1 or -1
    else
        u.horizontal = -u.horizontal
    end
    u.ttx = u.x + ( stepDistance + love.math.random(-stepRandomRadius, stepRandomRadius) ) * u.horizontal
    u.tty = u.y
    return true
end
function AI:calcStepForward()
    local u = self.unit
    if not self.conditions.canMove or u.state ~= "stand" then
        return false
    end
    if u.target then
        u.horizontal = u.x < u.target.x and 1 or -1
    end
    u.ttx = u.x - ( stepDistance + love.math.random(-stepRandomRadius, stepRandomRadius) ) * u.horizontal
    u.tty = u.y
    return true
end

function AI:initRunToXY()
    local u = self.unit
    u.b.setStrafe( false )
    u.ttx, u.tty = u.target.x, u.target.y
    u.face = u.x < u.target.x and 1 or -1
    u.horizontal = u.face
    u.lastState = "walk" -- condition to start running
    u.b.setHorizontalAndVertical( signDeadzone( u.ttx - u.x, 0 ), 0 )
    u.b.doHorizontalDoubleTap( u.horizontal )
    return true
end

function AI:calcWalkOffTheScreenXY()
    local u = self.unit
    assert(not u.isDisabled and u.hp > 0)
    local tx, ty
    local walkPixels = 400
    ty = u.y + love.math.random(-1, 1) * 16
    u.horizontal = love.math.random() < 0.5 and 1 or -1
    tx = u.x + u.horizontal * walkPixels
    u.face = u.horizontal
    u.ttx, u.tty = tx, ty
    return true
end

function AI:initWalkCloser()
    local u = self.unit
    u.b.reset()
    if not u.target or u.target.hp < 1 then
        u:pickAttackTarget("close")
        if not u.target then
            return false
        end
    end
    assert(not u.isDisabled and u.hp > 0)
    return true
end

function AI:initDance()
    local u = self.unit
    u.b.reset()
    u:setState(u.intro)
    u:setSpriteIfExists("dance", "hurtHighWeak")
    return true
end

---@param distanceMin number minimal distance
---@param distanceMax number max distance
---@param toFrontOrBack number if 1 then go to the enemy, -1 pass by the enemy first
function AI:initWalkToDistance(distanceMin, distanceMax, toFrontOrBack)
    local u = self.unit
    local angle
    local maxShiftAngle = math.pi / 8
    u.horizontal = u.x < u.target.x and 1 or -1
    if u.horizontal ~= toFrontOrBack then
        angle = love.math.random() * maxShiftAngle - maxShiftAngle / 2
    else
        angle = math.pi + love.math.random() * maxShiftAngle - maxShiftAngle / 2
    end
    u.old_x = 0
    u.old_y = 0
    u.speed_x = u.walkSpeed
    u.ttx, u.tty = getPosByAngleR( u.target.x, u.target.y, angle, love.math.random(distanceMin, distanceMax))
end
function AI:initWalkToShortDistance()
    local u = self.unit
    u.b.reset()
    if not u.target then
        return false
    end
    self:initWalkToDistance(self.reactShortDistanceMax - 8, self.reactShortDistanceMax, 1)
    return true
end
function AI:initWalkToMediumDistance()
    local u = self.unit
    u.b.reset()
    if not u.target then
        return false
    end
    self:initWalkToDistance(self.reactMediumDistanceMin, self.reactMediumDistanceMax, 1)
    return true
end
function AI:initWalkToLongDistance()
    local u = self.unit
    u.b.reset()
    if not u.target then
        return false
    end
    self:initWalkToDistance(self.reactLongDistanceMin, self.reactLongDistanceMax, 1)
    return true
end
function AI:initWalkToShortDistanceAfterEnemy()
    local u = self.unit
    u.b.reset()
    if not u.target then
        return false
    end
    self:initWalkToDistance(self.reactShortDistanceMax - 8, self.reactShortDistanceMax, -1)
    return true
end
function AI:initWalkToMediumDistanceAfterEnemy()
    local u = self.unit
    u.b.reset()
    if not u.target then
        return false
    end
    self:initWalkToDistance(self.reactMediumDistanceMin, self.reactMediumDistanceMax, -1)
    return true
end
function AI:initWalkToLongDistanceAfterEnemy()
    local u = self.unit
    u.b.reset()
    if not u.target then
        return false
    end
    self:initWalkToDistance(self.reactLongDistanceMin, self.reactLongDistanceMax, -1)
    return true
end

function AI:onWalkToAttackRange()
    local horizontalToleranceGap = 4
    local verticalToleranceGap = 3
    local u = self.unit
    local attackRange = self:getShortAttackRange(u, u.target) - horizontalToleranceGap
    local v, h
    --get to the player attack range
    if u.x < u.target.x then
        h, v = signDeadzone( (u.target.x - attackRange)- u.x, horizontalToleranceGap ), signDeadzone( u.target.y - u.y, verticalToleranceGap )
    else
        h, v = signDeadzone( (u.target.x + attackRange) - u.x, horizontalToleranceGap), signDeadzone( u.target.y - u.y, verticalToleranceGap )
    end
    u.b.setHorizontalAndVertical( h, v )
    if u.x < u.target.x - horizontalToleranceGap then
        u.face = 1
    elseif u.x > u.target.x + horizontalToleranceGap then
        u.face = -1
    end
    if h == 0 and v == 0 then
        u.b.reset()
        return true
    end
    return false
end

function AI:initWalkAround()
    local u = self.unit
    --    dp("AI:initWalkAround() " .. u.name)
    if not u.target or u.target.hp < 1 then
        u:pickAttackTarget("close")
        if not u.target then
            return false
        end
    end
    u.chaseTime = 1 + love.math.random() * 2
    u.chaseRadius = self:getSafeWalkingRadius(u, u.target)
    if love.math.random() < 0.3 then    -- go to front
        u.chaseAngle = love.math.random() * math.pi / 4 - math.pi / 8
    else    -- go from back
        u.chaseAngle = math.pi - love.math.random() * math.pi / 4 - math.pi / 8
    end
    u.chaseAngleStep = (math.pi / 9) * ( love.math.random() <= 0.5 and 1 or -1 )
    u.chaseAngleLockTime = 0
    u.old_x = 0
    u.old_y = 0
    u.ttx, u.tty = getPosByAngleR( u.target.x, u.target.y, u.chaseAngle, u.chaseRadius)
    assert(not u.isDisabled and u.hp > 0)
    return true
end

function AI:onWalkAround(dt)
    local u = self.unit
    --    dp("AI:onWalkAround() ".. u.name)
    local attackRange = self:getShortAttackRange(u, u.target)
    local v, h
    if u.x == u.old_x and u.y == u.old_y and u.chaseAngleLockTime > 0.2 then
        --print(getDebugFrame(), "step STOP STUCK", u.chaseAngle)
        u.b.setHorizontalAndVertical( 0, 0 )
        u.b.reset()
        return true
    end
    h, v = signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 )
    if v == 0 and h == 0 and u.chaseAngleLockTime > 0.1 then
        -- got to the point, rotate to the next
        u.chaseAngle = u.chaseAngle + u.chaseAngleStep
        u.ttx, u.tty = getPosByAngleR( u.target.x, u.target.y, u.chaseAngle, u.chaseRadius)
        h, v = signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 )
        u.chaseAngleLockTime = 0
        --print(getDebugFrame(),v,h,u.x,u.old_x,u.y,u.old_y, u.target.x, u.target.y)
    end
    u.b.setHorizontalAndVertical( h, v )
    u.b.setStrafe( true )
    if u.chaseAngleLockTime > 0.5 then  -- face to the target
        if u.x < u.target.x - 4 then
            u.face = 1
        elseif u.x > u.target.x + 4 then
            u.face = -1
        end
    end
    u.chaseTime = u.chaseTime - dt
    u.chaseAngleLockTime = u.chaseAngleLockTime + dt
    u.chaseRadius = u.chaseRadius - dt
    u.old_x = u.x
    u.old_y = u.y
    if u.chaseTime < 0 or u.chaseRadius < attackRange then
        u.b.reset()
        --print(getDebugFrame(), "end TIME or < RADIUS", u.chaseAngle)
        return true
    end
    return false
end

function AI:initGetToBack()
    local u = self.unit
    --    dp("AI:initGetToBack() " .. u.name)
    if not u.target or u.target.hp < 1 then
        u:pickAttackTarget("close")
        if not u.target then
            return false
        end
    end
    u.chaseTime = 2 + love.math.random( 2 )
    u.chaseRadius = u.target.width * 2 + u.width * 2 - 2

    if u.target.x < u.x then
        --go to left?
        if u.target.face == -u.face then
            --go to left around the target unit
            if u.target.y < u.y then
                -- go from below
                u.chaseAngle = math.pi / 2
                u.chaseAngleStep = math.pi / 6
            else    -- go above
                u.chaseAngle = -math.pi / 2
                u.chaseAngleStep = -math.pi / 6
            end
            u.chaseAngleFinal = u.chaseAngle + u.chaseAngleStep * 3
        else
            --u r already see its back
            u.chaseAngleStep = math.pi / 9
            u.chaseAngle = 0
            u.chaseAngleFinal = u.chaseAngle
        end
    else
        --go to right?
        if u.target.face == -u.face then
            --go to right around the target unit
            if u.target.y < u.y then
                -- go from below
                u.chaseAngle = math.pi / 2
                u.chaseAngleStep = -math.pi / 6
            else    -- go above
                u.chaseAngle = -math.pi / 2
                u.chaseAngleStep = math.pi / 6
            end
            u.chaseAngleFinal = u.chaseAngle + u.chaseAngleStep * 3
        else
            --u r already see its back
            u.chaseAngleStep = math.pi / 9
            u.chaseAngle = -math.pi
            u.chaseAngleFinal = u.chaseAngle
        end
    end
    u.chaseAngleLockTime = 0
    u.old_x = 0
    u.old_y = 0
    u.ttx, u.tty = getPosByAngleR( u.target.x, u.target.y, u.chaseAngle, u.chaseRadius)
    assert(not u.isDisabled and u.hp > 0)
    return true
end

function AI:onGetToBack(dt)
    local u = self.unit
    --    dp("AI:onGetToBack() ".. u.name)
    local attackRange = self:getShortAttackRange(u, u.target)
    local v, h
    if u.x == u.old_x and u.y == u.old_y and u.chaseAngleLockTime > 0.2 then
        --print(getDebugFrame(), "step STOP STUCK", u.chaseAngle)
        u.b.setHorizontalAndVertical( 0, 0 )
        u.b.reset()
        return true
    end
    h, v = signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 )
    if v == 0 and h == 0 and u.chaseAngleLockTime > 0.1 then
        -- got to the point, rotate to the next
        if math.abs(u.chaseAngleFinal - u.chaseAngle) < 0.01 then
            u.b.reset()
            return true
        end
        u.chaseAngle = u.chaseAngle + u.chaseAngleStep
        u.ttx, u.tty = getPosByAngleR( u.target.x, u.target.y, u.chaseAngle, u.chaseRadius)
        h, v = signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 )
        u.chaseAngleLockTime = 0
    end
    u.b.setHorizontalAndVertical( h, v )
    u.b.setStrafe( true )
    if u.chaseAngleLockTime > 0.5 then  -- face to the target
        if u.x < u.target.x - 4 then
            u.face = 1
        elseif u.x > u.target.x + 4 then
            u.face = -1
        end
    end
    u.chaseTime = u.chaseTime - dt
    u.chaseAngleLockTime = u.chaseAngleLockTime + dt
    u.chaseRadius = u.chaseRadius - dt
    u.old_x = u.x
    u.old_y = u.y
    if u.chaseTime < 0 or u.chaseRadius < attackRange then
        u.b.reset()
        --print(getDebugFrame(), "end TIME or < RADIUS", u.chaseAngle)
        return true
    end
    return false
end

function AI:onMove()
    local u = self.unit
    --dp("AI:onMove() ".. u.name)
    if u.move then
        return u.move:update(0)
    else
        if u.old_x == u.x and u.old_y == u.y then
            u.b.reset()
            return true
        else
            u.b.setHorizontalAndVertical( signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 ) )
        end
        u.old_x = u.x
        u.old_y = u.y
    end
    return false
end

function AI:onMoveThenNoReset()
    local u = self.unit
    --dp("AI:onMoveThenNoReset() ".. u.name)
    if u.move then
        return u.move:update(0)
    else
        if math.abs(u.ttx - u.x ) < u.width then
            --u.b.setAttack( true )
            return true
        elseif u.target then -- correct y pos from the target
            u.b.setHorizontalAndVertical( signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.target.y - u.y, 2 ) )
        else
            u.b.setHorizontalAndVertical( signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 ) )
        end
        u.old_x = u.x
        u.old_y = u.y
    end
    return false
end

function AI:onMoveUntilGrab()
    local u = self.unit
    --dp("AI:onMoveUntilGrab() ".. u.name, u.state, u.old_x, u.old_y, u.x, u.y, u.ttx, u.tty)
    if u.move then
        return u.move:update(0)
    else
        if u.state == "grab"
            or u.target.isDisabled
            or ( u.old_x == u.x and u.old_y == u.y )
            or u.target.isGrabbed
            or u.antiStuck > 10
        then
            if u.antiStuck > 10 then -- remove
                print("ANTI STUCK")   -- remove
            end  -- remove
            print("grab trgt END?", u.name, u.state, u.target.name, u.target.isGrabbed, u.target.isDisabled)
            u.b.reset() -- release A
            u.b.attack:update(0)
            return true
        else
            u.b.setHorizontalAndVertical( signDeadzone( u.ttx - u.x, 4 ), signDeadzone( u.tty - u.y, 2 ) )
        end
        if u.state == "stand" then
            u.antiStuck = u.antiStuck + 1
        else
            if u.state ~= "combo" then
                u.old_x = u.x
                u.old_y = u.y
            end
            u.antiStuck = 0
        end
    end
    return false
end

function AI:initFaceToPlayer()
    local u = self.unit
    --    dp("AI:initFaceToPlayer() " .. u.name)
    if self:canActAndMove() then
        if not u.target then
            return false
        end
        u.face = u.x < u.target.x and 1 or -1
        u.horizontal = u.face
        return true
    end
    return false
end

function AI:waitUntilStand(dt)
    --    dp("AI:waitUntilStand() ".. u.name)
    if self:canActAndMove() then
        return true
    end
    return false
end

function AI:calcWalkToGrabXY()
    local u = self.unit
    dp("AI:calcWalkToGrabXY() " .. u.name)
    u.old_x = u.x - 10  -- update old values or the unit stucks
    u.old_y = u.y + 10
    u.antiStuck = 0
    --get to the player's side grab range
    u.ttx, u.tty = u.target.x + ( u.target.width / 2 ) * ( u.x < u.target.x and -1 or 1), u.target.y + 1
    return true
end

function AI:onStop()
    return false
end

function AI:emulateWaitStart()
    local u = self.unit
    dp("AI:emulateWaitStart() ".. u.name)
    self.hesitate = 0.1
    return true
end

function AI:emulateWait(dt)
    local u = self.unit
    self.hesitate = self.hesitate - dt
    dp("AI:emulateWait() ".. u.name)
    if self.hesitate <= 0 then
        return true
    end
    return false
end

function AI:emulateAttackPress()
    local u = self.unit
    dp("AI:emulateAttackPress() ".. u.name)
    u.b.setAttack( true )
    return true
end

function AI:emulateAttackHold()
    local u = self.unit
    dp("AI:emulateAttackHold() ".. u.name)
    u.b.setAttack( true )
    u.b.attack:update(0)
    u.b.attack:update(0)
    return true
end

function AI:emulateJumpPress()
    local u = self.unit
    dp("AI:emulateJumpPress() ".. u.name)
    u.b.setJump( true )
    return true
end

function AI:emulateArrowsToTarget()
    local u = self.unit
    dp("AI:emulateArrowsToTarget() ".. u.name)
    h, v = signDeadzone( u.target.x - u.x, 4 ), signDeadzone( u.target.y - u.y, 4 )
    u.b.setHorizontalAndVertical( h, v )
    return true
end

function AI:emulateHorizontalJumpPressToTarget()
    local u = self.unit
    dp("AI:emulateHorizontalJumpPressToTarget() ".. u.name)
    u.b.setJump( true )
    h = signDeadzone( u.target.x - u.x, 4 )
    u.b.setHorizontalAndVertical( h, 0 )
    return true
end

function AI:emulateDiagonalJumpPressToTarget()
    local u = self.unit
    dp("AI:emulateDiagonalJumpPressToTarget() ".. u.name)
    u.b.setJump( true )
    h, v = signDeadzone( u.target.x - u.x, 4 ), signDeadzone( u.target.y - u.y, 4 )
    u.b.setHorizontalAndVertical( h, v )
    return true
end

function AI:emulateReleaseJump()
    dp("AI:emulateReleaseJump() " .. self.unit.name)
    self.unit.b.setJump(false)
    return true
end

function AI:emulateReleaseButtons()
    dp("AI:emulateReleaseButtons() " .. self.unit.name)
    self.unit.b.reset()
    return true
end
