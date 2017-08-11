local spriteSheet = "res/img/char/chai.png"
local imageWidth,imageHeight = LoadSpriteSheet(spriteSheet)

local function q(x,y,w,h)
	return love.graphics.newQuad(x, y, w, h, imageWidth, imageHeight)
end

local stepFx = function(slf, cont)
	slf:showEffect("step")
end
local grabAttack = function(slf, cont)
	--default values: 10,0,20,12, "hit", slf.vel_x
	slf:checkAndAttack(
		{ x = 8, y = 20, width = 26, damage = 9 },
		cont
	)
end
local grabAttackLast = function(slf, cont)
	slf:checkAndAttack(
		{ x = 10, y = 21, width = 26, damage = 11,
		type = "fall", velocity = slf.velocityThrow_x },
		cont
	)
end
local shoveDown = function(slf, cont)
	slf:checkAndAttack(
		{ x = 18, y = 37, width = 26, damage = 15,
        type = "fall", velocity = slf.velocityThrow_x },
		cont
	)
end
local shoveUp = function(slf, cont)
	slf:doShove(slf.velocityShove_x / 10,
		slf.velocityShove_z * 2,
		slf.horizontal, nil,
		slf.z + slf.throwStart_z)
end
local shoveBack = function(slf, cont) slf:doShove(220, 20, slf.face) end
local shoveForward = function(slf, cont)
	slf:doShove(slf.velocityShove_x * slf.velocityShoveHorizontal,
		slf.velocityShove_z * slf.velocityShoveHorizontal,
		slf.face)
end
local comboAttack1 = function(slf, cont)
	slf:checkAndAttack(
		{ x = 26, y = 28, width = 26, damage = 7, velocity = slf.vel_x, sfx = "air" },
		cont
	)
	slf.cooldownCombo = 0.4
end
local comboAttack1Forward = function(slf, cont)
	slf:checkAndAttack(
		{ x = 30, y = 21, width = 26, damage = 6, velocity = slf.vel_x, sfx = "air" },
		cont
	)
	-- Chai's teep makes him move forward
	if slf.b.vertical:getValue() ~= 0 then
		slf.vertical = slf.b.vertical:getValue()
		slf.vel_y = slf.velocityTeep_y -- reduced vertical velocity
		slf.vel_x = slf.velocityTeep_y -- reduced horizontal velocity(same as y)
	else
		slf.vel_x = slf.velocityTeep_x -- horizontal velocity
	end
	slf.cooldownCombo = 0.4
end
local comboAttack2 = function(slf, cont)
	slf:checkAndAttack(
		{ x = 28, y = 11, width = 30, damage = 10, velocity = slf.vel_x, sfx = "air" },
		cont
	)
	slf.cooldownCombo = 0.4
end
local comboAttack3 = function(slf, cont)
	slf:checkAndAttack(
		{ x = 32, y = 40, width = 38, damage = 12, velocity = slf.vel_x, sfx = "air" },
		cont
	)
	slf.cooldownCombo = 0.4
end
local comboAttack4 = function(slf, cont)
	slf:checkAndAttack(
		{ x = 28, y = 37, width = 30, damage = 14, type = "fall", velocity = slf.velocityFall_x, sfx = "air" },
		cont
	)
end
local comboAttack4NoSfx = function(slf, cont)
	--TODO check if it makes default sound still
	slf:checkAndAttack(
		{ x = 28, y = 37, width = 30, damage = 14, type = "fall", velocity = slf.velocityFall_x },
		cont
	)
end
local dashAttack1 = function(slf, cont) slf:checkAndAttack(
	{ x = 8, y = 20, width = 22, damage = 17, type = "fall", velocity = slf.velocityDashFall },
	cont
) end
local dashAttack2 = function(slf, cont) slf:checkAndAttack(
	{ x = 12, y = 28, width = 30, damage = 17, type = "fall", velocity = slf.velocityDashFall },
	cont
) end
local jumpAttackForward = function(slf, cont) slf:checkAndAttack(
	{ x = 30, y = 18, width = 25, height = 45, damage = 15, type = "fall", velocity = slf.vel_x },
	cont
) end
local jumpAttackLight = function(slf, cont) slf:checkAndAttack(
	{ x = 12, y = 21, width = 22, damage = 8, velocity = slf.vel_x },
	cont
) end
local jumpAttackStraight = function(slf, cont) slf:checkAndAttack(
	{ x = 15, y = 21, width = 25, damage = 15, type = "fall", velocity = slf.velocityFall_x },
	cont
) end
local jumpAttackRun = function(slf, cont) slf:checkAndAttack(
	{ x = 25, y = 25, width = 35, height = 50, damage = 7, velocity = slf.vel_x },
	cont
) end
local jumpAttackRunLast = function(slf, cont) slf:checkAndAttack(
	{ x = 25, y = 25, width = 35, height = 50, damage = 8, type = "fall", velocity = slf.vel_x },
	cont
) end
local defensiveSpecial = function(slf, cont) slf:checkAndAttack(
    { x = 0, y = 32, width = 75, height = 75, depth = 18, damage = 25, type = "fall", velocity = slf.vel_x },
     cont
 ) end
local defensiveSpecialRight = function(slf, cont) slf:checkAndAttack(
    { x = 5, y = 32, width = 75, height = 75, depth = 18, damage = 25, type = "fall", velocity = slf.vel_x },
     cont
 ) end
local defensiveSpecialRightMost = function(slf, cont) slf:checkAndAttack(
    { x = 10, y = 32, width = 75, height = 75, depth = 18, damage = 25, type = "fall", velocity = slf.vel_x },
     cont
 ) end
local defensiveSpecialLeft = function(slf, cont) slf:checkAndAttack(
    { x = -5, y = 32, width = 75, height = 75, depth = 18, damage = 25, type = "fall", velocity = slf.vel_x },
     cont
 ) end
local defensiveSpecialLeftMost = function(slf, cont) slf:checkAndAttack(
    { x = -10, y = 32, width = 75, height = 75, depth = 18, damage = 25, type = "fall", velocity = slf.vel_x },
     cont
 ) end

return {
	serializationVersion = 0.42, -- The version of this serialization process

	spriteSheet = spriteSheet, -- The path to the spritesheet
	spriteName = "chai", -- The name of the sprite

	delay = 0.2,	--default delay for all animations

	--The list with all the frames mapped to their respective animations
	--  each one can be accessed like this:
	--  mySprite.animations["idle"][1], or even
	animations = {
		icon  = {
			{ q = q(2, 287, 36, 17) }
		},
		intro = {
			{ q = q(43,404,39,58), ox = 23, oy = 57 }, --pickup 2
			{ q = q(2,401,39,61), ox = 23, oy = 60 }, --pickup 1
			loop = true,
			delay = 1
		},
		stand = {
			-- q = Love.graphics.newQuad( x, y, width, height, imageWidth, imageHeight),
			-- ox,oy pivots offsets from the top left corner of the quad
			-- delay = 0.1, func = func1, funcCont = func2
			{ q = q(2,2,41,64), ox = 23, oy = 63, delay = 0.25 }, --stand 1
			{ q = q(45,2,43,64), ox = 23, oy = 63 }, --stand 2
			{ q = q(90,3,43,63), ox = 23, oy = 62 }, --stand 3
			{ q = q(45,2,43,64), ox = 23, oy = 63 }, --stand 2
            loop = true,
			delay = 0.155
		},
		standHold = {
			{ q = q(2,1198,50,63), ox = 22, oy = 62, delay = 0.3 }, --stand hold 1
			{ q = q(54,1198,50,63), ox = 22, oy = 62 }, --stand hold 2
			{ q = q(106,1198,49,63), ox = 21, oy = 62, delay = 0.13 }, --stand hold 3
			{ q = q(54,1198,50,63), ox = 22, oy = 62 }, --stand hold 2
			loop = true,
			delay = 0.2
        },
		walk = {
			{ q = q(2,68,39,64), ox = 21, oy = 63 }, --walk 1
			{ q = q(43,68,39,64), ox = 21, oy = 63 }, --walk 2
			{ q = q(84,68,38,64), ox = 20, oy = 63, delay = 0.25 }, --walk 3
			{ q = q(123,68,39,64), ox = 21, oy = 63 }, --walk 4
			{ q = q(164,68,39,64), ox = 21, oy = 63 }, --walk 5
			{ q = q(205,68,38,64), ox = 20, oy = 63, delay = 0.25 }, --walk 6
            loop = true,
            delay = 0.167
		},
		walkHold = {
			{ q = q(168,1132,50,64), ox = 22, oy = 63 }, --walk hold 1
			{ q = q(157,1198,49,63), ox = 21, oy = 62 }, --walk hold 2
			{ q = q(2,1264,49,63), ox = 21, oy = 62 }, --walk hold 3
			{ q = q(53,1263,50,63), ox = 22, oy = 63 }, --walk hold 4
			{ q = q(105,1263,50,63), ox = 22, oy = 63 }, --walk hold 5
			{ q = q(157,1263,50,64), ox = 22, oy = 63 }, --walk hold 6
            loop = true,
            delay = 0.117
		},
		run = {
			{ q = q(2,134,35,64), ox = 16, oy = 63 }, --run 1
			{ q = q(39,134,50,63), ox = 26, oy = 63 }, --run 2
			{ q = q(91,134,44,64), ox = 25, oy = 63, func = stepFx }, --run 3
			{ q = q(2,200,34,64), ox = 15, oy = 63 }, --run 4
			{ q = q(38,200,49,64), ox = 24, oy = 63 }, --run 5
			{ q = q(89,200,46,63), ox = 26, oy = 63, func = stepFx }, --run 6
            loop = true,
            delay = 0.117
		},
		jump = {
			{ q = q(43,266,39,67), ox = 26, oy = 65, delay = 0.15 }, --jump up
			{ q = q(84,266,42,65), ox = 24, oy = 66 }, --jump up/top
			{ q = q(128,266,44,62), ox = 23, oy = 65, delay = 0.2 }, --jump top
			{ q = q(174,266,40,65), ox = 22, oy = 66 }, --jump down/top
			{ q = q(137,196,36,68), ox = 23, oy = 66, delay = 5 }, --jump down
			delay = 0.03
		},
		respawn = {
			{ q = q(137,196,36,68), ox = 23, oy = 66, delay = 5 }, --jump down
			{ q = q(43,404,39,58), ox = 23, oy = 57, delay = 0.5 }, --pickup 2
			{ q = q(2,401,39,61), ox = 23, oy = 60 }, --pickup 1
			delay = 0.1
		},
		duck = {
			{ q = q(2,273,39,60), ox = 22, oy = 59 }, --duck
			delay = 0.06
		},
		pickup = {
			{ q = q(2,401,39,61), ox = 23, oy = 60, delay = 0.03 }, --pickup 1
			{ q = q(43,404,39,58), ox = 23, oy = 57, delay = 0.2 }, --pickup 2
			{ q = q(2,401,39,61), ox = 23, oy = 60 }, --pickup 1
			delay = 0.05
		},
		dashAttack = {
			{ q = q(2,273,39,60), ox = 22, oy = 59, delay = 0.06 }, --duck
			{ q = q(2,722,39,65), ox = 22, oy = 64, funcCont = dashAttack1 }, --jump attack forward 1 (shifted left by 4px)
			{ q = q(2,858,45,68), ox = 26, oy = 65, funcCont = dashAttack2, delay = 0.3 }, --dash attack
			{ q = q(128,266,44,62), ox = 23, oy = 65, delay = 5 }, --jump top
			delay = 0.1
		},
		dashHold = {
			{ q = q(2,273,39,60), ox = 22, oy = 59, delay = 0.06 }, --duck
			{ q = q(181,863,48,63), ox = 26, oy = 63 }, --dash hold
		},
		dashHoldAttackH = {
			{ q = q(2,993,63,66), ox = 26, oy = 66 }, --jump attack running 1.1
			{ q = q(67,993,63,66), ox = 22, oy = 66, func = jumpAttackRun }, --jump attack running 1.2
			{ q = q(132,993,64,66), ox = 22, oy = 66 }, --jump attack running 2.1
			{ q = q(2,1061,65,66), ox = 22, oy = 66, func = jumpAttackRun }, --jump attack running 2.2
			{ q = q(69,1061,66,66), ox = 22, oy = 66 }, --jump attack running 2.3
			{ q = q(137,1061,63,66), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.1
			{ q = q(2,1129,61,67), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.2
			{ q = q(65,1129,57,67), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.3
			{ q = q(124,1129,42,67), ox = 23, oy = 66 }, --jump attack running 4
			delay = 0.02
		},
		dashHoldAttackV = {
			{ q = q(2,993,63,66), ox = 26, oy = 66 }, --jump attack running 1.1
			{ q = q(67,993,63,66), ox = 22, oy = 66, func = jumpAttackRun }, --jump attack running 1.2
			{ q = q(132,993,64,66), ox = 22, oy = 66 }, --jump attack running 2.1
			{ q = q(2,1061,65,66), ox = 22, oy = 66, func = jumpAttackRun }, --jump attack running 2.2
			{ q = q(69,1061,66,66), ox = 22, oy = 66 }, --jump attack running 2.3
			{ q = q(137,1061,63,66), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.1
			{ q = q(2,1129,61,67), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.2
			{ q = q(65,1129,57,67), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.3
			{ q = q(124,1129,42,67), ox = 23, oy = 66 }, --jump attack running 4
			delay = 0.015
		},
		defensiveSpecial = {
			{ q = q(2,1334,39,60), ox = 29, oy = 59 }, --defensive special 1
			{ q = q(43,1337,41,57), ox = 31, oy = 56, delay = 0.1 }, --defensive special 2
			{ q = q(86,1329,41,63), ox = 31, oy = 67, delay = 0.01 }, --defensive special 3
			{ q = q(86,1329,41,63), ox = 31, oy = 73 }, --defensive special 3 (6px upper)
			{ q = q(129,1329,38,65), ox = 23, oy = 81 }, --defensive special 4
			{ q = q(169,1329,39,62), ox = 23, oy = 84, funcCont = defensiveSpecial }, --defensive special 5
			{ q = q(2,1396,44,60), ox = 24, oy = 88, funcCont = defensiveSpecialRight }, --defensive special 6
			{ q = q(48,1396,57,61), ox = 25, oy = 94, funcCont = defensiveSpecialRightMost }, --defensive special 7
			{ q = q(107,1396,54,62), ox = 28, oy = 99, funcCont = defensiveSpecialRight }, --defensive special 8
			{ q = q(163,1396,46,60), ox = 27, oy = 99, funcCont = defensiveSpecial }, --defensive special 9
			{ q = q(2,1460,40,60), ox = 22, oy = 99, funcCont = defensiveSpecial }, --defensive special 10
			{ q = q(44,1460,43,60), ox = 24, oy = 99, funcCont = defensiveSpecial }, --defensive special 11
			{ q = q(89,1460,46,60), ox = 29, oy = 95, funcCont = defensiveSpecialLeft }, --defensive special 12
			{ q = q(137,1460,55,59), ox = 33, oy = 92, funcCont = defensiveSpecialLeftMost }, --defensive special 13
			{ q = q(194,1460,44,61), ox = 23, oy = 87, funcCont = defensiveSpecialLeft }, --defensive special 14
			{ q = q(2,1523,40,64), ox = 22, oy = 84 }, --defensive special 15
			{ q = q(44,1523,41,64), ox = 23, oy = 77 }, --defensive special 16
			{ q = q(44,1523,41,64), ox = 23, oy = 71 }, --defensive special 16 (6px lower)
			{ q = q(87,1524,37,63), ox = 16, oy = 62 }, --defensive special 17
			{ q = q(126,1528,38,59), ox = 15, oy = 58, delay = 0.1 }, --defensive special 18
			{ q = q(87,1524,37,63), ox = 16, oy = 62, delay = 0.08 }, --defensive special 17
			delay = 0.03
		},
		defensiveSpecialTemp = { -- TODO: Remove the "Temp" part of the name (and delete the old defensiveSpecial) once the vertical movement has been coded
			{ q = q(2,1334,39,60), ox = 29, oy = 59 }, --defensive special 1
			{ q = q(43,1337,41,57), ox = 31, oy = 56, delay = 0.1 }, --defensive special 2
			{ q = q(86,1329,41,63), ox = 31, oy = 65, delay = 0.04 }, --defensive special 3
			{ q = q(129,1329,38,65), ox = 23, oy = 66 }, --defensive special 4
			{ q = q(169,1329,39,62), ox = 23, oy = 65, funcCont = defensiveSpecial }, --defensive special 5
			{ q = q(2,1396,44,60), ox = 24, oy = 65, funcCont = defensiveSpecialRight }, --defensive special 6
			{ q = q(48,1396,57,61), ox = 25, oy = 67, funcCont = defensiveSpecialRightMost }, --defensive special 7
			{ q = q(107,1396,54,62), ox = 28, oy = 67, funcCont = defensiveSpecialRight }, --defensive special 8
			{ q = q(163,1396,46,60), ox = 27, oy = 66, funcCont = defensiveSpecial }, --defensive special 9
			{ q = q(2,1460,40,60), ox = 22, oy = 66, funcCont = defensiveSpecial }, --defensive special 10
			{ q = q(44,1460,43,60), ox = 24, oy = 67, funcCont = defensiveSpecial }, --defensive special 11
			{ q = q(89,1460,46,60), ox = 29, oy = 67, funcCont = defensiveSpecialLeft }, --defensive special 12
			{ q = q(137,1460,55,59), ox = 33, oy = 65, funcCont = defensiveSpecialLeftMost }, --defensive special 13
			{ q = q(194,1460,44,61), ox = 23, oy = 65, funcCont = defensiveSpecialLeft }, --defensive special 14
			{ q = q(2,1523,40,64), ox = 22, oy = 65 }, --defensive special 15
			{ q = q(44,1523,41,64), ox = 23, oy = 65, delay = 0.06 }, --defensive special 16
			{ q = q(87,1524,37,63), ox = 16, oy = 62 }, --defensive special 17
			{ q = q(126,1528,38,59), ox = 15, oy = 58, delay = 0.1 }, --defensive special 18
			{ q = q(87,1524,37,63), ox = 16, oy = 62, delay = 0.08 }, --defensive special 17
			delay = 0.03
		},
		combo1 = {
			{ q = q(135,2,46,64), ox = 22, oy = 63 }, --combo 1.1
			{ q = q(183,3,60,63), ox = 22, oy = 62, func = comboAttack1, delay = 0.07 }, --combo 1.2
			{ q = q(135,2,46,64), ox = 22, oy = 63 }, --combo 1.1
			delay = 0.01
		},
		combo1Forward = {
			{ q = q(2,521,56,64), ox = 23, oy = 63}, --combo forward 1.1
			{ q = q(60,521,65,64), ox = 23, oy = 63, func = comboAttack1Forward, delay = 0.09 }, --combo forward 1.2
			{ q = q(2,521,56,64), ox = 23, oy = 63, delay = 0.05 }, --combo forward 1.1
			delay = 0.01
		},
		combo2 = {
			{ q = q(127,521,41,64), ox = 19, oy = 64 }, --combo 2.1
			{ q = q(170,521,65,64), ox = 21, oy = 64, func = comboAttack2, delay = 0.1 }, --combo 2.2
			{ q = q(127,521,41,64), ox = 19, oy = 64, delay = 0.06 }, --combo 2.1
			delay = 0.015
		},
		combo3 = {
			{ q = q(127,521,41,64), ox = 19, oy = 64 }, --combo 2.1
			{ q = q(2,588,44,64), ox = 20, oy = 64 }, --combo 3.1
			{ q = q(48,589,72,63), ox = 21, oy = 63, func = comboAttack3, delay = 0.11 }, --combo 3.2
			{ q = q(2,588,44,64), ox = 20, oy = 64, delay = 0.04 }, --combo 3.1
			{ q = q(127,521,41,64), ox = 19, oy = 64, delay = 0.04 }, --combo 2.1
			delay = 0.015
		},
		combo4 = {
			{ q = q(122,587,48,65), ox = 13, oy = 64, delay = 0.02 }, --combo 4.1
			{ q = q(172,587,50,65), ox = 14, oy = 64, delay = 0.01 }, --combo 4.2
			{ q = q(2,654,59,66), ox = 14, oy = 65, func = comboAttack4 }, --combo 4.3
			{ q = q(63,659,60,61), ox = 14, oy = 60, func = comboAttack4NoSfx }, --combo 4.4
			{ q = q(125,659,59,61), ox = 14, oy = 60, func = comboAttack4NoSfx }, --combo 4.5
			{ q = q(186,659,50,61), ox = 14, oy = 60, delay = 0.09 }, --combo 4.6
			{ q = q(194,725,49,62), ox = 14, oy = 61 }, --combo 4.7
			delay = 0.03
		},
		holdAttack = {
			{ q = q(122,587,48,65), ox = 13, oy = 64, delay = 0.02 }, --combo 4.1
			{ q = q(172,587,50,65), ox = 14, oy = 64, delay = 0.01 }, --combo 4.2
			{ q = q(2,654,59,66), ox = 14, oy = 65, func = comboAttack4 }, --combo 4.3
			{ q = q(63,659,60,61), ox = 14, oy = 60, func = comboAttack4NoSfx }, --combo 4.4
			{ q = q(125,659,59,61), ox = 14, oy = 60, func = comboAttack4NoSfx }, --combo 4.5
			{ q = q(186,659,50,61), ox = 14, oy = 60, delay = 0.09 }, --combo 4.6
			{ q = q(194,725,49,62), ox = 14, oy = 61 }, --combo 4.7
			delay = 0.03
		},
		fall = {
			{ q = q(2,464,65,55), ox = 32, oy = 54 }, --falling
			delay = 5
		},
		thrown = {
            --rx = oy / 2, ry = -ox for this rotation
			{ q = q(2,464,65,55), ox = 32, oy = 54, rotate = -1.57, rx = 29, ry = -30 }, --falling
			delay = 5
		},
		getup = {
			{ q = q(69,489,67,29), ox = 37, oy = 28 }, --lying down
			{ q = q(138,466,56,53), ox = 30, oy = 51 }, --getting up
			{ q = q(43,404,39,58), ox = 23, oy = 57 }, --pickup 2
			{ q = q(2,401,39,61), ox = 23, oy = 60 }, --pickup 1
			delay = 0.2
		},
		fallen = {
			{ q = q(69,489,67,29), ox = 37, oy = 28 }, --lying down
			delay = 65
		},
		hurtHigh = {
			{ q = q(2,335,48,64), ox = 29, oy = 63 }, --hurt high 1
			{ q = q(52,335,50,64), ox = 32, oy = 63, delay = 0.2 }, --hurt high 2
			{ q = q(2,335,48,64), ox = 29, oy = 63, delay = 0.05 }, --hurt high 1
			delay = 0.02
		},
		hurtLow = {
			{ q = q(104,336,42,63), ox = 22, oy = 62 }, --hurt low 1
			{ q = q(148,338,42,61), ox = 22, oy = 60, delay = 0.2 }, --hurt low 2
			{ q = q(104,336,42,63), ox = 22, oy = 62, delay = 0.05 }, --hurt low 1
			delay = 0.02
		},
		jumpAttackForward = {
			{ q = q(2,722,39,65), ox = 18, oy = 66 }, --jump attack forward 1
			{ q = q(43,722,37,64), ox = 13, oy = 66 }, --jump attack forward 2
			{ q = q(82,722,71,64), ox = 26, oy = 66, funcCont = jumpAttackForward, delay = 5 }, --jump attack forward 3
			delay = 0.03
		},
		jumpAttackForwardEnd = {
			{ q = q(43,722,37,64), ox = 13, oy = 66, delay = 0.03 }, --jump attack forward 2
			{ q = q(2,722,39,65), ox = 18, oy = 66 }, --jump attack forward 1
			delay = 5
		},
		jumpAttackLight = {
			{ q = q(2,722,39,65), ox = 18, oy = 66 }, --jump attack forward 1
			{ q = q(43,722,37,64), ox = 13, oy = 66, funcCont = jumpAttackLight, delay = 5 }, --jump attack forward 2
			delay = 0.03
		},
		jumpAttackLightEnd = {
			{ q = q(2,722,39,65), ox = 18, oy = 66 }, --jump attack forward 1
			delay = 5
		},
		jumpAttackStraight = {
			{ q = q(2,789,42,67), ox = 26, oy = 66 }, --jump attack straight 1
			{ q = q(46,789,41,63), ox = 22, oy = 66, delay = 0.07 }, --jump attack straight 2
			{ q = q(89,789,42,61), ox = 22, oy = 66, funcCont = jumpAttackStraight, delay = 5 }, --jump attack straight 3
			delay = 0.1
		},
		jumpAttackRun = {
			{ q = q(2,993,63,66), ox = 26, oy = 66 }, --jump attack running 1.1
			{ q = q(67,993,63,66), ox = 22, oy = 66, func = jumpAttackRun }, --jump attack running 1.2
			{ q = q(132,993,64,66), ox = 22, oy = 66 }, --jump attack running 2.1
			{ q = q(2,1061,65,66), ox = 22, oy = 66, func = jumpAttackRun }, --jump attack running 2.2
			{ q = q(69,1061,66,66), ox = 22, oy = 66 }, --jump attack running 2.3
			{ q = q(137,1061,63,66), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.1
			{ q = q(2,1129,61,67), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.2
			{ q = q(65,1129,57,67), ox = 20, oy = 66, func = jumpAttackRunLast }, --jump attack running 3.3
			{ q = q(124,1129,42,67), ox = 23, oy = 66, delay = 5 }, --jump attack running 4
			delay = 0.02
		},
		jumpAttackRunEnd = {
			{ q = q(124,1129,42,67), ox = 23, oy = 66 }, --jump attack running 4
			delay = 5
		},
		sideStepUp = {
			{ q = q(133,789,44,63), ox = 23, oy = 62 }, --side step up
		},
		sideStepDown = {
			{ q = q(179,789,45,64), ox = 26, oy = 63 }, --side step down
		},
		grab = {
			{ q = q(49,862,45,64), ox = 23, oy = 63 }, --grab
		},
		grabAttack1 = {
			{ q = q(96,863,43,63), ox = 21, oy = 62 }, --grab attack 1.1
			{ q = q(141,863,38,63), ox = 16, oy = 62, func = grabAttack, delay = 0.18 }, --grab attack 1.2
			{ q = q(96,863,43,63), ox = 21, oy = 62, delay = 0.02 }, --grab attack 1.1
			delay = 0.01
		},
		grabAttack2 = {
			{ q = q(96,863,43,63), ox = 21, oy = 62 }, --grab attack 1.1
			{ q = q(141,863,38,63), ox = 16, oy = 62, func = grabAttack, delay = 0.18 }, --grab attack 1.2
			{ q = q(96,863,43,63), ox = 21, oy = 62, delay = 0.02 }, --grab attack 1.1
			delay = 0.01
		},
		grabAttack3 = {
			{ q = q(2,722,39,65), ox = 18, oy = 64 }, --jump attack forward 1
			{ q = q(43,722,37,64), ox = 13, oy = 63, func = grabAttackLast, delay = 0.18 }, --jump attack forward 2
			{ q = q(2,722,39,65), ox = 18, oy = 64, delay = 0.1 }, --jump attack forward 1
			delay = 0.02
		},
		shoveDown = {
			{ q = q(122,587,48,65), ox = 13, oy = 64, delay = 0.15 }, --combo 4.1
			{ q = q(172,587,50,65), ox = 14, oy = 64 }, --combo 4.2
			{ q = q(194,725,49,62), ox = 14, oy = 61, func = shoveDown }, --combo 4.7
			{ q = q(186,659,50,61), ox = 14, oy = 60, delay = 0.35 }, --combo 4.6
			delay = 0.05
		},
		shoveUp = {
			{ q = q(96,863,43,63), ox = 21, oy = 62, flipH = -1 }, --grab attack 1.1
			{ q = q(2,928,40,62), ox = 20, oy = 62, flipH = -1 }, --throw 1.1
			{ q = q(44,928,51,63), ox = 26, oy = 62 }, --throw 1.2
			{ q = q(97,928,53,63), ox = 22, oy = 62, func = shoveUp, delay = 0.2 }, --throw 1.3
			{ q = q(2,273,39,60), ox = 22, oy = 59, delay = 0.15 }, --duck
			delay = 0.07
		},
		shoveBack = {
			{ q = q(96,863,43,63), ox = 21, oy = 62, flipH = -1 }, --grab attack 1.1
			{ q = q(2,928,40,62), ox = 20, oy = 62, flipH = -1 }, --throw 1.1
			{ q = q(44,928,51,63), ox = 26, oy = 62, func = shoveBack }, --throw 1.2
			{ q = q(97,928,53,63), ox = 22, oy = 62, delay = 0.2 }, --throw 1.3
			{ q = q(2,273,39,60), ox = 22, oy = 59, delay = 0.15 }, --duck
			delay = 0.07,
			moves = {
				{ ox = -20, oz = 10, oy = 1, z = 0, face = -1 },
				{ ox = -10, oz = 20, z = 4 },
				{ ox = 10, oz = 30, tFace = 1, z = 8 },
				{ z = 4 },
				{ z = 2 }
			}
		},
		shoveForward = {
			{ q = q(96,863,43,63), ox = 21, oy = 62, flipH = -1 }, --grab attack 1.1
			{ q = q(96,863,43,63), ox = 21, oy = 62, flipH = -1 }, --grab attack 1.1
			{ q = q(96,863,43,63), ox = 21, oy = 62, flipH = -1 }, --grab attack 1.1
			{ q = q(2,928,40,62), ox = 20, oy = 62, flipH = -1 }, --throw 1.1
			{ q = q(44,928,51,63), ox = 26, oy = 62, func = shoveForward }, --throw 1.2
			{ q = q(97,928,53,63), ox = 22, oy = 62 }, --throw 1.3
			{ q = q(2,273,39,60), ox = 22, oy = 59 }, --duck
			delay = 0.07,
			moves = {
				{ ox = 10, oz = 5, oy = -1, z = 0 },
				{ ox = -5, oz = 10, tFace = -1, z = 0 },
				{ ox = -20, oz = 12, tFace = -1, z = 2 },
				{ ox = -10, oz = 24, tFace = -1, z = 4 },
				{ ox = 10, oz = 30, tFace = 1, z = 8 },
				{ z = 4 }
			}
		},
		grabSwap = {
			{ q = q(152,928,44,63), ox = 22, oy = 63 }, --grab swap 1.1
			{ q = q(198,928,38,59), ox = 21, oy = 63 }, --grab swap 1.2
			delay = 3
		},
		grabbedFront = {
			{ q = q(2,335,48,64), ox = 29, oy = 63 }, --hurt high 1
			{ q = q(52,335,50,64), ox = 32, oy = 63 }, --hurt high 2
			delay = 0.1
		},
		grabbedBack = {
			{ q = q(104,336,42,63), ox = 22, oy = 62 }, --hurt low 1
			{ q = q(148,338,42,61), ox = 22, oy = 60 }, --hurt low 2
			delay = 0.1
		},
	}
}