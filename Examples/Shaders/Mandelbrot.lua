
-- Reference
-- http://nuclear.mutantstargoat.com/articles/sdr_fract/
--

require "GLSLProgram"
require "TargaLoader"

local vertext = [[
//
// Vertex shader for drawing the Mandelbrot set
//
// Authors: Dave Baldwin, Steve Koren, Randi Rost
//          based on a shader by Michael Rivero
//
// Copyright (c) 2002-2005: 3Dlabs, Inc.
//
// See 3Dlabs-License.txt for license information
//

uniform vec3 LightPosition;
uniform float SpecularContribution;
uniform float DiffuseContribution;
uniform float Shininess;

varying float LightIntensity;
varying vec3  Position;

void main()
{
    vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);
    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);
    vec3 lightVec   = normalize(LightPosition - ecPosition);
    vec3 reflectVec = reflect(-lightVec, tnorm);
    vec3 viewVec    = normalize(-ecPosition);
    float spec      = max(dot(reflectVec, viewVec), 0.0);
    spec            = pow(spec, Shininess);
    LightIntensity  = DiffuseContribution *
                          max(dot(lightVec, tnorm), 0.0) +
                          SpecularContribution * spec;
    Position        = vec3(gl_MultiTexCoord0 - 0.5) * 5.0;
    gl_Position     = ftransform();

}
]]


local fragtext = [[
//
// Fragment shader for drawing the Mandelbrot set
//
// Authors: Dave Baldwin, Steve Koren, Randi Rost
//          based on a shader by Michael Rivero
//
// Copyright (c) 2002-2005: 3Dlabs, Inc.
//
// See 3Dlabs-License.txt for license information
//

varying vec3  Position;
varying float LightIntensity;

uniform float MaxIterations;
uniform float Zoom;
uniform float Xcenter;
uniform float Ycenter;
uniform vec3  InnerColor;
uniform vec3  OuterColor1;
uniform vec3  OuterColor2;

void main()
{
    float   real  = Position.y * Zoom + Xcenter;
    float   imag  = Position.x * Zoom + Ycenter;
    float   Creal = real;   // Change this line...
    float   Cimag = imag;   // ...and this one to get a Julia set

    float r2 = 0.0;
    float iter;

    for (iter = 0.0; iter < MaxIterations && r2 < 4.0; ++iter)
    {
        float tempreal = real;

        real = (tempreal * tempreal) - (imag * imag) + Creal;
        imag = 2.0 * tempreal * imag + Cimag;
        r2   = (real * real) + (imag * imag);
    }

    // Base the color on the number of iterations

    vec3 color;

    if (r2 < 4.0)
        color = InnerColor;
    else
        color = mix(OuterColor1, OuterColor2, fract(iter * 0.05));

    color *= LightIntensity;

    gl_FragColor = vec4(color, 1.0);
}
]]


local prog=0;
local cx = 0.7; cy = 0.0;
local scale = 0.5;
local iter = 70;
local zoom_factor = 0.025;
local xres = 0;
local yres = 0;

local EXIT_FAILURE = -1;

function init()
	-- load and set the mandelbrot shader
	gpuprog = GLSLProgram(fragtext, vertext)
	gpuprog:Use();


	-- Lighting in the vertex shader
	gpuprog.LightPosition = float3(0, 0, 4);
	gpuprog.SpecularContribution = 0.4;
	gpuprog.DiffuseContribution = 0.8;
	gpuprog.Shininess = 8;




	gpuprog.MaxIterations = iter;
	gpuprog.Zoom = 0.5;
	gpuprog.Xcenter = -0.4;
	gpuprog.Ycenter = 0;
	gpuprog.InnerColor = float3(0, 0, 0);
	gpuprog.OuterColor1 = float3(1, 0, 0);
	gpuprog.OuterColor2 = float3(0, 1,1);

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
	drawfullviewquad();
end


function keychar(key, x, y)
	if key == '=' then
		iter = iter + 10;
	elseif key == '-' then
		iter = iter - 10;
		if(iter < 0) then
			iter = 0;
		end
	end
	gpuprog.MaxIterations = iter;
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

	if key == VK_UP then
		cx = cx + (scale / 2.0);
	elseif key == VK_DOWN then
		cx = cx - (scale / 2.0);
	end

	if key == VK_LEFT  then
		cy = cy - (scale / 2.0);
	elseif key == VK_RIGHT then
		cy = cy + (scale / 2.0);
	end

	gpuprog.Xcenter = cx;
	gpuprog.Ycenter = cy;
	gpuprog.Zoom = scale;
end
