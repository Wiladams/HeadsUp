
-- Reference
-- http://nuclear.mutantstargoat.com/articles/sdr_fract/
--


local fragtext = [[
#extension GL_ARB_gpu_shader_fp64 : enable

uniform sampler1D tex;
uniform dvec2 center;
uniform double scale;
uniform int iterations;

void main() {
	dvec2 z, c;

	c.x = 1.33333333 * (gl_TexCoord[0].x - 0.5) * scale - center.x;
	c.y = (gl_TexCoord[0].y - 0.5) * scale - center.y;

	int i;
	z = c;
	for(i=0; i<iterations; i++) {
		double x = (z.x * z.x - z.y * z.y) + c.x;
		double y = (z.y * z.x + z.x * z.y) + c.y;

		if((x * x + y * y) > 4.0) break;
		z.x = x;
		z.y = y;
	}

	if (i == iterations)
	{
		gl_FragColor = texture(tex, 0.0);
	} else
	{
		float offset = (float(i)/(iterations-1));
		gl_FragColor = texture(tex, offset);
	}
}
]]




local prog=0;
local cx = 0.7; cy = 0.0;
local scale = 2.2;
local iter = 70;
local zoom_factor = 0.025;
local xres = 0;
local yres = 0;

local dragging = false;

local EXIT_FAILURE = -1;

function constructTexture()
	local length = 1024*10;

	glEnable(GL_TEXTURE_1D);

	local tid = ffi.new( "GLuint[1]" )
	gl.glGenTextures( 1, tid )
	--checkGL( "glGenTextures" )
	local texid = tid[0]

	-- load the 1D palette texture
	gl.glBindTexture(GL_TEXTURE_1D, texid);
	gl.glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	gl.glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	gl.glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_S, GL_REPEAT);


	local img = Array1D(length*4, "uint8_t");
	for i = 0, length-1 do
		img[(i*4)+0] = map(i, 0,length-1, 0,math.sin(i)*math.cos(i)*255);		-- Blue
		img[(i*4)+1] = map(i, 0,length-1, 0,math.cos(i)*255);	-- Green
		img[(i*4)+2] = map(i, 0,length-1, 0,math.sin(i)*255);	-- Red
		img[(i*4)+3] = 255;
	end

	gl.glTexImage1D(GL_TEXTURE_1D, 0, 4, length, 0, GL_BGRA, GL_UNSIGNED_BYTE, img);
end

function init()
	constructTexture();

	-- load and set the mandelbrot shader
	gpuprog = GLSLProgram(fragtext)
	gpuprog:Use();

	gpuprog:Validate();
print("Validation: ", gpuprog:GetValidateStatus())
	gpuprog.iterations = iter;
	gpuprog.scale = scale;
end

function drawfullviewquad()
	glBegin(GL_QUADS);
	  glTexCoord2d(0, 0);
	  glVertex2d(-1, -1);

	  glTexCoord2d(1, 0);
	  glVertex2d(1, -1);

	  glTexCoord2d(1, 1);
	  glVertex2d(1, 1);

	  glTexCoord2d(0, 1);
	  glVertex2d(-1, 1);
	glEnd();
end

function display()
	gpuprog.center = double2(cx, cy)
	gpuprog.scale = scale;

	drawfullviewquad();
end


function keychar(key, x, y)
	if key == '=' then
		iter = iter + 10;
		gpuprog.iterations = iter;
	elseif key == '-' then
		iter = iter - 10;
		if(iter < 0) then
			iter = 0;
		end
		gpuprog.iterations = iter;
	end
	print("Iterations: ", iter);
end

function reshape(x,y)
	xres = x*2;
	yres = y*2;

	glViewport(0,0,x,y)
end


local px, py;

function keydown(key, x, y)
	local px = 2.0 * (x / xres - 0.5);
	local py = 2.0 * (y / yres - 0.5);

	--print(string.format("Keydown: 0x%x", key));

	-- Home - reset scale and center
	if key == VK_HOME then
		cx = 0.7; cy = 0.0;
		scale = 2.2;
		iter = 70;
	end

	-- PageUp, PageDown
	if key == VK_PRIOR then
		scale = scale * (1 - zoom_factor * 2.0);
	elseif key == VK_NEXT then
		scale = scale * (1 + zoom_factor * 2.0)
	end

	if key == VK_LEFT then
		cx = cx + (scale / 8.0);
	elseif key == VK_RIGHT then
		cx = cx - (scale / 8.0);
	end

	if key == VK_UP then
		cy = cy - (scale / 8.0);
	elseif key == VK_DOWN then
		cy = cy + (scale / 8.0);
	end
end


local lastmousex = 0;
local lastmousey = 0;

function mousedown(x, y, modifiers, button)
	dragging = true;
	lastmousex = x;
	lastmousey = y;
end

function mouseup(x, y, modifiers, button)
	dragging = false;
end


function mousemove(x, y, modifiers)
	if not dragging then return end;

	local dx = x - lastmousex;
	local dy = y - lastmousey;

	local signdx = sign(dx);
	local signdy = sign(dy);

	cx = cx + signdx * (scale / 64.0);
	cy = cy - signdy * (scale / 64.0);

	lastmousex = x;
	lastmousey = y;
end

function mousewheel(x, y, modifiers, delta)
	if delta == 1 then
		scale = scale * (1 - zoom_factor * 2.0);
	elseif delta == -1 then
		scale = scale * (1 + zoom_factor * 2.0)
	end
end


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


local mandeldouble = [[
#version 150

uniform int iterations;
uniform int frame;
uniform float radius;

uniform dvec2 d_c;
uniform dvec2 d_s;
uniform double d_z;

float dmandel(void)
{
 dvec2 c = d_c + dvec2(gl_TexCoord[0].xy)*d_z + d_s;
 dvec2 z = c;

  for(int n=0; n<iterations; n++)
    {
    z = dvec2(z.x*z.x - z.y*z.y, 2.0lf*z.x*z.y) + c;
    if(length(vec2(z.x,z.y)) > radius)
        {
        return(float(n) + 1. - log(log(length(vec2(z.x,z.y))))/log(2.));    // http://linas.org/art-gallery/escape/escape.html
        }
    }
  return 0.;
}

void main()
{
  float n = dmandel();

  gl_FragColor = vec4((-cos(0.025*n)+1.0)/2.0,
                      (-cos(0.08*n)+1.0)/2.0,
                      (-cos(0.12*n)+1.0)/2.0,
                       1.0);
}
]];
