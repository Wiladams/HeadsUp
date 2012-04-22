local vertext = [[
void main(void)
{
  gl_Position = ftransform();
  gl_TexCoord[0] = gl_MultiTexCoord0;
}
]]

local fragtext = [[

uniform sampler2D sceneTex; // 0
uniform float vx_offset;
uniform float rnd_factor = 0.05;
uniform float rnd_scale = 5.1;
uniform vec2 v1 = vec2(92.,80.);
uniform vec2 v2 = vec2(41.,62.);

float rand(vec2 co)
{
  return fract(sin(dot(co.xy ,v1)) + cos(dot(co.xy ,v2)) * rnd_scale);
}

void main()
{
  vec2 uv = gl_TexCoord[0].xy;

  vec3 tc = vec3(1.0, 0.0, 0.0);
  if (uv.x < (vx_offset-0.005))
  {
    vec2 rnd = vec2(rand(uv.xy),rand(uv.yx));
    tc = texture2D(sceneTex, uv+rnd*rnd_factor).rgb;
  }
  else if (uv.x>=(vx_offset+0.005))
  {
    tc = texture2D(sceneTex, uv).rgb;
  }

  gl_FragColor = vec4(tc, 1.0);
}

]]


require "TargaLoader"
require "GLTexture"
require "GLSLProgram"

local height = 0

local img, imgwidth, imgheight = ReadTargaFromFile("Windmill.tga")
windmilltex = GLTexture(imgwidth, imgheight, GL_RGBA, img, GL_BGR, 3)

local gpuprog;
local windowwidth = 640
local windowheight = 480

function init()
	glClearColor(0,0,0,0);
	glShadeModel(GL_FLAT);
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

	-- load and set the mandelbrot shader
	gpuprog = GLSLProgram(fragtext, vertext)
	gpuprog:Use();

	gpuprog.sceneTex = 0; -- 0
	gpuprog.vx_offset = 0.5;
end


function drawfullviewquad()
	glBegin(GL_QUADS);

	glTexCoord2f(0, 0);
	glVertex2f(0, 0);

	glTexCoord2f(1, 0);
	glVertex2f(windowwidth, 0);

	glTexCoord2f(1, 1);
	glVertex2f(windowwidth, windowheight);

	glTexCoord2f(0, 1);
	glVertex2f(0, windowheight);

	glEnd();
end

function display()
	glClear(GL_COLOR_BUFFER_BIT);

	windmilltex:MakeCurrent()
	drawfullviewquad();

	glFlush();
end

function reshape(w,h)
	windowwidth = w
	windowheight = h
	gpuprog.vx_offset = 0.5;

	glViewport(0,0,w,h);

	height = h;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0,w, 0,h);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
end

function keydown(key, x, y)
	local offset = gpuprog.vx_offset;
	local offsetfactor = 0.01;

	if key == VK_LEFT then
		offset = offset - offsetfactor;
		if offset < 0 then offset = 0 end
	end

	if key == VK_RIGHT then
		offset = offset + offsetfactor;
		if offset > 1 then offset = 1 end
	end

	gpuprog.vx_offset = offset;
end
