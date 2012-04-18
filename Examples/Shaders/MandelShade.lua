
-- Reference
-- http://nuclear.mutantstargoat.com/articles/sdr_fract/
--

require "GLSLProgram"
require "TargaLoader"

-- code for a julia set
-- navigation isn't quite as nice as with the mandelbrot
--
local julia = [[
uniform sampler1D tex;
uniform vec2 center;
uniform int iter;

void main() {
	vec2 z;
	z.x = 3.0 * (gl_TexCoord[0].x - 0.5);
	z.y = 2.0 * (gl_TexCoord[0].y - 0.5);

	int i;
	for(i=0; i<iter; i++) {
		float x = (z.x * z.x - z.y * z.y) + center.x;
		float y = (z.y * z.x + z.x * z.y) + center.y;

		if((x * x + y * y) > 4.0) break;
		z.x = x;
		z.y = y;
	}

	gl_FragColor = texture1D(tex, (i == iter ? 0.0 : float(i)) / 100.0);
}
]]


local fragtext = [[
uniform sampler1D tex;
uniform vec2 center;
uniform float scale;
uniform int iter;

void main() {
	vec2 z, c;

	c.x = 1.3333 * (gl_TexCoord[0].x - 0.5) * scale - center.x;
	c.y = (gl_TexCoord[0].y - 0.5) * scale - center.y;

	int i;
	z = c;
	for(i=0; i<iter; i++) {
		float x = (z.x * z.x - z.y * z.y) + c.x;
		float y = (z.y * z.x + z.x * z.y) + c.y;

		if((x * x + y * y) > 4.0) break;
		z.x = x;
		z.y = y;
	}

	gl_FragColor = texture1D(tex, (i == iter ? 0.0 : float(i)) / 200.0);
}
]]


local prog=0;
local cx = 0.7; cy = 0.0;
local scale = 2.2;
local iter = 70;
local zoom_factor = 0.025;
local xres = 0;
local yres = 0;

local EXIT_FAILURE = -1;

function init()
	-- load the 1D palette texture
	gl.glBindTexture(GL_TEXTURE_1D, 1);
	gl.glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	gl.glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	gl.glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_S, GL_REPEAT);

	local img, imgwidth, imgheight = ReadTargaFromFile("pal.tga")
	if(not img) then
		return EXIT_FAILURE;
	end

	gl.glTexImage1D(GL_TEXTURE_1D, 0, 4, 256, 0, GL_BGRA, GL_UNSIGNED_BYTE, img);

	glEnable(GL_TEXTURE_1D);

	-- load and set the mandelbrot shader
	gpuprog = GLSLProgram(fragtext)
	gpuprog:Use();

	gpuprog.iter = iter;
end

function drawfullviewquad()
	glBegin(GL_QUADS);
	glTexCoord2f(0, 0);
	glVertex2f(-1, -1);
	glTexCoord2f(1, 0);
	glVertex2f(1, -1);
	glTexCoord2f(1, 1);
	glVertex2f(1, 1);
	glTexCoord2f(0, 1);
	glVertex2f(-1, 1);
	glEnd();
end

function display()
	--gpuprog:Use();
	gpuprog.center = float2(cx, cy)
	gpuprog.scale = scale;

	drawfullviewquad();
end


function keychar(key, x, y)
	if key == '=' then
		iter = iter + 10;
		gpuprog.iter = iter;
	elseif key == '-' then
		iter = iter - 10;
		if(iter < 0) then
			iter = 0;
		end
		gpuprog.iter = iter;
	end
end

function reshape(x,y)
	xres = x;
	yres = y;

	glViewport(0,0,x,y)
end


local px, py;

function keydown(key, x, y)
	local px = 2.0 * (x / xres - 0.5);
	local py = 2.0 * (y / yres - 0.5);

	if key == VK_HOME then
		scale = scale * (1 - zoom_factor * 2.0);
	elseif key == VK_END then
		scale = scale * (1 + zoom_factor * 2.0)
	end

	if key == VK_LEFT then
		cx = cx + (scale / 2.0);
	elseif key == VK_RIGHT then
		cx = cx - (scale / 2.0);
	end

	if key == VK_UP then
		cy = cy - (scale / 2.0);
	elseif key == VK_DOWN then
		cy = cy + (scale / 2.0);
	end
end
