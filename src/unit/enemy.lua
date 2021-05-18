local class = require "lib/middleclass"
local Enemy = class('Enemy', Character)

local function nop() end
local dist = dist
local rand1 = rand1

function Enemy:initialize(name, sprite, x, y, f, input)
    Character.initialize(self, name, sprite, x, y, f, input)
    self.type = "enemy"
    self.canEnemyFriendlyAttack = true --allow friendly attacks among enemies
    self.isActive = false -- can move, can think
    self.comboTimeout = 2 -- max delay to connect combo hits
    self.whichPlayerAttack = "lone" -- lone random far close weak healthy fast slow
    self.instantWakeRange = 100 -- make enemy instantly active if distance to player is less
    self.delayedWakeDelay = 3
    self.delayedWakeRange = 150 -- make enemy active if the delayedWakeDelay is over and the distance to player is less
end

function Enemy:updateAI(dt)
    if self.isDisabled then
        return
    end
    if not self.isActive then
        return
    end
    self.b.update(dt)
    Character.updateAI(self, dt)
    self.AI:update(dt)
end

function Enemy:isImmune()   --Immune to the attack?
    if Character.isImmune(self, false) then
        return true
    end
    local h = self:getDamageContext()
    if h.source.type == "enemy"
        and not (self.canEnemyFriendlyAttack and h.source.canEnemyFriendlyAttack)
    then
        self:initDamageContext()
        return true
    end
    return false
end

function Enemy:canGrab(target)
    if target.face == -self.face and self.state ~= "chargeDash" and target.state == "chargeDash" then
        return false
    end
    if target.type ~= "enemy" or (self.canEnemyFriendlyAttack and target.canEnemyFriendlyAttack) then
        return true
    end
    return false
end

function Enemy:hurtStart()
    self.isHittable = true
    self.canActTimer = getSpriteAnimationDuration(self.sprite) -- delay before the animation start
end
function Enemy:hurtUpdate(dt)
    self.comboTimer = self.comboTimer + dt -- freeze comboTimer
    self.canActTimer = self.canActTimer - dt
    if self.canActTimer >= 0 then
        self.sprite.curFrame = 1 -- show the 1st frame of the animation until canActTimer < 0
        self.sprite.elapsedTime = 0 -- Reset internal counter to prevent frame change to the 2nd
    end
    if self.sprite.isFinished then
        if self.hp <= 0 then
            self:setState(self.getUp)
        elseif self.isGrabbed then
            self:setState(self.grabbedFront)
        else
            self:setState(self.stand)
        end
    end
end
Enemy.hurt = {name = "hurt", start = Enemy.hurtStart, exit = nop, update = Enemy.hurtUpdate, draw = Character.defaultDraw}

function Enemy:onAttacker(h)
    self.AI:onHurtSwitchTarget(h.source)
    Character.onAttacker(self, h)
end
function Enemy:getMaxHp(lives)
    if (lives or self.lives) <= 1 then
        return self.maxHp
    end
    return 100
end
function Enemy:decreaseHp(damage)
    self.hp = self.hp - damage
    while self.hp <= 0 do
        self.lives = self.lives - 1
        self.hp = self:getMaxHp() + self.hp
        if self.lives <= 0 then
            self.hp = 0
            self.lives = 1  -- 1 live + 0 hp == enemy's death
            Unit.callFuncOnDeath(self)
            return
        end
    end
end
function Enemy:isFriendlyAttack(target)
    if self.canEnemyFriendlyAttack and target.canEnemyFriendlyAttack then
        return true
    end
    return false
end

function Enemy:introStart()
    self.isHittable = true
end
function Enemy:introUpdate(dt)
end
Enemy.intro = { name = "intro", start = Enemy.introStart, exit = nop, update = Enemy.introUpdate, draw = Character.defaultDraw }

function Enemy:getDistanceToClosestPlayer()
    local p = {}
    for i = 1, GLOBAL_SETTING.MAX_PLAYERS do
        local player = getRegisteredPlayer(i)
        if player and not player.isDisabled and player:isAlive() then
            p[#p +1] = {player = player, points = 0 }
        end
    end
    for i = 1, #p do
        p[i].points = dist(self.x, self.y, p[i].player.x, p[i].player.y)
    end
    table.sort(p, function(a,b)
        return a.points < b.points
    end )
    if #p < 1 then
        return 900
    end
    return p[1].points
end

---
-- @param how - "random" far close weak healthy fast slow
--
function Enemy:pickAttackTarget(target)
    if target and type(target) ~= "string" then
        if target.type == "player" and not target.isDisabled and target.hp > 0 then
            self.target = target
            return self.target
        end
        return nil
    end
    local p = {}
    for i = 1, GLOBAL_SETTING.MAX_PLAYERS do
        local player = getRegisteredPlayer(i)
        if player and not player.isDisabled and player.hp > 0 then --and player:isAlive()
            p[#p +1] = {player = player, points = 0 }
        end
    end
    if #p < 1 then
        return nil
    end
    target = target or self.whichPlayerAttack
    for i = 1, #p do
        if target == "lone" then
            p[i].points = - p[i].player.wasPickedAsTargetAt - p[1].player.id
        elseif target == "close" then
            p[i].points = -dist(self.x, self.y, p[i].player.x, p[i].player.y)
        elseif target == "far" then
            p[i].points = dist(self.x, self.y, p[i].player.x, p[i].player.y)
        elseif target == "weak" then
            if p[i].player.hp > 0 and not p[i].player.isDisabled  then
                p[i].points = -p[i].player.hp + love.math.random()
            else
                p[i].points = -1000
            end
        elseif target == "healthy" then
            if p[i].player.hp > 0 and not p[i].player.isDisabled then
                p[i].points = p[i].player.hp + love.math.random()
            else
                p[i].points = love.math.random()
            end
        elseif target == "slow" then
            p[i].points = -p[i].player.walkSpeed_x + love.math.random()
        elseif target == "fast" then
            p[i].points = p[i].player.walkSpeed_x + love.math.random()
        else -- "random"
            if not p[i].player.isDisabled then
                p[i].points = love.math.random()
            else
                p[i].points = -1000
            end
        end
    end

    table.sort(p, function(a,b)
            return a.points > b.points
    end )

    if #p < 1 then
        self.target = nil
    else
        self.target = p[1].player
        p[1].player.wasPickedAsTargetAt = stage.time
    end
    return self.target
end

function Enemy:faceToTarget(x, y)
    -- Facing towards the target
    if not self:canFall()
            and not self:isInvincible()
            and not self.isGrabbed
            and self.state ~= "run"
            and self.state ~= "dashAttack"
    then
        if not self.target and not x then
            self.face = rand1()
        elseif x or self.target.x < self.x then
            self.face = -1
        else
            self.face = 1
        end
        self.horizontal = self.face
    end
end

return Enemy
