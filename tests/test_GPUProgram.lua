require "GLSLProgram"

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

	gl_FragColor = texture1D(tex, (i == iter ? 0.0 : float(i)) / 100.0);
}
]]

function printValue(name, val, size)
print(name);
	for i=0,size-1 do
		print(val[i]);
	end
end

local prog = GLSLProgram(fragtext)
prog:Use();

local val, ncomps = 0


val = prog.iter
print(val)

--[[
prog:GetUniform("scale");
prog:GetUniform("center");
prog:GetUniform("tex");
--]]


prog.iter = 100
print("iter after set: ", prog.iter);

prog.scale = 23.7;
print("scale after set: ", prog.scale);

prog.center = float2(10,20);
print("center: ", prog.center[0], prog.center[1]);

--[[
prog:SetUniformValue("iter", 100);
val, ncomps = prog:GetUniformValue("iter");
printValue("iter", val, ncomps);

prog:SetUniformValue("scale", 23.70);
val, ncomps = prog:GetUniformValue("scale");
printValue("scale", val, ncomps);

prog:SetUniformValue("center", float2(10,20));
--local center = float2(10,20)
--ogm.glUniform2fv(0, 1, center);
val, ncomps = prog:GetUniformValue("center");
printValue("center", val, ncomps);

print(prog.center);

--]]
