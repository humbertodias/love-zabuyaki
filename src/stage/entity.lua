--
-- Date: 23.06.2016
--
local class = require "lib/middleclass"
local Entity = class("Entity")

function Entity:initialize()
    self.entities = {}
end

function Entity:add(e)
    --TODO refactor addArr to 1 func
    if false and type(e) == "table" then
        for i=1,#e do
            e[i].isDisabled = false
            self.entities[#self.entities+1] = e[i]
        end
    else
        e.isDisabled = false
        self.entities[#self.entities+1] = e
    end
    return e
end

function Entity:addArray(e)
    if not e then
        return self.entities
    end
    for i=1,#e do
        e[i].isDisabled = false
        self.entities[#self.entities+1] = e[i]
    end
    return self.entities
end

function Entity:sortByZIndex()
    table.sort(self.entities, function(a,b)
        if not a then
            return false
        elseif not b then
            return true
        elseif a:getZIndex() == b:getZIndex() then
            return a.id > b.id
        end
        return a:getZIndex() < b:getZIndex() end )
end

function Entity:remove(e)
    if not e then
        return flase
    end
    e.y = GLOBAL_SETTING.OFFSCREEN
    return true
end

function Entity:getByName(name)
    for _,obj in ipairs(self.entities) do
        if obj.name == name then
            return obj
        end
    end
    return nil
end

function Entity:update(dt)
    for _,obj in ipairs(self.entities) do
        obj:updateAI(dt)
        obj:update(dt)
        if obj.lifeBar then
            obj.lifeBar:update(dt)
        end
    end
    for _,obj in ipairs(self.entities) do
        obj:onHurt()
    end
    --remove inactive effects
    if self.entities[#self.entities].y >= GLOBAL_SETTING.OFFSCREEN then
        self.entities[#self.entities] = nil
    end
end

function Entity:draw(l,t,w,h)
    for _,obj in ipairs(self.entities) do
        obj:draw(l,t,w,h)
        if isDebug() and obj.shape then
            colors:set("lightBlue", nil, 50)
            obj.shape:draw()
        end
    end
    if isDebug() then
        colors:set("purple", nil, 50)
        stage.testShape:draw()
    end
end

function Entity:drawShadows(l,t,w,h)
    for i,obj in ipairs(self.entities) do
        obj:drawShadow(l,t,w,h)
    end
end

function Entity:drawReflections(l,t,w,h)
    for i,obj in ipairs(self.entities) do
        obj:drawReflection(l,t,w,h)
    end
end

function Entity:dp()
    local t = "* "
    for i,obj in pairs(self.entities) do
        if not obj then
            t = t .. i .. ":<>, "
        else
            t = t .. i .. ":" .. obj.name .. " x:" .. obj.x .. ", "
        end
    end
    dp(t)
end

return Entity
