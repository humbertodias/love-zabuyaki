print("man_template.lua loaded")

local image_w = 240 --This info can be accessed with a Love2D call
local image_h = 393 --after the image has been loaded

local function q(x,y,w,h)
	return love.graphics.newQuad(x, y, w, h, image_w, image_h)
end

return {
	serialization_version = 0.4, -- The version of this serialization process

	sprite_sheet = "res/man_template.png", -- The path to the spritesheet
	--TODO read width/height of the sheet automatically.
	sprite_name = "man_template", -- The name of the sprite

	default_frame_duration = 0.20,

	--The list with all the frames mapped to their respective animations
	--  each one can be accessed like this:
	--  mySprite.animations["idle"][1], or even
	animations = {
		center = {
			{q = q(155, 2, 41, 62), ox = 20, oy = 60, duration = 5, func = function() print("frame test") end }
		},
		stand = {
			-- q = Love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H),
			-- ox,oy pivots offsets from the top left corner of the quad
			-- duration = 0.1, func = fun
			{q = q(2, 2, 49, 62), ox = 20, oy = 61 },
			{q = q(53, 3, 49, 61), ox = 20, oy = 60 },
			{q = q(104, 4, 49, 60), ox = 20, oy = 59 },
			{q = q(53, 3, 49, 61), ox = 20, oy = 60 },
			frame_duration = 0.2
		},
		walk = { -- 1 2 3 2 1 4 5 4
			{q = q(  2, 66, 31, 63), ox = 15, oy = 62},
			{q = q( 35, 66, 32, 63), ox = 16, oy = 62},
			{q = q( 69, 67, 37, 62), ox = 17, oy = 61},
			{q = q( 35, 66, 32, 63), ox = 16, oy = 62},
			{q = q(  2, 66, 31, 63), ox = 15, oy = 62},
			{q = q(108, 66, 31, 63), ox = 15, oy = 62},
			{q = q(141, 67, 37, 62), ox = 17, oy = 61},
			{q = q(108, 66, 31, 63), ox = 15, oy = 62},
			frame_duration = 0.11
		},
		run = { -- 1 2 3 2 1 4 5 4
			{q = q(2, 200, 33, 63), ox = 14, oy = 62},
			{q = q(37, 201, 48, 61), ox = 21, oy = 61},
			{q = q(87, 202, 51, 55), ox = 24, oy = 60},
			{q = q(37, 201, 48, 61), ox = 21, oy = 61},
			{q = q(2, 200, 33, 63), ox = 14, oy = 62},
			{q = q(140, 201, 45, 58), ox = 20, oy = 61},
			{q = q(187, 202, 51, 55), ox = 23, oy = 60},
			{q = q(140, 201, 45, 58), ox = 20, oy = 61},
			frame_duration = 0.075
		},
		jumpUp = {
			{ q = q(2, 143, 35, 55), ox = 18, oy = 54 , duration = 0.2 },
			{ q = q(72, 132, 44, 66), ox = 16, oy = 60 },
			frame_duration = 5
		},
		jumpDown = {
			{ q = q(118, 131, 44, 67), ox = 16, oy = 60 },
			frame_duration = 5
		},
		duck = {
			{ q = q(2, 143, 35, 55), ox = 18, oy = 54 },
			--[[{ q = q(39, 147, 31, 51), ox = 14, oy = 50 },
			{ q = q(2, 143, 35, 55), ox = 18, oy = 54 },]]
			frame_duration = 0.2
		},
		duck0 = {
			{ q = q(2, 143, 35, 55), ox = 16, oy = 60 },
			{ q = q(39, 147, 31, 51), ox = 16, oy = 60 },
			frame_duration = 0.2
		},
		punch = {
			{q = q(2, 266, 56, 61), ox = 16, oy = 60},
			{q = q(60, 265, 51, 62), ox = 16, oy = 60},
			{q = q(113, 265, 42, 62), ox = 16, oy = 60},
			{q = q(157, 265, 51, 62), ox = 16, oy = 60},
			{q = q(113, 265, 42, 62), ox = 16, oy = 60},
		},
		kick = {
			{q = q(2, 329, 33, 62), ox = 16, oy = 60},
			{q = q(37, 329, 52, 62), ox = 16, oy = 60},
			{q = q(91, 330, 46, 61), ox = 16, oy = 60},
			{q = q(139, 331, 60, 60), ox = 16, oy = 60},
			{q = q(91, 330, 46, 61), ox = 16, oy = 60},
		},
		hurt = {
			{q = q(118, 131, 44, 67), ox = 16, oy = 60},
		},
		dead = {
			{q = q(2, 143, 35, 55), ox = 16, oy = 60},
		}
	} --offsets

} --return (end of file)
