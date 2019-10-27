local spriteSheet = "res/img/char/sveta.png"
local imageWidth, imageHeight = loadSpriteSheet(spriteSheet)

local function q(x,y,w,h)
    return love.graphics.newQuad(x, y, w, h, imageWidth, imageHeight)
end
local comboSlap = function(slf, cont)
    slf:checkAndAttack(
        { x = 25, y = 32, width = 26, damage = 5, sfx = "air" },
        cont
    )
end
local comboKick = function(slf, cont)
    slf:checkAndAttack(
        { x = 26, y = 39, width = 28, damage = 10, type = "knockDown", repel_x = slf.dashFallSpeed, sfx = "air" },
        cont
) end
local dashAttack = function(slf, cont)
    slf:checkAndAttack(
        { x = 21, y = 10, width = 25, damage = 14, type = "knockDown", repel_x = slf.dashFallSpeed },
        cont
) end

return {
    serializationVersion = 0.43, -- The version of this serialization process

    spriteSheet = spriteSheet, -- The path to the spritesheet
    spriteName = "sveta", -- The name of the sprite

    delay = 0.2, -- Default delay for all animations
    hurtBox = { width = 20, height = 50 }, -- Default hurtBox for all animations
    --The list with all the frames mapped to their respective animations
    --  each one can be accessed like this:
    --  mySprite.animations["idle"][1], or even
    animations = {
        icon = {
            { q = q(57, 84, 32, 17) },
            delay = math.huge
        },
        intro = {
            { q = q(147,209,48,56), ox = 30, oy = 55 }, --duck
            delay = math.huge
        },
        stand = {
            { q = q(2,2,44,64), ox = 27, oy = 63 }, --stand 1
            { q = q(48,3,46,63), ox = 29, oy = 62, delay = 0.18 }, --stand 2
            { q = q(96,4,47,62), ox = 30, oy = 61 }, --stand 3
            { q = q(48,3,46,63), ox = 29, oy = 62, delay = 0.16 }, --stand 2
            loop = true,
            delay = 0.2
        },
        walk = {
            { q = q(2,68,44,63), ox = 27, oy = 63, delay = 0.16 }, --walk 1
            { q = q(48,69,46,63), ox = 29, oy = 62 }, --walk 2
            { q = q(96,68,47,64), ox = 30, oy = 63, delay = 0.16 }, --walk 3
            { q = q(48,3,46,63), ox = 29, oy = 62 }, --stand 2
            loop = true,
            delay = 0.2
        },
        duck = {
            { q = q(147,209,48,56), ox = 30, oy = 55 }, --duck
            delay = 0.06
        },
        sideStepUp = {
            { q = q(2,323,38,67), ox = 23, oy = 66 }, --jump
        },
        sideStepDown = {
            { q = q(2,323,38,67), ox = 23, oy = 66 }, --jump
        },
        dropDown = {
            { q = q(2,323,38,67), ox = 23, oy = 66 }, --jump
            delay = math.huge
        },
        respawn = {
            { q = q(2,323,38,67), ox = 23, oy = 66 }, --jump
            { q = q(147,209,48,56), ox = 30, oy = 55, delay = 0.6 }, --duck
            delay = math.huge
        },
        pickUp = {
            { q = q(147,209,48,56), ox = 30, oy = 55 }, --duck
            delay = 0.28
        },
        combo1 = {
            { q = q(2,392,55,64), ox = 35, oy = 63 }, --slap 1
            { q = q(59,392,72,64), ox = 34, oy = 63, func = comboSlap }, --slap 2
            { q = q(133,392,51,64), ox = 31, oy = 63 }, --slap 3
            delay = 0.067
        },
        combo2 = {
            { q = q(133,392,51,64), ox = 31, oy = 63 }, --slap 3
            { q = q(59,392,72,64), ox = 34, oy = 63, func = comboSlap }, --slap 2
            { q = q(2,392,55,64), ox = 35, oy = 63 }, --slap 1
            delay = 0.067
        },
        combo3 = {
            { q = q(2,392,55,64), ox = 35, oy = 63 }, --slap 1
            { q = q(59,392,72,64), ox = 34, oy = 63, func = comboSlap }, --slap 2
            { q = q(133,392,51,64), ox = 31, oy = 63 }, --slap 3
            delay = 0.067
        },
        combo4 = {
            { q = q(2,458,51,61), ox = 32, oy = 60, delay = 0.06 }, --high kick 1
            { q = q(55,459,81,60), ox = 38, oy = 59, func = comboKick, delay = 0.05 }, --high kick 2.1
            { q = q(138,459,76,60), ox = 38, oy = 59, delay = 0.15 }, --high kick 2.2
            { q = q(2,458,51,61), ox = 32, oy = 60 }, --high kick 1
            delay = 0.11
        },
        dashAttack = {
            { q = q(42,323,57,62), ox = 39, oy = 61 }, --dash attack 1
            { q = q(101,323,85,56), ox = 56, oy = 55, funcCont = dashAttack, delay = 0.5 }, --dash attack 2
            { q = q(42,323,57,62), ox = 39, oy = 61 }, --dash attack 1
            delay = 0.06
        },
        chargeAttack = {
            { q = q(2,458,51,61), ox = 32, oy = 60, delay = 0.06 }, --high kick 1
            { q = q(55,459,81,60), ox = 38, oy = 59, func = comboKick, delay = 0.05 }, --high kick 2.1
            { q = q(138,459,76,60), ox = 38, oy = 59, delay = 0.15 }, --high kick 2.2
            { q = q(2,458,51,61), ox = 32, oy = 60 }, --high kick 1
            delay = 0.11
        },
        hurtHighWeak = {
            { q = q(2,134,48,62), ox = 30, oy = 61 }, --hurt high 1
            { q = q(52,138,58,58), ox = 39, oy = 57, delay = 0.2 }, --hurt high 2
            { q = q(112,134,50,62), ox = 32, oy = 61, delay = 0.05 }, --hurt high 3
            delay = 0.02
        },
        hurtHighMedium = {
            { q = q(2,134,48,62), ox = 30, oy = 61 }, --hurt high 1
            { q = q(52,138,58,58), ox = 39, oy = 57, delay = 0.33 }, --hurt high 2
            { q = q(112,134,50,62), ox = 32, oy = 61, delay = 0.05 }, --hurt high 3
            delay = 0.02
        },
        hurtHighStrong = {
            { q = q(2,134,48,62), ox = 30, oy = 61 }, --hurt high 1
            { q = q(52,138,58,58), ox = 39, oy = 57, delay = 0.47 }, --hurt high 2
            { q = q(112,134,50,62), ox = 32, oy = 61, delay = 0.05 }, --hurt high 3
            delay = 0.02
        },
        hurtLowWeak = {
            { q = q(2,200,44,65), ox = 29, oy = 64 }, --hurt low 1
            { q = q(48,198,46,67), ox = 28, oy = 66, delay = 0.2 }, --hurt low 2
            { q = q(96,199,49,66), ox = 34, oy = 65, delay = 0.05 }, --hurt low 3
            delay = 0.02
        },
        hurtLowMedium = {
            { q = q(2,200,44,65), ox = 29, oy = 64 }, --hurt low 1
            { q = q(48,198,46,67), ox = 28, oy = 66, delay = 0.33 }, --hurt low 2
            { q = q(96,199,49,66), ox = 34, oy = 65, delay = 0.05 }, --hurt low 3
            delay = 0.02
        },
        hurtLowStrong = {
            { q = q(2,200,44,65), ox = 29, oy = 64 }, --hurt low 1
            { q = q(48,198,46,67), ox = 28, oy = 66, delay = 0.47 }, --hurt low 2
            { q = q(96,199,49,66), ox = 34, oy = 65, delay = 0.05 }, --hurt low 3
            delay = 0.02
        },
        fall = {
            { q = q(145,6,75,60), ox = 50, oy = 59, delay = 0.33 }, --fall 1
            { q = q(2,271,74,50), ox = 49, oy = 49, delay = 0.13 }, --fall 2
            { q = q(145,100,90,32), ox = 66, oy = 31 }, --fall 3
            delay = math.huge
        },
        fallBounce = {
            { q = q(78,288,95,33), ox = 70, oy = 29, delay = 0.06 }, --fallen
            { q = q(145,100,90,32), ox = 66, oy = 31 }, --fall 3
            delay = math.huge
        },
        fallenDead = {
            { q = q(78,288,95,33), ox = 70, oy = 29 }, --fallen
            delay = math.huge
        },
        getUp = {
            { q = q(78,288,95,33), ox = 70, oy = 29, delay = 0.4 }, --fallen
            { q = q(175,273,63,45), ox = 40, oy = 44 }, --get up
            { q = q(147,209,48,56), ox = 30, oy = 55 }, --duck
            delay = 0.22
        },
        grabbedFront = {
            { q = q(2,134,48,62), ox = 30, oy = 61 }, --hurt high 1
            { q = q(52,138,58,58), ox = 39, oy = 57 }, --hurt high 2
            delay = 0.02
        },
        grabbedBack = {
            { q = q(2,200,44,65), ox = 29, oy = 64 }, --hurt low 1
            { q = q(48,198,46,67), ox = 28, oy = 66 }, --hurt low 2
            delay = 0.02
        },
        grabbedFrames = {
            --default order should be kept: hurtLow2, hurtHigh2, \, /, upsideDown, fallen
            { q = q(48,198,46,67), ox = 28, oy = 66 }, --hurt low 2
            { q = q(52,138,58,58), ox = 39, oy = 57 }, --hurt high 2
            { q = q(145,6,75,60), ox = 50, oy = 59 }, --fall 1
            { q = q(145,6,75,60), ox = 50, oy = 59, rotate = -1.57, rx = 50, ry = -29 }, --fall 1 (rotated -90°)
            { q = q(48,198,46,67), ox = 28, oy = 66, flipV = -1 }, --hurt low 2
            { q = q(78,288,95,33), ox = 70, oy = 29 }, --fallen
            delay = math.huge
        },
        thrown = {
            --rx = ox / 2, ry = -oy / 2 for this rotation
            { q = q(145,6,75,60), ox = 50, oy = 59, rotate = -1.57, rx = 25, ry = -29, delay = 0.4 }, --fall 1 (rotated -90°)
            { q = q(145,100,90,32), ox = 66, oy = 31 }, --fall 3
            delay = math.huge
        },
    }
}
