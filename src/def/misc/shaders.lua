shaders = {kisa = {}, rick = {}, chai = {}}

local sh_swap_colors = [[
        extern number n = 1;
        extern vec4 colors[16];
        extern vec4 newColors[16];
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
            for (int i = 0; i < n; i++) {
                if(pixel == colors[i])
                    return newColors[i];
            }
        return pixel;
    }    ]]

--usage:
--local sh_player2 = love.graphics.newShader(sh_swap_colors)
--sh_player2:send("n", 3)
--sh_player2:sendColor("colors", {181, 81, 23, 255},  {122, 54, 15, 255},  {56, 27, 28, 255})
--sh_player2:sendColor("newColors", {77,111,158, 255},  {49,73,130, 255},  {28,42,73, 255})

sh_replace_3_colors = [[
        extern vec4 colors[3];
        extern vec4 newColors[3];
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
        if (pixel == colors[0])
            return newColors[0];
        if (pixel == colors[1])
            return newColors[1];
        if (pixel == colors[2])
            return newColors[2];
        return pixel;
    }    ]]

--usage:
--local sh_player2 = love.graphics.newShader(sh_replace_3_colors)
--sh_player2:sendColor("colors", {181, 81, 23, 255},  {122, 54, 15, 255},  {56, 27, 28, 255})
--sh_player2:sendColor("newColors", {77,111,158, 255},  {49,73,130, 255},  {28,42,73, 255})

sh_replace_4_colors = [[
        extern vec4 colors[4];
        extern vec4 newColors[4];
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
        if (pixel == colors[0])
            return newColors[0];
        if (pixel == colors[1])
            return newColors[1];
        if (pixel == colors[2])
            return newColors[2];
        if (pixel == colors[3])
            return newColors[3];
        return pixel;
    }    ]]

sh_noise = love.graphics.newShader([[
extern float factor = 1;
extern float addPercent = 0.1;
extern float clamp = 0.85;

// from http://www.ozone3d.net/blogs/lab/20110427/glsl-random-generator/
float rand(vec2 n)
    {
        return 0.5 + 0.5 * fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
    }

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
{
    float grey = 1 * rand(tc * factor);
    float clampedGrey = max(grey, clamp);
    vec4 noise = vec4(grey, grey, grey, 1);
    vec4 clampedNoise = vec4(clampedGrey, clampedGrey, clampedGrey, 1);
    return (Texel(tex, tc) * clampedNoise * (1 - addPercent) + noise * addPercent) * color;
}   ]])

sh_screen = love.graphics.newShader([[
        vec4 effect(vec4 colour, Image image, vec2 local, vec2 screen)
        {
            // red and green scale with proportion of screen coordinates
            vec4 screen_colour = vec4(screen.x / 512.0,
                                      screen.y / 512.0,
                                      0.0,
                                      1.0);

            return screen_colour;
        }
    ]])

sh_texture = love.graphics.newShader([[
        vec4 effect(vec4 colour, Image image, vec2 local, vec2 screen)
        {
            // red and green components scale with texture coordinates
            vec4 coord_colour = vec4(local.x, local.y, 0.0, 1.0);
            // use the appropriate pixel from the texture
            vec4 image_colour = Texel(image, local);
            // mix the two colours equally
            return mix(coord_colour, image_colour, 0.5);
        }
    ]])

sh_outline = love.graphics.newShader([[vec4 resultCol;
extern number stepSize;
number alpha;

vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
    {
        // get color of pixels:
alpha = texture2D( texture, texturePos + vec2(0,-stepSize)).a;
alpha -= texture2D( texture, texturePos + vec2(0,stepSize) ).a;

// calculate resulting color
resultCol = vec4( 1.0f, 1.0f, 1.0f, 0.5f*alpha );
// return color for current pixel
return resultCol;
}
]])

--sh_outline:send( "stepSize",{1/640,1/480} )

--Shaders
local sh_rick2 = love.graphics.newShader(sh_swap_colors)
sh_rick2:send("n", 6)
sh_rick2:sendColor("colors", -- Rick P1 colors
    {181, 81, 23, 255}, {122, 54, 15, 255}, {56, 27, 28, 255}, -- orange hoodie
    {53, 53, 53, 255}, {30, 30, 30, 255}, {15, 15, 15, 255}) -- black pants
sh_rick2:sendColor("newColors", -- Rick P2 colors
    {188, 188, 188, 255}, {130, 130, 130, 255}, {73, 73, 73, 255}, -- white hoodie
    {39, 85, 135, 255}, {24, 53, 84, 255}, {11, 24, 38, 255}) -- blue pants

local sh_rick3 = love.graphics.newShader(sh_swap_colors)
sh_rick3:send("n", 6)
sh_rick3:sendColor("colors", -- Rick P1 colors
    {181, 81, 23, 255}, {122, 54, 15, 255}, {56, 27, 28, 255}, -- orange hoodie
    {53, 53, 53, 255}, {30, 30, 30, 255}, {15, 15, 15, 255}) -- black pants
sh_rick3:sendColor("newColors", -- Rick P3 colors
    {86,135,97, 255}, {47,91,63, 255}, {24,53,35, 255},-- green hoodie
    {84,75,68, 255}, {51,45,41, 255}, {25,22,20, 255}) -- gray pants

shaders.rick[2] = sh_rick2
shaders.rick[3] = sh_rick3

local sh_chai2 = love.graphics.newShader(sh_swap_colors)
sh_chai2:send("n", 10)
sh_chai2:sendColor("colors", -- Chai P1 colors
    {220, 206, 234, 255}, {145, 137, 153, 255}, {87, 82, 91, 255}, -- gray bandages
    {224, 208, 62, 255}, {158, 145, 34, 255}, {96, 71, 19, 255}, -- yellow shirt
    {126, 54, 130, 255}, {86, 11, 86, 255}, {33, 4, 33, 255}, -- purple shorts
    {51, 22, 27, 255}) -- brown hair
sh_chai2:sendColor("newColors", -- Chai P2 colors
    {224, 208, 62, 255}, {158, 145, 34, 255}, {96, 71, 19, 255}, -- yellow bandages
    {193, 207, 244, 255}, {125, 142, 167, 255}, {65, 73, 86, 255}, -- light blue shirt
    {54, 104, 130, 255}, {11, 56, 86, 255}, {4, 21, 33, 255}, -- teal shorts
    {34, 29, 57, 255}) -- purple hair

local sh_chai3 = love.graphics.newShader(sh_swap_colors)
sh_chai3:send("n", 10)
sh_chai3:sendColor("colors", -- Chai P1 colors
    {220, 206, 234, 255}, {145, 137, 153, 255}, {87, 82, 91, 255}, -- gray bandages
    {224, 208, 62, 255}, {158, 145, 34, 255}, {96, 71, 19, 255}, -- yellow shirt
    {126, 54, 130, 255}, {86, 11, 86, 255}, {33, 4, 33, 255}, -- purple shorts
    {51, 22, 27, 255}) -- brown hair
sh_chai3:sendColor("newColors", -- Chai P3 colors
    {226, 113, 113, 255}, {193, 44, 44, 255}, {112, 19, 19, 255}, -- red bandages
    {206, 196, 185, 255}, {154, 136, 119, 255}, {92, 72, 55, 255}, -- light sepia shirt
    {53, 53, 53, 255}, {30, 30, 30, 255}, {15, 15, 15, 255}, -- black shorts
    {51, 35, 22, 255}) -- sand hair

shaders.chai[2] = sh_chai2
shaders.chai[3] = sh_chai3

return shaders