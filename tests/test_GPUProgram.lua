require "GLSLProgram"

-- Mandelbrot
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


-- Edge detection
local edgar = {}
edgar["vertext"] = [[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_MultiTexCoord0;
		}
	]];

edgar["fragtext"] = [[
#version 330 compatibility

uniform sampler2D sceneTex; // 0
uniform float vx_offset; // = 0.27;
uniform float vx_offset2; //  = 0.67;

uniform mat3 G[2] = mat3[]
(
	mat3( 1.0, 2.0, 1.0, 0.0, 0.0, 0.0, -1.0, -2.0, -1.0 ),
	mat3( 1.0, 0.0, -1.0, 2.0, 0.0, -2.0, 1.0, 0.0, -1.0 )
);

uniform mat3 G2[9] = mat3[]
(
	1.0/(2.0*sqrt(2.0)) * mat3( 1.0, sqrt(2.0), 1.0, 0.0, 0.0, 0.0, -1.0, -sqrt(2.0), -1.0 ),
	1.0/(2.0*sqrt(2.0)) * mat3( 1.0, 0.0, -1.0, sqrt(2.0), 0.0, -sqrt(2.0), 1.0, 0.0, -1.0 ),
	1.0/(2.0*sqrt(2.0)) * mat3( 0.0, -1.0, sqrt(2.0), 1.0, 0.0, -1.0, -sqrt(2.0), 1.0, 0.0 ),
	1.0/(2.0*sqrt(2.0)) * mat3( sqrt(2.0), -1.0, 0.0, -1.0, 0.0, 1.0, 0.0, 1.0, -sqrt(2.0) ),
	1.0/2.0 * mat3( 0.0, 1.0, 0.0, -1.0, 0.0, -1.0, 0.0, 1.0, 0.0 ),
	1.0/2.0 * mat3( -1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, -1.0 ),
	1.0/6.0 * mat3( 1.0, -2.0, 1.0, -2.0, 4.0, -2.0, 1.0, -2.0, 1.0 ),
	1.0/6.0 * mat3( -2.0, 1.0, -2.0, 1.0, 4.0, 1.0, -2.0, 1.0, -2.0 ),
	1.0/3.0 * mat3( 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 )
);


void main()
{
  vec2 uv = gl_TexCoord[0].xy;
  vec3 tc = vec3(1.0, 0.0, 0.0);

  if (uv.x < (vx_offset-0.005))
  {
    mat3 I;
    float cnv[2];
    vec3 sample;

    // fetch the 3x3 neighbourhood and use the RGB vector's length as intensity value
    for (int i=0; i<3; i++)
    {
      for (int j=0; j<3; j++)
      {
        sample = texelFetch(sceneTex, ivec2(gl_FragCoord.xy) + ivec2(i-1,j-1), 0).rgb;
        I[i][j] = length(sample);
      }
    }

    // calculate the convolution values for all the masks
    for (int i=0; i<2; i++)
    {
      float dp3 = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
      cnv[i] = dp3 * dp3;
    }

    tc = vec3(0.5 * sqrt(cnv[0]*cnv[0]+cnv[1]*cnv[1]));
  }
  else if ((uv.x >= (vx_offset+0.005)) && (uv.x < (vx_offset2-0.005)))
  {
    mat3 I;
    float cnv[9];
    vec3 sample;
    int i, j;

    // fetch the 3x3 neighbourhood and use the RGB vector's length as intensity value
    for (i=0; i<3; i++)
    {
      for (j=0; j<3; j++)
      {
        sample = texelFetch(sceneTex, ivec2(gl_FragCoord.xy) + ivec2(i-1,j-1), 0).rgb;
        I[i][j] = length(sample);
      }
    }

    // calculate the convolution values for all the masks
    for (i=0; i<9; i++)
    {
      float dp3 = dot(G2[i][0], I[0]) + dot(G2[i][1], I[1]) + dot(G2[i][2], I[2]);
      cnv[i] = dp3 * dp3;
    }

    //float M = (cnv[0] + cnv[1]) + (cnv[2] + cnv[3]); // Edge detector
    //float S = (cnv[4] + cnv[5]) + (cnv[6] + cnv[7]) + (cnv[8] + M);
    float M = (cnv[4] + cnv[5]) + (cnv[6] + cnv[7]); // Line detector
    float S = (cnv[0] + cnv[1]) + (cnv[2] + cnv[3]) + (cnv[4] + cnv[5]) + (cnv[6] + cnv[7]) + cnv[8];

    tc = vec3(sqrt(M/S));
  }
  else if (uv.x>=(vx_offset2+0.005))
  {
    tc = texture2D(sceneTex, uv).rgb;
  }
	gl_FragColor = vec4(tc, 1.0);
}
]];

function printValue(name, val, size)
print(name);
	for i=0,size-1 do
		print(val[i]);
	end
end


function test_Mandelbrot()
local prog = GLSLProgram(fragtext)
prog:Use();

local val, ncomps = 0


val = prog.iter
print(val)


prog.iter = 100
print("iter after set: ", prog.iter);

prog.scale = 23.7;
print("scale after set: ", prog.scale);

prog.center = float2(10,20);
print("center: ", prog.center[0], prog.center[1]);


prog.FragmentShader:Print();
end

function printUniforms(prog)
	local nUniforms = prog:GetActiveUniformCount();

	print("==== Uniforms ====");
	print(nUniforms);

	local lpsize = ffi.new("int[1]");
	local lputype = ffi.new("int[1]");
	local buff = Array1D(256, "char");
	local bufflen = 255;
	local lplength = ffi.new("int[1]");



	for loc=0,nUniforms-1 do
		ogm.glGetActiveUniform (prog.ID, loc, bufflen, lplength, lpsize, lputype, buff);
		local size = lpsize[0];
		local utype = lputype[0];
		local namelen = lplength[0];
		local iname = ffi.string(buff);

		print("==========");
		print("Name: ", iname);
		print("Location: ", loc);
		print(string.format("Type: 0x%x", utype));
		print("Size: ", size);
	end

end

function test_Edge()
	local prog = GLSLProgram(edgar.fragtext, edgar.vertext)
	prog:Use();

	--prog.vx_offset = 0.27;
	--prog.vx_offset2 = 0.67;

	--prog.FragmentShader:Print();
	--prog:Print();
	--printUniforms(prog);

	print(prog.vx_offset)
end


function printShader(self)
	print("==== Shader ====")
	print(string.format("Type: 0x%x", self:GetShaderType()))
	print(string.format("Delete Status: 0x%x", self:GetDeleteStatus()))
	print(string.format("Compile Status: 0x%x", self:GetCompileStatus()))
	print(string.format("Log Length: 0x%x", self:GetInfoLogLength()))
	print(string.format("Source Length: 0x%x", self:GetSourceLength()))
	print("==== SOURCE ====")
	print(self:GetSource());
	print("==== LOG ====");
	print(self:GetInfoLog());
end

function test_CompileShader()
	local vertshade = GLSLShader():CreateFromText(edgar.vertext, GL_VERTEX_SHADER);
	local fragshade = GLSLShader():CreateFromText(edgar.fragtext, GL_FRAGMENT_SHADER);

	printShader(vertshade);

	printShader(fragshade);
end


--test_Edge();
test_CompileShader();
